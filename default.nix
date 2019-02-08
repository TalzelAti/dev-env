# { nixpkgs ? import <nixpkgs>
#           { config.allowUnfree = true;
#             config.allowBroken = true;
#           }
# }:
# with nixpkgs;

## nixpkgs is pinned down to 18.03 because nix-mode doesnt work well with v26.1, but works fine with 25.3
let
  nixpkgsTarGz = builtins.fetchTarball
            { name   = "18.03";
              url    = "https://github.com/NixOS/nixpkgs/archive/18.03.tar.gz";
              sha256 = "0hk4y2vkgm1qadpsm4b0q1vxq889jhxzjx3ragybrlwwg54mzp4f";
            };
  nixpkgs = import nixpkgsTarGz { config.allowUnfree = true; config.allowBroken = true; };
  vim           = import ./vim.nix {inherit nixpkgs;};
  emacs         = import ./emacs.nix {inherit nixpkgs;};
  atidot-ranger = import ./ranger.nix {inherit nixpkgs;};

in with nixpkgs;
stdenv.mkDerivation rec {
  name = "talz-env";

  # Mandatory boilerplate for buildable env
  env = buildEnv { name = name; paths = buildInputs; };
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln -s $env $out
  '';

  # Customizable development requirements
  buildInputs = [
    vim
    silver-searcher
    emacs
    ranger
    findutils
    #fzf
  ];

#  shellHook = atidot-common.shellHook
#            + ''
#    export PS1_NAME=${name}
#    export NIX_SHELL_PATH='${env}'
#  '';

  shellHook = ''
    function parse_git_branch {
        git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
    }
    export PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi) \[\033[0;31m\]$(date +%H:%M)\[\033[00m\] \[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[\033[01;35m\]$(parse_git_branch)\[\033[00m\]\$ "
  '';
}
