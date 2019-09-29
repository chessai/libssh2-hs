{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, c2hs, libssh2, network
      , stdenv, syb, time, unix
      }:
      mkDerivation {
        pname = "libssh2";
        version = "0.2.0.7";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [ base bytestring network syb time unix ];
        librarySystemDepends = [ libssh2 ];
        libraryPkgconfigDepends = [ libssh2 ];
        libraryToolDepends = [ c2hs ];
        homepage = "https://github.com/portnov/libssh2-hs";
        description = "FFI bindings to libssh2 SSH2 client library (http://libssh2.org/)";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
