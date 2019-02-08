{ nixpkgs }:
with nixpkgs;
let
  minimap = vimUtils.buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "minimap";
    src = fetchgit {
      url = "https://github.com/severin-lemaignan/vim-minimap";
      rev = "3f87acbe106276e3ade03d91cbaaf27d3533ea25";
      sha256 = "1lx3xp5kr8f84mgh0xy2q3q0v8n2ym0sk42f02xal51b62k4plkb";
    };
    dependencies = [];
  };

  vim-ranger = vimUtils.buildVimPluginFrom2Nix {
    name = "vim-ranger";
    src = fetchgit {
      url = "https://github.com/francoiscabrol/ranger.vim";
      rev = "b77a534bc5bc52ffdb4eb213d4aff39c2dc75a76";
      sha256 = "0g5rlcjlz45wfaipmdc5d0v3hqljn9j8k7m6zvzmg3h1nzbzhb4w";
    };
    dependencies = [];
  };

  gitv = vimUtils.buildVimPluginFrom2Nix {
    name = "gitv";
    src = fetchgit {
      url = "https://github.com/gregsexton/gitv";
      rev = "14fcbf59747c4d4215a3c5d7413d560b63c9eefa";
      sha256 = "02gj7rplanc6grcrprpigw8jpsr82k2sdx3m89253cr23gsvh050";
    };
    dependencies = [];
  };

  gv = vimUtils.buildVimPluginFrom2Nix {
    name = "gv";
    src = fetchgit {
      url = "https://github.com/junegunn/gv.vim";
      rev = "299146147bb6b8379b1a178a1df890e3bb40f2b1";
      sha256 = "0ia8796kg7hn1hjyhm52zhr2hx810mmr7hm35hk3sjl3zs773b6l";
    };
    dependencies = [];
  };

  vimagit = vimUtils.buildVimPluginFrom2Nix {
    name = "vimagit";
    src = fetchgit {
      url = "https://github.com/jreybert/vimagit";
      rev = "0549731101b8c341d9732d3e9d74c6ba09bbf3ea";
      sha256 = "0msaljqqcyj5jvabzzsmrg44sx31h1y2lds2lc51yyzmaxc9albx";
    };
    dependencies = [];
  };

  vim-bookmarks = vimUtils.buildVimPluginFrom2Nix {
    name = "vim-bookmarks";
    src = fetchgit {
      url = "https://github.com/MattesGroeger/vim-bookmarks";
      rev = "7b404c4739661ea1fc8ee0b24897376f0fbb320e";
      sha256 = "1pyfi0xkp45ambgqcq2qmr0wcb2wp2vq5lyl3nq38v7lyfw4j3xn";
    };
    dependencies = [];
  };


in
vim_configurable.customize {
  # Specifies the vim binary name.
  # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
  # This allows to have multiple vim packages installed (e.g. with a different set of plugins)
  name = "vim";

  vimrcConfig.customRC = ''
set t_Co=256
set clipboard=unnamedplus
set gfn=Bitstream\ Vera\ Sans\ Mono\ 11
set noswapfile
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set autoindent
set showmatch
set nu
set incsearch
set nows
set nowrap
set ic
set hlsearch
syn on
set ls =2
set smarttab
set linebreak
set smartindent
set cindent
set tags=tags;/
set hls
set vb
set t_vb=
set backspace=2
set encoding=utf-8
set grepprg=ag
set background=dark
hi cursorline term=NONE ctermbg=DarkBlue
hi cursorcolumn term=NONE ctermbg=darkblue
hi Visual cterm=None ctermbg=DarkBlue ctermfg=None guibg=DarkBlue
hi Search cterm=None ctermfg=grey ctermbg=blue

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent> ` :bd<CR>

let mapleader = ","

let g:EasyMotion_keys = get(g:, 'EasyMotion_keys', 'asdghklqwertyuiopzxcvbnmfj')
let g:EasyMotion_smartcase = 0
let g:EasyMotion_do_shade = 1
let g:EasyMotion_inc_highlight = 0
map <Leader>; <Leader><Leader>b
map ; <Leader><Leader>w
map <leader>r :NERDTreeFind<cr>

nnoremap <Leader>. :CtrlPMRU<CR>
nnoremap <Leader>/ :RainbowToggle<CR>

let g:gitgutter_enabled = 1
let g:gitgutter_realtime = 1
let g:gitgutter_highlight_lines = 0
let g:gitgutter_eager = 1
let g:rainbow_active = 0
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
noremap <Leader>a :Ack! <cword><cr>
nmap <F8> :TagbarToggle<CR>
nmap t    :Tabularize /=<CR>:Tabularize /::<CR>
'';

  vimrcConfig.packages.gitv.start = with vimPlugins; [ gitv ];
  vimrcConfig.packages.gv.start = with vimPlugins; [ gv ];
  vimrcConfig.packages.vimagit.start = with vimPlugins; [ vimagit ];
  vimrcConfig.packages.vim-bookmarks.start = with vimPlugins; [ vim-bookmarks ];
  vimrcConfig.packages.vim-ranger.start = with vimPlugins; [ vim-ranger ];
  vimrcConfig.packages.minimap.start = with vimPlugins; [ minimap ];
  vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
  vimrcConfig.vam.pluginDictionaries = [ { names = [
    "easymotion"
    "ctrlp"
    "colors-solarized"
    "supertab"
    "tagbar"
    "lushtags"
    "nerdtree"
    "nerdcommenter"
    "vim-closetag"
    "fugitive"
    "gitgutter"
    "airline"
    "ghcmod"
    "vimproc"
    "undotree"
    "vim-nix"
    "rainbow"
    "vim-easy-align"
    "vim-trailing-whitespace"
    "vim-multiple-cursors"
    "tabular"
    "ack-vim"
    "vim-expand-region"
    ]; }
  ];
}
