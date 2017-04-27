"=============================================================================
" File: proper_smooth.vim
" Author: Joen Tolgraven
" Created: 2017-04-27
"=============================================================================
scriptencoding utf-8
if exists('g:loaded_proper_smooth') | finish | endif | let g:loaded_proper_smooth=1
let s:save_cpo = &cpoptions 	| set cpoptions&vim

if !exists('g:proper_smooth_no_default_key_mappings') ||
\  !g:proper_smooth_no_default_key_mappings
  nnoremap <silent> <C-d> :call proper_smooth#flick(0.5)<CR>
  nnoremap <silent> <C-u> :call proper_smooth#flick(-0.5)<CR>
  nnoremap <silent> <C-f> :call proper_smooth#flick(1.0)<CR>
  nnoremap <silent> <C-b> :call proper_smooth#flick(-1.0)<CR>
endif

let &cpoptions = s:save_cpo | unlet s:save_cpo
