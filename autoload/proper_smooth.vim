"============================================================================y
" File: proper_smooth.vim
" Author: Joen Tolgraven
" Created: 2017-04-27
"=============================================================================
scriptencoding utf-8
if !exists('g:loaded_proper_smooth') | 	finish | endif | let g:loaded_proper_smooth=1
let s:save_cpo = &cpoptions | set cpoptions&vim

" let s:proper_smooth_interval 				= get('g:', proper_smooth_interval, 10)
let s:proper_smooth_interval 				= 15
" let s:proper_smooth_steps_baseline 	= get('g:', proper_smooth_steps_baseline, 10)
" let s:proper_smooth_steps_baseline 	= 10
let s:state = { 'fuel': 0, 'velocity': 0, 'target': 0}

" XXX: heed 'scroll' value would be good, if trying to really 1:1 mirror default
function! s:tick(timer_id)
  let s:state.fuel 			-= s:state.velocity

  let l:int_delta 		= float2nr(s:state.velocity >= 0 ? floor(s:state.velocity) : ceil(s:state.velocity))
	" execute "normal! " . string(abs(l:int_delta)) . (l:int_delta > 0 ? "\<C-e>" : "\<C-y>")
	execute "normal! " . string(abs(l:int_delta)) . (l:int_delta > 0 ? "j" : "k")

	let s:state.velocity = s:state.velocity * 0.8

	" set timer if momentum. else kill any residual + hard jump to target so is foolproof
  if abs(s:state.velocity) >= 1
		let s:interval += 1
    let s:timer = timer_start(s:interval, function('s:tick'))
  else
		call s:cleanup()
  endif
endfunction


function! proper_smooth#go(screens)
	call s:cleanup()
	let s:save_eventignore = &eventignore | set eventignore=all

	let s:interval = s:proper_smooth_interval
	let l:lastline = line('$')
  let s:state.fuel 			= float2nr(round(a:screens * winheight(0))) "total distance to move
	" XXX have to adapt target to heed wrapped lines(?) and def FOLDS
	" use some line() expr i guess?
	" also curr off by 1 it seems (<c-u> x 2 = 2 lines behind if jumping back after orig-mapped <c-f>)

	let s:state.target 		= line('.') + s:state.fuel
	" execute "normal! " .
	" let s:state.target 	= line('.')

	let s:state.target = s:state.target > l:lastline ? l:lastline : s:state.target < 1 ? 1 : s:state.target
	let s:state.velocity 	= float2nr(round(s:state.fuel / 4)) 	"initial speed

  let s:timer = timer_start(0, function('s:tick'))
endfunction


function! s:cleanup()
	if exists('s:timer') | call timer_stop(s:timer) | endif
	if exists('s:save_eventignore') | let &eventignore = s:save_eventignore | unlet s:save_eventignore | endif
	if s:state.target != 0
		" avoid setting jump mark by using : instead of gg
		execute ':' . s:state.target
	endif
	let s:state.target = 0 | let s:state.fuel = 0 | let s:state.velocity = 0
endfunction


let &cpoptions = s:save_cpo | unlet s:save_cpo
