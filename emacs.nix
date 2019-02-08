{ nixpkgs }:
with nixpkgs;
let
  emacs = emacsWithPackages (epkgs: with epkgs.melpaPackages; [
  # evil
  #   avy
  #   evil
  #   evil-surround
  #   evil-indent-textobject
  #   evil-cleverparens
  #   undo-tree
  # # haskell
  #   haskell-mode
  #   flycheck-haskell
  #   company-ghci  # provide completions from inferior ghci
  dhall-mode
  #   lsp-haskell
  #   hindent

  # # nix
  haskell-mode
  yaml-mode
  nix-mode
  fzf

  ace-jump-mode
  ac-slime
  haskell-mode
  markdown-mode
  json-mode
  avy
  xterm-color
  #hlint
  #   nix-buffer

  # # other
  #   ace-jump-mode
  #   ac-slime
  #   markdown-mode
  #   json-mode
  #   yaml-mode
  ]);
in
stdenv.mkDerivation rec {
  name = "tal-emacs";

  # Mandatory boilerplate for buildable env
  env = buildEnv { name = name; paths = buildInputs; };
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln -s $env $out
  '';

  # Customizable development requirements
  buildInputs = [
    emacs
  ];
}
