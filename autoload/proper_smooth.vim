"============================================================================y
" File: proper_smooth.vim
" Author: Joen Tolgraven
" Created: 2017-04-27
"=============================================================================
scriptencoding utf-8
if !exists('g:loaded_proper_smooth') | finish | endif | let g:loaded_proper_smooth=1
let s:save_cpo = &cpoptions | set cpoptions&vim

" let s:proper_smooth_interval 				= get('g:', proper_smooth_interval, 10)
let s:proper_smooth_interval 				= 10
" let s:proper_smooth_steps_baseline 	= get('g:', proper_smooth_steps_baseline, 10)
let s:proper_smooth_steps_baseline 	= 10
" let g:proper_smooth.ticks_to_decr 	= get('g:proper_smooth', air_drag, 2.0)
" let s:ps = g:proper_smooth

let s:state = { 'fuel': 0, 'velocity': 0, 'target': 0, 'running': 0}


function! s:tick(timer_id)
  " let l:wait = s:ps.interval / 1000.0  " Unit conversion: ms -> s
	" XXX	oh yeah so easiest way to fake some friction is I guess just incr the wait period between each tick so goes slower towards end?

  " Compute resistance forces
  " let l:vel_sign = s:state.velocity == 0 	? 0 : s:state.velocity / abs(s:state.velocity)
  " let l:friction         = -l:vel_sign 				* s:ps.friction
  " let l:air_drag         = -s:state.velocity 	* s:ps.air_drag
  " let l:additional_force = 	l:friction 				+ l:air_drag
  " Update state
  " let s:state.delta 	 += s:state.velocity * l:wait
  " let s:state.velocity += s:state.impulse + (abs(l:additional_force * l:wait) > abs(s:state.velocity) 
	" \ 										? -s:state.velocity 	: l:additional_force * l:wait)

  let s:state.fuel 			-= s:state.velocity

  " Scroll
  let l:int_delta 		= float2nr(s:state.velocity >= 0 ? floor(s:state.velocity) : ceil(s:state.velocity))
  " let s:state.delta  -= l:int_delta
  " if l:int_delta 			> 0
  "   execute "normal! " . string(abs(l:int_delta)) . "\<C-e>"
  " elseif l:int_delta 	< 0
  "   execute "normal! " . string(abs(l:int_delta)) . "\<C-y>"
	" endif
	execute "normal! " . string(abs(l:int_delta)) . (l:int_delta > 0 ? "\<C-e>" : "\<C-y>")
	execute "normal! " . string(abs(l:int_delta)) . (l:int_delta > 0 ? "j" : "k")

	let s:state.velocity = s:state.velocity * 0.77
	" set timer, if there's still enough momentum. else kill any residual.
  if abs(s:state.velocity) >= 1
    let l:interval = float2nr(round(s:proper_smooth_interval))
    " let s:timer = timer_start(l:interval, function('s:tick'))
  else
		let s:state.running = 0 | let s:state.velocity = 0 	| let s:state.impulse = 0
		call line(s:state.target)
  endif
endfunction


" function! proper_smooth#go(impulse)
function! proper_smooth#go(screens)
	if s:state.running == 1
		call cursor(s:state.target)
		call timer_stop(s:timer)
	endif
  let s:state.fuel 			= a:screens * winheight(0)  "total distance to move
	" let s:state.velocity 	= s:state.fuel / s:proper_smooth_steps_baseline
	let s:state.velocity 	= float2nr(round(s:state.fuel / 4))
	" play numbers, so lets say winheight 50, fuel 25 or 50...
	"
	" 40 / 80...
	
	"
	let s:state.running 			=1

  " Start a thread
  let s:timer = timer_start(0, function('s:tick'))
endfunction


let &cpoptions = s:save_cpo | unlet s:save_cpo
