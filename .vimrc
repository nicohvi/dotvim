".vimrc - so it begins
set encoding=utf-8

" load pathogen and bundles
call pathogen#infect()
call pathogen#helptags()

syntax on                         " syntax highlighting is sometimes helpful
filetype plugin indent on         " enable guessing of filetypes, plugins and indentation
set autoindent                    " also, autoindent
set ts=2                          " preferably 2 spaces
set shiftwidth=2
set expandtab                     " use spaces, no tab characters
set relativenumber                " perpare for utter mindfuckage
set showmatch                     " show bracket matchers
set ignorecase                    " ignore case in searches
set hlsearch                      " highlight all search matches
set smartcase                     " case vs CAPS, eternal struggle
set incsearch                     " search while typing
set ttimeoutlen=100               " decrease timeout because we're badass
" set vb                            " no fuckin audio bell
set ruler                         " show row and column in footer
" set scrolloff=2                   " minimum 2 lines above/below cursor
set laststatus=2                  " always show status bav
" set list listchars=tab:»·,trail:· " show whitespace character
set nofoldenable                  " code folding is evil
" set wildmenu                      " tab completion (wut?)
" set wildmode=list:longest,full
set paste                         " let's enable pasting from terminal
set noswapfile                    " swap files are ugly as sin
set backspace=2

" customize status line
set statusline=%{fugitive#statusline()}%f

" set dark background and color scheme
set background=dark
colorscheme base16-railscasts

" custom colors
highlight clear SignColumn
highlight VertSplit    ctermbg=236
highlight ColorColumn  ctermbg=237
highlight LineNr       ctermbg=236 ctermfg=240
highlight CursorLineNr ctermbg=236 ctermfg=240
highlight CursorLine   ctermbg=236
highlight StatusLineNC ctermbg=238 ctermfg=0
highlight StatusLine   ctermbg=240 ctermfg=12
highlight IncSearch    ctermbg=3   ctermfg=1
highlight Search       ctermbg=1   ctermfg=3
highlight Visual       ctermbg=3   ctermfg=0
highlight Pmenu        ctermbg=240 ctermfg=12
highlight PmenuSel     ctermbg=3   ctermfg=1
highlight SpellBad     ctermbg=0   ctermfg=1

" highlight status bar when in insert mode
au InsertEnter * hi StatusLine ctermfg=235 ctermbg=2
au InsertLeave * hi StatusLine ctermbg=240 ctermfg=12

" set leader key as comma instead of backslash
let mapleader=","

" rename current file (Gary Bernhardt)
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

" test runner
function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !clear
  if filereadable("Gemfile")
    exec ":!bundle exec rspec --color " . a:filename
  else
    exec ":!rspec --color " . a:filename
  end
  end
endfunction

function! SetTestFile()
  " set the spec file the tests will be run for
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " are we currenlty in a spec file?
  let in_test_file = match(expand("%"), '\_spec.rb\$'i) != -1

  if in_test_file 
    call SetTestFile()
  elseif !exists(t:grb_test_file . command_suffix)
    return
  end
  call RunTest(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_file_number . " -b")
endfunction

" run current test file with <,>+<T>
map <leader>T :call RunTestFile()<cr>
" run nearest spec with <,><t>
map<leader>t :call RunNearestTest()<cr>


" ------------- keymaps ---------------
map <leader>ev :e $MYVIMRC<cr>
map <leader>sv :so $MYVIMRC<cr>
let g:ctrlp_map = '<leader>f' 
map <leader>7 <plug>NERDCommenterToggle
