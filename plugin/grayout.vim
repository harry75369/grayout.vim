if !has('python') && !has('python3')
    echoerr 'This plugin requires python.'
    finish
endif

if exists('vim_grayout_loaded')
    finish
else
    let g:vim_grayout_loaded = 1
    let g:grayout_debug = get(g:, 'grayout_debug', 0)
    let g:grayout_debug_logfile = get(g:, 'grayout_debug_logfile', 0)
    let g:grayout_debug_compiler_inout = get(g:, 'grayout_debug_compiler_inout', 0)
    let g:grayout_cmd_line = get(g:, 'grayout_cmd_line', 'clang -x c++ -w -P -E -')
    let g:grayout_confirm = get(g:, 'grayout_confirm', 1)
    let g:grayout_workingdir = get(g:, 'grayout_workingdir', 0)

    let s:pyscript = expand('<sfile>:p:h').'/grayout.py'

    "highlight PreprocessorGrayout cterm=italic gui=italic ctermfg=DarkGray guifg=DarkGray
    highlight link PreprocessorGrayout Comment
    highlight PreprocessorGrayoutSignColumn ctermfg=245 ctermbg=237 guifg=#928374 guibg=#3c3836
    sign define PreprocessorGrayout text=| texthl=PreprocessorGrayoutSignColumn linehl=PreprocessorGrayout

    command! GrayoutUpdate call s:UpdateGrayout()
    command! GrayoutClear call s:ClearGrayout()
    command! GrayoutReloadConfig call s:ReloadGrayoutConfig()

    if has('python')
      python import sys
    elseif has('python3')
      python3 import sys
    endif
endif

function! s:UpdateGrayout()
    if !exists('b:num_grayout_lines')
        let b:num_grayout_lines = 0
    endif

    if !exists('b:_grayout_workingdir')
        let b:_grayout_workingdir = ''
    endif

    if !exists('b:grayout_cmd_line')
        call s:ReloadGrayoutConfig()
    endif

    if has('python')
      python sys.argv = ["grayout"]
      execute 'pyfile'.s:pyscript
    elseif has('python3')
      python3 sys.argv = ["grayout"]
      execute 'py3file'.s:pyscript
    endif
endfunction

function! s:ClearGrayout()
    if !exists('b:num_grayout_lines')
        let b:num_grayout_lines = 0
    endif

    if has('python')
      python sys.argv = ["clear"]
      execute 'pyfile'.s:pyscript
    elseif has('python3')
      python3 sys.argv = ["clear"]
      execute 'py3file'.s:pyscript
    endif
endfunction

function! s:ReloadGrayoutConfig()
    if has('python')
      python sys.argv = ["config"]
      execute 'pyfile'.s:pyscript
    elseif has('python3')
      python3 sys.argv = ["config"]
      execute 'py3file'.s:pyscript
    endif
endfunction
