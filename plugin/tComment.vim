" tComment.vim
" @Author:      Thomas Link (samul AT web.de)
" @Website:     http://members.a1.net/t.link/
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     27-Dez-2004.
" @Last Change: 07-Jän-2005.
" @Revision:    0.1.672

if &cp || exists("loaded_tcomment")
    finish
endif
let loaded_tcomment = 1

" If true, comment blank lines too
if !exists("g:tcommentBlankLines") | let g:tcommentBlankLines = 1 | endif

" If true, set &commentstring to g:tcomment_{&filetype}
if !exists("g:tcommentSetCMS") | let g:tcommentSetCMS = 0 | endif

" Guess the file type based on syntax names always or for some fileformat only
if !exists("g:tcommentGuessFileType")     | let g:tcommentGuessFileType = 0 | endif
" In php documents, the php part is usually marked as phpRegion. We thus 
" assume that the buffers default comment style isn't php but html
if !exists("g:tcommentGuessFileType_php")  | let g:tcommentGuessFileType_php = "html" | endif
if !exists("g:tcommentGuessFileType_html") | let g:tcommentGuessFileType_html = 1     | endif

" If you don't define these variables, TComment will use &commentstring 
" instead. We override the default values here in order to have a blank after 
" the comment marker
if !exists("g:tcomment_cpp")        | let g:tcomment_cpp      = '// %s'       | endif
if !exists("g:tcommentBlock_cpp")   | let g:tcommentBlock_cpp = '/*%s*/'      | endif
if !exists("g:tcomment_css")        | let g:tcomment_css      = '/* %s */'    | endif
if !exists("g:tcomment_c")          | let g:tcomment_c        = '/* %s */'    | endif
if !exists("g:tcomment_html")       | let g:tcomment_html     = '<!-- %s -->' | endif
if !exists("g:tcomment_javaScript") | let g:tcomment_javaScript = '// %s'     | endif
if !exists("g:tcomment_java")       | let g:tcomment_java     = '/* %s */'    | endif
if !exists("g:tcomment_lisp")       | let g:tcomment_lisp     = '; %s'        | endif
if !exists("g:tcomment_ocaml")      | let g:tcomment_ocaml    = '(* %s *)'    | endif
if !exists("g:tcomment_perl")       | let g:tcomment_perl     = '# %s'        | endif
if !exists("g:tcomment_php")        | let g:tcomment_php      = '// %s'       | endif
if !exists("g:tcommentBlock_php")   | let g:tcommentBlock_php = '/*%s*/'      | endif
if !exists("g:tcomment_ruby")       | let g:tcomment_ruby     = '# %s'        | endif
if !exists("g:tcomment_r")          | let g:tcomment_r        = '# %s'        | endif
if !exists("g:tcomment_scheme")     | let g:tcomment_scheme   = '; %s'        | endif
if !exists("g:tcomment_tex")        | let g:tcomment_tex      = '%% %s'       | endif
if !exists("g:tcomment_viki")       | let g:tcomment_viki     = '%% %s'       | endif
if !exists("g:tcomment_vim")        | let g:tcomment_vim      = '" %s'        | endif

" TComment(line1, line2, ?asBlock, ?commentBegin, ?commentEnd)
fun! TComment(beg, end, ...)
    " save the cursor position
    let co = col(".")
    let li = line(".")
    let asBlock = (a:0 >= 1 && a:1 =~ '^[^0]')
    " get the correct commentstring
    if a:0 >= 2 && a:2 != ""
        let cms = a:2 ." %s"
        if a:0 >= 3 && a:3 != ""
            let cms = cms ." ". a:3
        endif
    else
        let cms = <SID>GetCommentString(a:beg, a:end, asBlock)
    endif
    " make whitespace optional
    let cmtCheck   = substitute(cms, '\([	 ]\)', '\1\\?', 'g')
    " turn commentstring into a search pattern
    let cmtCheck   = <SID>SPrintF(cmtCheck, '\(\_.\{-}\)')
    " set mode and indentStr
    exec <SID>CommentDef(a:beg, a:end, cmtCheck, asBlock)
    " go
    if asBlock
        call <SID>DoCommentBlock(a:beg, a:end, mode, cmtCheck, cms)
    else
        " final search pattern for uncommenting
        let cmtCheck   = escape(cmtCheck, '"\/')
        " final pattern for commenting
        let cmtReplace = escape(cms, '"/')
        exec a:beg .','. a:end .'s/^'. indentStr .'\zs\(.*\)$/'.
                    \ '\=<SID>DoComment('. mode .', submatch(0), "'. cmtCheck .'", "'. cmtReplace .'")/ge'
    endif
    " reposition cursor
    exec 'norm! '. li .'G'. co .'|'
