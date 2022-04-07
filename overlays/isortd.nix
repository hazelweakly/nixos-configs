final: prev: {
  isortd = prev.python3Packages.buildPythonApplication rec {
    pname = "isortd";
    version = "0.1.7";

    src = prev.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-OTMvtwcubzKqpPhVqfFHKzJv0hfcmp/Y6UNs/C2+Mlo=";
    };
    propagatedBuildInputs = with prev.python3Packages; [ isort aiohttp click aiohttp-cors ];

    prePatch = ''
      substituteInPlace setup.py --replace 'click>=7.1.2,<8.0.0' 'click>=7.1.2,<9.0.0'
      sed -i setup.py -e "31i \    'entry_points': { 'console_scripts': ['isortd=isortd.main:main'] }"
    '';

    doCheck = false;
  };
}
