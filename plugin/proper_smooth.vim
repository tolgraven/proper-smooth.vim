"=============================================================================
" File: proper_smooth.vim
" Author: Joen Tolgraven
" Created: 2017-04-27
"=============================================================================
scriptencoding utf-8
if exists('g:loaded_proper_smooth') | finish | endif | let g:loaded_proper_smooth=1
let s:save_cpo = &cpoptions 	| set cpoptions&vim

if !get(g:,'proper_smooth_no_default_key_mappings', 0)
  nnoremap <silent> <Plug>proper_smooth_d  :call proper_smooth#go(0.5)<CR>
  nnoremap <silent> <Plug>proper_smooth_u  :call proper_smooth#go(-0.5)<CR>
  nnoremap <silent> <Plug>proper_smooth_f  :call proper_smooth#go(1.0)<CR>
  nnoremap <silent> <Plug>proper_smooth_b  :call proper_smooth#go(-1.0)<CR>
	" while debugging
	nmap 	<C-d>	 <Plug>proper_smooth_d
  nmap 	<C-u>	 <Plug>proper_smooth_u
  nmap 	<C-f>	 <Plug>proper_smooth_f
  nmap 	<C-b>	 <Plug>proper_smooth_b
endif

let &cpoptions = s:save_cpo | unlet s:save_cpo