endf

" :line1,line2 TComment ?commentBegin ?commentEnd
command! -range -nargs=* TComment call TComment(<line1>, <line2>, 0, <f-args>)

" :line1,line2 TCommentBlock ?commentBegin ?commentEnd
command! -range -nargs=* TCommentBlock call TComment(<line1>, <line2>, 1, <f-args>)

" collect all variables matching ^tcomment_
fun! TCommentCollectFileTypes()
    let t = @t
    try
        redir @t
        silent let
        redir END
        let g:tcommentFileTypes = substitute("\n". @t ."\n", '\n\(tcomment_\(\w\+\)\|\w\+\).\{-}\ze\n', '\n\2', 'g')
        let g:tcommentFileTypes = substitute(g:tcommentFileTypes, '\(\n\)\n\+', '\1', 'g')
        let g:tcommentFileTypes = strpart(g:tcommentFileTypes, 1, strlen(g:tcommentFileTypes) - 2)
    finally
        let @t = t
    endtry
    let g:tcommentFileTypesRx = '\V\^\('. substitute(g:tcommentFileTypes, '\n', '\\|', 'g') .'\)\(\u\.\*\)\?\$'
endf

if !exists("g:tcommentFileTypes") | call TCommentCollectFileTypes() | endif

" return a list of filetypes for which a tcomment_{&ft} is defined
fun! TCommentFileTypes(ArgLead, CmdLine, CursorPos)
    if g:tcommentFileTypes == ""
        call TCommentCollectFileTypes()
    endif
    return g:tcommentFileTypes
endf

" comment text as if it were of a specific filetype
fun! TCommentAs(beg, end, asBlock, filetype)
    let cms  = <SID>GetCommentString(a:beg, a:end, a:asBlock, a:filetype)
    let pre  = substitute(cms, '%s.*$', '', '')
    let post = substitute(cms, '^.\{-}%s', '', '')
    call TComment(a:beg, a:end, a:asBlock, pre, post)
endf

" :line1,line2 TCommentAs filetype
command! -complete=custom,TCommentFileTypes -range -nargs=1 TCommentAs 
            \ call TCommentAs(<line1>, <line2>, 0, <f-args>)

" :line1,line2 TCommentBlockAs filetype
command! -complete=custom,TCommentFileTypes -range -nargs=1 TCommentBlockAs 
            \ call TCommentAs(<line1>, <line2>, 1, <f-args>)

if !hasmapto("TComment")
    noremap <silent> <c-_> :TComment<cr>
    inoremap <silent> <c-_> <c-o>:TComment<cr>
    noremap <Leader><c-_> :TComment 
    " inoremap <Leader><c-_> <c-o>:TComment 
endif


" ----------------------------------------------------------------
fun! <SID>EncodeCommentPart(string)
    return substitute(a:string, "%", "%%", "g")
endf

fun! <SID>GetCommentString(beg, end, asBlock, ...)
    let ft = a:0 >= 1 ? a:1 : ""
    if a:asBlock && ft != "" && exists("g:tcommentBlock_". ft)
        let cms = g:tcommentBlock_{ft}
    elseif ft != "" && exists("g:tcomment_". ft)
        let cms = g:tcomment_{ft}
    elseif exists("b:commentstring")
        let cms = b:commentstring
    elseif exists("b:commentStart") && b:commentStart != ""
        let cms = <SID>EncodeCommentPart(b:commentStart) ." %s"
        if exists("b:commentEnd") && b:commentEnd != ""
            let cms = cms ." ". <SID>EncodeCommentPart(b:commentEnd)
        endif
    elseif g:tcommentGuessFileType || (exists("g:tcommentGuessFileType_". &filetype) 
                \ && g:tcommentGuessFileType_{&filetype} =~ '[^0]')
        if g:tcommentGuessFileType_{&filetype} == 1
            let altFiletype = ""
        else
            let altFiletype = g:tcommentGuessFileType_{&filetype}
        endif
        let cms = <SID>GuessFileType(a:beg, a:end, a:asBlock, altFiletype)
    elseif a:asBlock && exists("g:tcommentBlock_" .&filetype)
        let cms = g:tcommentBlock_{&filetype}
    elseif exists("g:tcomment_" .&filetype)
        let cms = g:tcomment_{&filetype}
        if g:tcommentSetCMS && &commentstring != cms
            let &commentstring = cms
        endif
    else
        let cms = &commentstring
    endif
    return cms
endf

