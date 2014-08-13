" 互換モードOFF
set nocompatible

set number
set title
set ruler
" インデントがらみ
set autoindent
set smartindent

" タブ幅は4
set tabstop=4
set shiftwidth=4
set noexpandtab
" BS関連の処理方法
set backspace=indent,eol,start
" マウス有効
set mouse=a
" ヘルプ関連
set runtimepath+=~/.vim/vimdoc-ja
set helplang=ja,en
helptags ~/.vim/vimdoc-ja/doc
" 一部全角文字の扱いを2文字幅とする
set ambiwidth=double
" 色関連の設定
syntax on
highlight Normal ctermbg=black ctermfg=grey
highlight StatusLine term=none cterm=none ctermfg=black ctermbg=grey
