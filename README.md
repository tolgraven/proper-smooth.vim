# proper-smooth.vim

50% less fancy physics, 100% more does what it should, which is:
* look badman
* no confuse

Fuck decimals and that.
Based on being first awed and then pissed off by [comfortable-motion.vim](https://github.com/yuttie/comfortable-motion.vim), in turn inspired by [emacs-inertial-scroll](https://github.com/kiwanami/emacs-inertial-scroll).

Scroll as normal with `C-d`/`C-u` or `C-f`/`C-b`:
<!-- ![Scroll with `C-d`/`C-u`]() -->

## how many CUDA nodes does this require???
Go home, you're drunk. Uses `<C-e>`/`<C-y>` parallel with `j`/`k`, so maybe don't `nmap` those.

## Requirements
Fuck you, just use nvim like a normal person. Or any vim version with timer support I guess, if you're old or something.

## Installation
[vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'tolgraven/proper-smooth.vim'
```
etc.

## Mappings
These skip ahead for any consequent presses instead of throwing yet more ticks on an existing queue, so you're never more than one "cycle" away.
By default:
```vim
nnoremap <silent> <C-d> :call proper_smooth#go(0.5)<CR>
nnoremap <silent> <C-u> :call proper_smooth#go(-0.5)<CR>
nnoremap <silent> <C-f> :call proper_smooth#go(1.0)<CR>
nnoremap <silent> <C-b> :call proper_smooth#go(-1.0)<CR>
```
Or, if you think you're just soooo special:
```vim
let g:proper_smooth_no_default_key_mappings = 1
```

## Configuration
```vim
let g:proper_smooth_interval = 10 		"ms per tick
let g:proper_smooth_steps 	 = 10 		"how many jumps to get there?
```

## Self-promotion:
Stand by for [Bruvbox](https://github.com/tolgraven/bruvbox)
<!-- "Bruvbox - there's nothing Gruvy about it" -->
"Bruvbox - I want my money back"
<angry image goes here>
...any day now

## License
MIT License