fun! <SID>SPrintF(string, ...)
    let n = 1
    let r = ""
    let s = a:string
    while 1
        let i = match(s, '%\(.\)')
        if i >= 0
            let x = s[i + 1]
            let r = r . strpart(s, 0, i)
            let s = strpart(s, i + 2)
            if x == "%"
                let r = r."%"
            else
                if a:0 >= n
                    exec 'let v = a:'. n
                    let n = n + 1
                else
                    echoerr "Malformed format string (too many arguments required): ". a:string
                endif
                if x ==# "s"
                    let r = r.v
                elseif x ==# "S"
                    let r = r.'"'.v.'"'
                else
                    echoerr "Malformed format string: ". a:string
                endif
            endif
        else
            return r.s
        endif
    endwh
endf

fun! <SID>GetIndentString(line)
    return substitute(getline(a:line), '^\s*\zs.*$', '', '')
endf

fun! <SID>CommentDef(beg, end, checkRx, asBlock)
    let mdrx = '\V\^\s\*'. a:checkRx .'\s\*\$'
    let mode = (getline(a:beg) =~ mdrx)
    let it = <SID>GetIndentString(a:beg)
    let il = indent(a:beg)
    let n  = a:beg + 1
    while n <= a:end
        if getline(n) =~ '\S'
            let jl = indent(n)
            if jl < il
                let it = <SID>GetIndentString(n)
                let il = jl
            endif
            if !a:asBlock
                if !(getline(n) =~ mdrx)
                    let mode = 0
                endif
            endif
        endif
        let n = n + 1
    endwh
    if a:asBlock
        let t = @t
        try
            exec 'norm! '. a:beg.'G1|v'.a:end.'G$"ty'
            let mode = (@t =~ mdrx)
        finally
            let @t = t
        endtry
    endif
    return 'let indentStr="'. it .'" | let mode='. mode
endf

fun! <SID>DoComment(mode, match, checkRx, replace)
    if !(a:match =~ '\S' || g:tcommentBlankLines)
        return a:match
    endif
    if a:mode
        " uncomment
        " echom "DBG match='". a:match ."' check='". a:checkRx ."'"
        let rv = substitute(a:match, '\V\^'. a:checkRx .'\$', '\1', '')
    else
        " comment
        " echom "DBG replace='". a:replace ."' match='". a:match ."'"
        let rv = <SID>SPrintF(a:replace, a:match)
    endif
    return escape(rv, '\')
endf

fun! <SID>DoCommentBlock(beg, end, mode, checkRx, replace)
    let t = @t
    try
        exec 'norm! '. a:beg.'G1|v'.a:end.'G$"td'
        if a:mode
            " uncomment
            " echom "DBG match='". @t ."' check='". a:checkRx ."'"
            let @t = substitute(@t, '\V\^'. a:checkRx .'\$', '\1', '')
            let @t = substitute(@t, '^\n', '', '')
            let @t = substitute(@t, '\n$', '', '')
        else
            " comment
            " echom "DBG replace='". a:replace ."' match='". a:match ."'"
            let @t = <SID>SPrintF(a:replace, "\n". @t ."\n")
        endif
        norm! "tP
    finally
        let @t = t
    endtry
endf

" inspired by Meikel Brandmeyer's EnhancedCommentify.vim
" this requires that a syntax names are prefixed by the filetype name 
" (capitalized or in lower case letters)
" <SID>GuessFileType(beg, end, asBlock, ?fallbackFiletype)
fun! <SID>GuessFileType(beg, end, asBlock, ...)
    if a:0 >= 1 && a:1 != ""
        let cms = <SID>GetCustomCommentString(a:1, a:asBlock)
        if cms == ""
            let cms = &commentstring
        elseif g:tcommentSetCMS && &commentstring != cms
            let &commentstring = cms
        endif
    else
        let cms = &commentstring
    endif
    let n  = a:beg
    while n <= a:end
        let syntaxName = synIDattr(synID(n, indent(n) + 1, 1), "name")
        if syntaxName =~ g:tcommentFileTypesRx
            let ft = substitute(syntaxName, g:tcommentFileTypesRx, '\1', '')
            return <SID>GetCustomCommentString(ft, a:asBlock, cms)
        endif
        let n = n + 1
    endwh
    return cms
endf

fun! <SID>GetCustomCommentString(ft, asBlock, ...)
    if a:asBlock && exists("g:tcommentBlock_". a:ft)
        return g:tcommentBlock_{a:ft}
    elseif exists("g:tcomment_". a:ft)
        return g:tcomment_{a:ft}
    elseif a:0 >= 1
        return a:1
    else
        return ""
    endif
endf

finish
-----------------------------------------------------------------------
History
0.1
- Initial release

