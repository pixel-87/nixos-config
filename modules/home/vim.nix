{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.vim;
in
{
  options.myModules.vim = {
    enable = lib.mkEnableOption "vim editor with sensible defaults";
  };

  config = lib.mkIf cfg.enable {
    programs.vim = {
      enable = true;

      extraConfig = ''
        " basic editing
        set nocompatible
        filetype plugin indent on
        syntax on
      
        " identation
        set expandtab
        set shiftwidth=2
        set softtabstop=2
        set tabstop=2
        set autoindent
        set smartindent

        " Visuals
        set number
        set relativenumber
        set cursorline
        set nowrap
    
        " Clipboard & mouse
        set clipboard=unnamedplus
        set mouse=a
    
        " splitting
        set splitbelow
        set splitright
    
        " performance / searching
        set lazyredraw
        set incsearch
        set ignorecase
        set smartcase
      '';
    };
  };
}
