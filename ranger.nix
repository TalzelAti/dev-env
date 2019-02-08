{ nixpkgs }:
with nixpkgs;
python27Packages.buildPythonApplication rec {
  name = "ranger";

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = http://ranger.nongnu.org/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchgit {
    url = "https://github.com/ranger/ranger";
    rev = "35f47f53a32b29f746c5ddcd4fb367bf2ad7e640";
    sha256 = "0dz1rdhjkn7yva4nld0spim3qsa9abn2xb7rbhhznsksmvjljxgr";
  };

  checkInputs = with pythonPackages; [ pytest ];
  propagatedBuildInputs = [ file
                            w3m
                            highlight
                            atool
                            mediainfo
                            odt2txt
                            xsv
                            jq
                            binutils
                            #genson
                          ];

  checkPhase = ''
    py.test tests
  '';

  preConfigure = ''
    cp ${scope} ranger/data/scope.sh
    substituteInPlace ranger/data/scope.sh \
      --replace "/bin/echo" "echo"

    substituteInPlace ranger/__init__.py \
      --replace "DEFAULT_PAGER = 'less'" "DEFAULT_PAGER = '${stdenv.lib.getBin less}/bin/less'"
    for i in ranger/config/rc.conf doc/config/rc.conf ; do
      substituteInPlace $i --replace /usr/share $out/share
    done
    substituteInPlace ranger/config/rc.conf \
      --replace "set preview_script ~/.config/ranger/scope.sh" "set preview_script $out/share/doc/ranger/config/scope.sh"
    substituteInPlace ranger/ext/img_display.py \
      --replace /usr/lib/w3m ${w3m}/libexec/w3m
    # give image previews out of the box when building with w3m
    substituteInPlace ranger/config/rc.conf \
      --replace "set preview_images false" "set preview_images true" \
  '';

  scope = ./scope.sh;
}
