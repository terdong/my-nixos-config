{ pkgs-unstable, ... }:
{
  programs.vim = {
    enable = true;

    plugins = with pkgs-unstable.vimPlugins; [
      vim-airline       # Status/tabline
      vim-fugitive      # Git integration
      vim-nix           # Nix syntax highlighting
    ];

    # Vim configuration (traditionally .vimrc)
    extraConfig = ''
      " Basic Settings
      set number          " Show line numbers
      set expandtab       " Convert tabs to spaces
      set tabstop=2       " Number of spaces for tab
      set shiftwidth=2    " Number of spaces for autoindent
      set autoindent      " Copy indent from current line
      set smartindent     " Smart autoindenting
      set wrap            " Enable line wrapping

      " Search Settings
      set ignorecase             " Ignore case when searching
      set smartcase              " Case-sensitive if query has uppercase
      set incsearch              " Highlight matches as you type
      set hlsearch               " Keep matches highlighted after search

      " Convenience Features
      set clipboard=unnamedplus  " Use system clipboard
      set mouse=a                " Enable mouse in all modes

      " Visual Settings
      syntax on             " Enable syntax highlighting
      set showmatch         " Highlight matching brackets
      colorscheme koehler   " Choose a colorscheme

      " Key Mappings
      let mapleader = ","
      nnoremap <leader>w :w<CR>
      nnoremap <leader>q :q<CR>
      nnoremap <Space> :noh<CR>  " Clear search highlights with Space
      nnoremap <C-s> :w<CR>      " Save with Ctrl+s
      vnoremap < <gv             " Indent visually selected text left
      vnoremap > >gv             " Indent visually selected text right
      nnoremap Y y$              " Make 'Y' behave like 'D' and 'C'

      " Airline (Status Bar) Settings
      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1
    '';
  };
}
