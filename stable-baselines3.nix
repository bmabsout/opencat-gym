{ lib
, fetchFromGitHub
, buildPythonPackage
, autoPatchelfHook
, python
, stdenv
, gymnasium
, numpy
, torch
, cloudpickle
, pandas
, matplotlib
, pytest
, callPackage
}:

buildPythonPackage rec {
  pname = "stable-baselines3";
  version = "2.3.2";
  pyproject=true;

  src = fetchFromGitHub {
    owner = "DLR-RM";
    repo = "stable-baselines3";
    rev = "v${version}";
    sha256 = "sha256-024kQVmuIs7jCt1m2a6cXKORAkpPK59XK3fVWDrO4ts=";
  };

  patchPhase= ''
  '';

  propagatedBuildInputs = [
    numpy
    (callPackage ./gymnasium.nix {})
    torch
    cloudpickle
    pandas
    matplotlib
    pytest
  ];

  doCheck=false;

  buildInputs = [
    stdenv.cc.cc.lib
    # (callPackage ./gymnasium.nix {})
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  meta = with lib; {
    homepage = "https://github.com/DLR-RM/stable-baselines3";
    license = licenses.mit;
    platforms = with platforms; (linux);
  };
}