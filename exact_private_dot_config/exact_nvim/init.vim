" Plugins "
call plug#begin(expand('~/.vim/plugged'))

Plug 'arcticicestudio/nord-vim'
Plug 'Chiel92/vim-autoformat'
Plug 'fatih/vim-go'

call plug#end()

" Plugins Setting"

" vim-autoformat
augroup fmt
		autocmd!
		autocmd BufWritePre * undojoin | Autoformat
augroup END

" vim-go
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

augroup go
		autocmd!

		" Show by default 4 spaces for a tab
		autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

		" :GoBuild and :GoTestCompile
		autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

		" :GoTest
		autocmd FileType go nmap <leader>t  <Plug>(go-test)

		" :GoRun
		autocmd FileType go nmap <leader>r  <Plug>(go-run)

		" :GoDoc
		autocmd FileType go nmap <Leader>d <Plug>(go-doc)

		" :GoCoverageToggle
		autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

		" :GoInfo
		autocmd FileType go nmap <Leader>i <Plug>(go-info)

		" :GoMetaLinter
		autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

		" :GoDef but opens in a vertical split
		autocmd FileType go nmap <Leader>v <Plug>(go-def-vertical)
		" :GoDef but opens in a horizontal split
		autocmd FileType go nmap <Leader>s <Plug>(go-def-split)

		" :GoAlternate  commands :A, :AV, :AS and :AT
		autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
		autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
		autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
		autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

" Setting "
syntax on
set tabstop=4
set number
set ai
set hlsearch
set ruler
set incsearch
highlight Comment ctermfg=green

colorscheme nord

