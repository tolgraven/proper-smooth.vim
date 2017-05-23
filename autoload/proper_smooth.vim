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
let s:proper_smooth_steps_baseline 	= 10
let s:state = { 'fuel': 0, 'velocity': 0, 'target': 0}

" XXX: heed 'scroll' value would be good, if trying to really 1:1 mirror default

function! s:tick(timer_id)
  let s:state.fuel 			-= s:state.velocity

  let l:int_delta 		= float2nr(s:state.velocity >= 0 ? floor(s:state.velocity) : ceil(s:state.velocity))
	" XXX prob want to make sure not triggering autocmds here, cursormoved and whatnot...
	" ie currently makes cursorword highlight trigger whole jumping etc, that'd
	" prob murder a lesser machine
	execute "noautocmd normal! " . string(abs(l:int_delta)) . (l:int_delta > 0 ? "\<C-e>" : "\<C-y>")
	execute "noautocmd normal! " . string(abs(l:int_delta)) . (l:int_delta > 0 ? "j" : "k")

	let s:state.velocity = s:state.velocity * 0.66

	" set timer if momentum. else kill any residual, hard jump to target so is foolproof
  if abs(s:state.velocity) >= 1
    " let l:interval = float2nr(round(s:proper_smooth_interval))
		let l:interval = s:proper_smooth_interval

    let s:timer = timer_start(l:interval, function('s:tick'))
  else
		let s:state.velocity = 0 	| let s:state.fuel = 0
		" call cursor(s:state.target, getpos('.')) | let s:state.target = 0
		" execute "normal! " . s:state.target . "gg"
		" avoid setting jump mark by using : instead of gg
		execute 'normal! :' . s:state.target
		let s:state.target = 0
  endif
endfunction


function! proper_smooth#go(screens)
	if s:state.velocity != 0
		call timer_stop(s:timer)
		" call cursor(s:state.target)
		" execute "normal! " . s:state.target . "gg"
		execute 'normal! :' . s:state.target
		let s:state.velocity = 0 | let s:state.fuel = 0
	endif
	let l:lastline = line('$') 	"current pos
  let s:state.fuel 			= a:screens * winheight(0) "total distance to move
	" XXX have to adapt target to heed wrapped lines(?) and def FOLDS
	" use some line() expr i guess?
	" also curr off by 1 it seems (<c-u> x 2 = 2 lines behind if jumping back after orig-mapped <c-f>)

	let s:state.target 		= float2nr(round(line('.') + s:state.fuel))
	if 		 s:state.target > l:lastline | let s:state.target = l:lastline
	elseif s:state.target < 0 		 | let s:state.target = 0
	endif
	" let s:state.velocity 	= s:state.fuel / s:proper_smooth_steps_baseline
	let s:state.velocity 	= float2nr(round(s:state.fuel / 4)) 	"initial speed
	" let s:state.velocity 	= float2nr(round(s:state.fuel / 5)) 	"initial speed

  " Start a thread
  let s:timer = timer_start(0, function('s:tick'))
	" echo s:state
endfunction


let &cpoptions = s:save_cpo | unlet s:save_cpo
