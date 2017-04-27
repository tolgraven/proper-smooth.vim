"============================================================================y
" File: proper_smooth.vim
" Author: Joen Tolgraven
" Created: 2017-04-27
"=============================================================================
scriptencoding utf-8
if !exists('g:loaded_proper_smooth') | finish | endif | let g:loaded_proper_smooth=1
let s:save_cpo = &cpoptions | set cpoptions&vim

" Default values
if !exists('g:proper_smooth') | let g:proper_smooth = {} | endif
let g:proper_smooth.interval 	= get('g:proper_smooth', interval, 10)
let g:proper_smooth.steps 		= get('g:proper_smooth', steps, 10)
" let g:proper_smooth.ticks_to_decr 	= get('g:proper_smooth', air_drag, 2.0)
let s:ps = g:proper_smooth
" if !exists('g:proper_smooth_interval')
"   let g:proper_smooth_interval = 1000.0 / 60
" endif
" if !exists('g:proper_smooth_friction')
"   let g:proper_smooth_friction = 80.0
" endif
" if !exists('g:proper_smooth_air_drag')
"   let g:proper_smooth_air_drag = 2.0
" endif
" if !exists('g:proper_smooth_scroll_down_key')
"   let g:proper_smooth_scroll_down_key = "\<C-e>"
" endif
" if !exists('g:proper_smooth_scroll_up_key')
"   let g:proper_smooth_scroll_up_key = "\<C-y>"
" endif

let s:state = { 'impulse': 0.0, 'velocity': 0.0, 'delta': 0.0 }


function! s:tick(timer_id)
  let l:wait = s:ps.interval / 1000.0  " Unit conversion: ms -> s
	" XXX	oh yeah so easiest way to fake some friction is I guess just incr the wait
	" period between each tick so goes slower towards end?

  " Compute resistance forces
  " let l:vel_sign = s:state.velocity == 0 	? 0 : s:state.velocity / abs(s:state.velocity)
  " let l:friction         = -l:vel_sign 				* s:ps.friction
  " let l:air_drag         = -s:state.velocity 	* s:ps.air_drag
  " let l:additional_force = 	l:friction 				+ l:air_drag
	

  " Update state
  let s:state.delta 	 += s:state.velocity * l:wait
  " let s:state.velocity += s:state.impulse + (abs(l:additional_force * l:wait) > abs(s:state.velocity) 
	" \ 										? -s:state.velocity 	: l:additional_force * l:wait)
	let s:state.velocity 	= s:state.velocity - 1
  let s:state.impulse 	= 0

  " Scroll
  let l:int_delta 		= float2nr(s:state.delta >= 0 ? floor(s:state.delta) : ceil(s:state.delta))
  let s:state.delta  -= l:int_delta
  " if l:int_delta 			> 0
  "   execute "normal! " . string(abs(l:int_delta)) . "\<C-e>"
  " elseif l:int_delta 	< 0
  "   execute "normal! " . string(abs(l:int_delta)) . "\<C-y>"
	" endif
	execute "normal! " . string(abs(l:int_delta)) . (l:int_delta > 0 ? "\<C-e>" : "\<C-y>")
	execute "normal! " . string(abs(l:int_delta)) . (l:int_delta > 0 ? "j" : "k")

	" set timer, if there's still enough momentum. else kill any residual.
  if abs(s:state.velocity) >= 1
    let l:interval = float2nr(round(s:ps.interval))
    call timer_start(l:interval, function('s:tick'), {'repeat': 0})
  else
		let s:isrunning 
		let s:state.velocity = 0 	| let s:state.delta = 0
  endif
endfunction


" function! proper_smooth#go(impulse)
function! proper_smooth#go(screens)
  let impulse 					= a:screens * winheight(0)
  let s:state.impulse  += impulse
	let s:isrunning 			=1

  " Start a thread
  call timer_start(0, function('s:tick'), {'repeat': 0})
endfunction


let &cpoptions = s:save_cpo | unlet s:save_cpo
