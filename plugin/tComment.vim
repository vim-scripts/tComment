" tComment.vim
" @Author:      Thomas Link (samul AT web.de)
" @Website:     http://members.a1.net/t.link/
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     27-Dez-2004.
" @Last Change: 17-Mär-2005.
" @Revision:    1.4.8

" vimscript #1173

if &cp || exists("loaded_tcomment")
    finish
endif
let loaded_tcomment = 104

fun! <SID>DefVar(name, val)
    if !exists(a:name)
        exec "let ". a:name ."='". a:val ."'"
    endif
endf

" If true, comment blank lines too
call <SID>DefVar('g:tcommentBlankLines', 1)

" Guess the file type based on syntax names always or for some fileformat only
call <SID>DefVar('g:tcommentGuessFileType', 0)
" In php documents, the php part is usually marked as phpRegion. We thus 
" assume that the buffers default comment style isn't php but html
call <SID>DefVar('g:tcommentGuessFileType_dsl', "xml")
call <SID>DefVar('g:tcommentGuessFileType_php', "html")
call <SID>DefVar('g:tcommentGuessFileType_html', 1)
call <SID>DefVar('g:tcommentGuessFileType_tskeleton', 1)
call <SID>DefVar('g:tcommentGuessFileType_vim',  1)

" If you don't define these variables, TComment will use &commentstring 
" instead. We override the default values here in order to have a blank after 
" the comment marker. Block comments work only if we explicitly define the 
" markup.
" The format for block comments is similar to normal commentstrings with the 
" exception that the format strings for blocks can contain a second line that 
" defines how "middle lines" (see :h format-comments) should be displayed.

" I personally find this style rather irritating but here is an alternative 
" definition that does this left-handed bar thing
call <SID>DefVar('g:tcommentBlockC', "/*%s */\n * ")
" call <SID>DefVar('g:tcommentBlockC2', "/**%s  */\n  * ")
" call <SID>DefVar('g:tcommentBlockC', "/*%s */\n    ")

call <SID>DefVar('g:tcommentBlockXML', "<!--%s-->\n  ")

" Currently this function just sets a variable
fun! TCommentDefineType(name, commentstring)
    call <SID>DefVar('g:tcomment_'. a:name, a:commentstring)
endf

call TCommentDefineType('ada',              '-- %s'            )
call TCommentDefineType('apache',           '# %s'             )
call TCommentDefineType('catalog',          '-- %s --'         )
call TCommentDefineType('catalog_block',    '--%s--\n  '       )
call TCommentDefineType('cpp',              '// %s'            )
call TCommentDefineType('cpp_block',        g:tcommentBlockC   )
call TCommentDefineType('css',              '/* %s */'         )
call TCommentDefineType('css_block',        g:tcommentBlockC   )
call TCommentDefineType('c',                '/* %s */'         )
call TCommentDefineType('c_block',          g:tcommentBlockC   )
call TCommentDefineType('conf',             '# %s'             )
call TCommentDefineType('docbk',            '<!-- %s -->'      )
call TCommentDefineType('docbk_block',      g:tcommentBlockXML )
call TCommentDefineType('dosbatch',         'rem %s'           )
call TCommentDefineType('dosini',           '; %s'             )
call TCommentDefineType('dsl',              '; %s'             )
call TCommentDefineType('dylan',            '// %s'            )
call TCommentDefineType('eiffel',           '-- %s'            )
call TCommentDefineType('gtkrc',            '# %s'             )
call TCommentDefineType('haskell',          '-- %s'            )
call TCommentDefineType('html',             '<!-- %s -->'      )
call TCommentDefineType('html_block',       g:tcommentBlockXML )
call TCommentDefineType('io',               '// %s'            )
call TCommentDefineType('javaScript',       '// %s'            )
call TCommentDefineType('javaScript_block', g:tcommentBlockC   )
call TCommentDefineType('java',             '/* %s */'         )
call TCommentDefineType('java_block',       g:tcommentBlockC   )
call TCommentDefineType('lisp',             '; %s'             )
call TCommentDefineType('m4',               'dnl %s'           )
call TCommentDefineType('nroff',            '.\\" %s'          )
call TCommentDefineType('objc',             '/* %s */'         )
call TCommentDefineType('objc_block',       g:tcommentBlockC   )
call TCommentDefineType('ocaml',            '(* %s *)'         )
call TCommentDefineType('ocaml_block',      '(*%s*)\n   '      )
call TCommentDefineType('pascal',           '(* %s *)'         )
call TCommentDefineType('pascal_block',     '(*%s*)\n   '      )
call TCommentDefineType('perl',             '# %s'             )
call TCommentDefineType('perl_block',       '=cut%s=cut'       )
call TCommentDefineType('php',              '// %s'            )
call TCommentDefineType('php_block',        g:tcommentBlockC   )
call TCommentDefineType('prolog',           '%% %s'            )
call TCommentDefineType('ruby',             '# %s'             )
call TCommentDefineType('ruby_block',       '=begin rdoc%s=end')
call TCommentDefineType('r',                '# %s'             )
call TCommentDefineType('scheme',           '; %s'             )
call TCommentDefineType('sgml',             '<!-- %s -->'      )
call TCommentDefineType('sgml_block',       g:tcommentBlockXML )
call TCommentDefineType('sh',               '# %s'             )
call TCommentDefineType('sql',              '-- %s'            )
call TCommentDefineType('spec',             '# %s'             )
call TCommentDefineType('sps',              '* %s.'            )
call TCommentDefineType('tcl',              '# %s'             )
call TCommentDefineType('tex',              '%% %s'            )
call TCommentDefineType('tpl',              '<!-- %s -->'      )
call TCommentDefineType('viki',             '%% %s'            )
call TCommentDefineType('vim',              '" %s'             )
call TCommentDefineType('websec',           '# %s'             )
call TCommentDefineType('xml',              '<!-- %s -->'      )
call TCommentDefineType('xml_block',        g:tcommentBlockXML )
call TCommentDefineType('xslt',             '<!-- %s -->'      )
call TCommentDefineType('xslt_block',       g:tcommentBlockXML )
call TCommentDefineType('yaml',             '# %s'             )

" TComment(line1, line2, ?commentMode, ?commentAnyway, ?commentBegin, ?commentEnd)
" commentMode:
"   0 ... guess
"   1 ... block
"   V ... "visual" block
fun! TComment(beg, end, ...)
    " save the cursor position
    let co = col(".")
    let li = line(".")
    let commentMode   = (a:0 >= 1 && a:1 =~ '^[^0]')
    let commentAnyway = a:0 >= 2 ? (a:2 == '!') : 0
    if commentMode && a:1 == "V"
        let start = co
    else
        let start = 0
    endif
    " get the correct commentstring
    if a:0 >= 3 && a:3 != ""
        let cms = <SID>EncodeCommentPart(a:3) ."%s"
        if a:0 >= 4 && a:4 != ""
            let cms = cms . <SID>EncodeCommentPart(a:4)
        endif
    else
        exec <SID>GetCommentString(a:beg, a:end, commentMode)
    endif
    let cms0       = <SID>BlockGetCommentString(cms)
    let cms0       = escape(cms0, '\')
    " make whitespace optional; this conflicts with comments that require some 
    " whitespace
    let cmtCheck   = substitute(cms0, '\([	 ]\)', '\1\\?', 'g')
    " turn commentstring into a search pattern
    let cmtCheck   = <SID>SPrintF(cmtCheck, '\(\_.\{-}\)')
    " set commentMode and indentStr
    exec <SID>CommentDef(a:beg, a:end, cmtCheck, commentMode, start)
    if commentAnyway
        let mode = 0
    endif
    " go
    if commentMode
        " We want a comment block
        call <SID>CommentBlock(a:beg, a:end, mode, cmtCheck, cms, indentStr)
    else
        " We want commented lines
        " final search pattern for uncommenting
        let cmtCheck   = escape('\V\^\(\s\{-}\)'. cmtCheck .'\$', '"/\')
        " final pattern for commenting
        let cmtReplace = escape(cms0, '"/')
        silent exec a:beg .','. a:end .'s/\V'. <SID>StartRx(start) . indentStr .'\zs\(\.\*\)\$/'.
                    \ '\=<SID>ProcessedLine('. mode .', submatch(0), "'. cmtCheck .'", "'. cmtReplace .'")/ge'
    endif
    " reposition cursor
    silent exec 'norm! '. li .'G'. co .'|'
endf

" :line1,line2 TComment ?commentBegin ?commentEnd
command! -bang -range -nargs=* TComment call TComment(<line1>, <line2>, 0, "<bang>", <f-args>)

" :line1,line2 TComment ?commentBegin ?commentEnd
command! -bang -range -nargs=* TCommentVisualBlock call TComment(<line1>, <line2>, "V", "<bang>", <f-args>)

" :line1,line2 TCommentBlock ?commentBegin ?commentEnd
command! -bang -range -nargs=* TCommentBlock call TComment(<line1>, <line2>, 1, "<bang>", <f-args>)

" comment text as if it were of a specific filetype
fun! TCommentAs(beg, end, commentAnyway, filetype)
    let asBlock = a:filetype =~ '_block'
    if asBlock
        let ft = substitute(a:filetype, '_block.*$', '', '')
    else
        let ft = a:filetype
    endif
    exec <SID>GetCommentString(a:beg, a:end, asBlock, ft)
    let pre  = substitute(cms, '%s.*$',    '', '')
    let pre  = substitute(pre, '%%', '%', 'g')
    let post = substitute(cms, '^.\{-}%s', '', '')
    let post = substitute(post, '%%', '%', 'g')
    call TComment(a:beg, a:end, asBlock, a:commentAnyway, pre, post)
endf

" :line1,line2 TCommentAs commenttype
command! -bang -complete=custom,TCommentFileTypes -range -nargs=1 TCommentAs 
            \ call TCommentAs(<line1>, <line2>, "<bang>", <f-args>)

if !hasmapto(":TComment<cr>")
    noremap <silent> <c-_> :TComment<cr>
    inoremap <silent> <c-_> <c-o>:TComment<cr>
    noremap <silent> <c-_><c-_> :TComment<cr>
    inoremap <silent> <c-_><c-_> <c-o>:TComment<cr>
endif
if !hasmapto(":TComment ")
    noremap <c-_><space> :TComment 
    inoremap <c-_><space> <c-o>:TComment 
endif
if !hasmapto(":TCommentVisualBlock<cr>")
    vnoremap <silent> <c-_>v :TCommentVisualBlock<cr>
endif
if !hasmapto(":TCommentBlock<cr>")
    noremap <c-_>b :TCommentBlock<cr>
    inoremap <c-_>b <c-o>:TCommentBlock<cr>
endif
if !hasmapto(":TCommentAs")
    noremap <c-_>a :TCommentAs 
    inoremap <c-_>a <c-o>:TCommentAs 
    noremap <c-_>s :TCommentAs <c-r>=&ft<cr>
    inoremap <c-_>s <c-o>:TCommentAs <c-r>=&ft<cr>
endif


" ----------------------------------------------------------------
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
    if a:ArgLead == ""
        return &filetype ."\n". g:tcommentFileTypes
    else
        return g:tcommentFileTypes
    endif
endf

fun! <SID>EncodeCommentPart(string)
    return substitute(a:string, "%", "%%", "g")
endf

" <SID>GetCommentString(beg, end, asBlock, ?filetype="")
" => RecordCMS
fun! <SID>GetCommentString(beg, end, asBlock, ...)
    let ft = a:0 >= 1 ? a:1 : ""
    if ft != ""
        exec <SID>GetCustomCommentString(ft, a:asBlock)
    else
        let cms = ""
        let asBlock = a:asBlock
    endif
    if cms == ""
        if exists("b:commentstring")
            let cms = b:commentstring
            let asBlock = 0
        elseif exists("b:commentStart") && b:commentStart != ""
            let cms = <SID>EncodeCommentPart(b:commentStart) ." %s"
            if exists("b:commentEnd") && b:commentEnd != ""
                let cms = cms ." ". <SID>EncodeCommentPart(b:commentEnd)
            endif
            let asBlock = 0
        elseif g:tcommentGuessFileType || (exists("g:tcommentGuessFileType_". &filetype) 
                    \ && g:tcommentGuessFileType_{&filetype} =~ '[^0]')
            if g:tcommentGuessFileType_{&filetype} == 1
                let altFiletype = ""
            else
                let altFiletype = g:tcommentGuessFileType_{&filetype}
            endif
            return <SID>GuessFileType(a:beg, a:end, a:asBlock, altFiletype)
        else
            return <SID>GetCustomCommentString(&filetype, a:asBlock, <SID>GuessCurrentCommentString(a:asBlock))
        endif
    endif
    return <SID>RecordCMS(cms, asBlock)
endf

" <SID>SPrintF(formatstring, ?values ...)
" => string
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

fun! <SID>StartRx(start)
    if a:start == 0
        return '\^'
    else
        return '\%'. a:start .'c'
    endif
endf

fun! <SID>GetIndentString(line, start)
    let start = a:start > 0 ? a:start - 1 : 0
    return substitute(strpart(getline(a:line), start), '\V\^\s\*\zs\.\*\$', '', '')
endf

fun! <SID>CommentDef(beg, end, checkRx, asBlock, start)
    let mdrx = '\V'. <SID>StartRx(a:start) .'\s\*'. a:checkRx .'\s\*\$'
    let mode = (getline(a:beg) =~ mdrx)
    " echom "DBG ". a:checkRx .": ". mode ." ". mdrx
    let it = <SID>GetIndentString(a:beg, a:start)
    let il = indent(a:beg)
    let n  = a:beg + 1
    while n <= a:end
        if getline(n) =~ '\S'
            let jl = indent(n)
            if jl < il
                let it = <SID>GetIndentString(n, a:start)
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
            silent exec 'norm! '. a:beg.'G1|v'.a:end.'G$"ty'
            let mode = (@t =~ mdrx)
        finally
            let @t = t
        endtry
    endif
    return 'let indentStr="'. it .'" | let mode='. mode
endf

fun! <SID>ProcessedLine(mode, match, checkRx, replace)
    if !(a:match =~ '\S' || g:tcommentBlankLines)
        return a:match
    endif
    if a:mode
        " uncomment
        let rv = substitute(a:match, a:checkRx, '\1\2', '')
    else
        " comment
        let rv = <SID>SPrintF(a:replace, a:match)
    endif
    return escape(rv, '\')
endf

fun! <SID>CommentBlock(beg, end, mode, checkRx, replace, indentStr)
    let t = @t
    try
        silent exec 'norm! '. a:beg.'G1|v'.a:end.'G$"td'
        let ms = <SID>BlockGetMiddleString(a:replace)
        let mx = escape(ms, '\')
        if a:mode
            " uncomment
            let @t = substitute(@t, '\V\^\s\*'. a:checkRx .'\$', '\1', '')
            if ms != ""
                let @t = substitute(@t, '\V\n'. a:indentStr . mx, '\n'. a:indentStr, 'g')
            endif
            let @t = substitute(@t, '^\n', '', '')
            let @t = substitute(@t, '\n\s*$', '', '')
        else
            " comment
            let cs = <SID>BlockGetCommentString(a:replace)
            let cs = a:indentStr . substitute(cs, '%s', '%s'. a:indentStr, '')
            if ms != ""
                let ms = a:indentStr . ms
                let mx = a:indentStr . mx
                let @t = substitute(@t, '^'. a:indentStr, '', 'g')
                let @t = ms . substitute(@t, '\n'. a:indentStr, '\n'. mx, 'g')
            endif
            let @t = <SID>SPrintF(cs, "\n". @t ."\n")
        endif
        silent norm! "tP
    finally
        let @t = t
    endtry
endf

" inspired by Meikel Brandmeyer's EnhancedCommentify.vim
" this requires that a syntax names are prefixed by the filetype name 
" <SID>GuessFileType(beg, end, asBlock, ?fallbackFiletype)
" => RecordCMS
fun! <SID>GuessFileType(beg, end, asBlock, ...)
    if a:0 >= 1 && a:1 != ""
        exec <SID>GetCustomCommentString(a:1, a:asBlock)
        if cms == ""
            let cms = <SID>GuessCurrentCommentString(a:asBlock)
        endif
    else
        let asBlock = 0
        let cms = <SID>GuessCurrentCommentString(0)
    endif
    let n  = a:beg
    while n <= a:end
        let m  = indent(n) + 1
        let le = virtcol("$")
        while m < le
            let syntaxName = synIDattr(synID(n, m, 1), "name")
            if syntaxName =~ g:tcommentFileTypesRx
                let ft = substitute(syntaxName, g:tcommentFileTypesRx, '\1', '')
                return <SID>GetCustomCommentString(ft, a:asBlock, cms)
            endif
            if syntaxName == "" || syntaxName =~ '^\u\+$' || syntaxName =~ '^\u\U*$'
                let m = m + 1
            else
                break
            endif
        endwh
        let n = n + 1
    endwh
    return <SID>RecordCMS(cms, asBlock)
endf

fun! <SID>GuessCurrentCommentString(asBlock)
    let valid_cms = &commentstring =~ "%s"
    if &commentstring != "/*%s*/" && valid_cms
        " The &commentstring appears to have been set and to be valid
        return &commentstring
    elseif &comments != "s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-"
        " the commentstring is the default one, so we assume that it wasn't 
        " explicitly set; we then try to reconstruct &cms from &comments
        exec <SID>ExtractCommentsPart("")
        if !a:asBlock && line != ""
            return line ." %s"
        endif
        exec <SID>ExtractCommentsPart("s")
        if s != ""
            exec <SID>ExtractCommentsPart("e")
            " if a:asBlock
            "     exec <SID>ExtractCommentsPart("m")
            "     if m != ""
            "         let m = "\n". m
            "     endif
            "     return s.'%s'.e.m
            " else
                return s.' %s '.e
            " endif
        endif
        if line != ""
            return line ." %s"
        endif
    elseif valid_cms
        " Before &commentstring appeared not to be set. As we don't know 
        " better we return it anyway if it is valid
        return &commentstring
    else
        " &commentstring is invalid. So we return the identity string.
        return "%s"
    endif
endf

fun! <SID>ExtractCommentsPart(key)
    " let key   = a:key != "" ? a:key .'[^:]*' : ""
    let key = a:key . '[bnflrO0-9-]*'
    let val = substitute(&comments, '^\(.\{-},\)\{-}'. key .':\([^,]\+\).*$', '\2', '')
    if val == &comments
        let val = ""
    else
        let val = substitute(val, '%', '%%', 'g')
    endif
    let var = a:key == "" ? "line" : a:key
    return 'let '. var .'="'. escape(val, '"') .'"'
endf

" <SID>GetCustomCommentString(ft, asBlock, ?default="")
" => RecordCMS
fun! <SID>GetCustomCommentString(ft, asBlock, ...)
    let asBlock = a:asBlock
    let customComment = exists("g:tcomment_". a:ft)
    if (!customComment || asBlock) && exists("g:tcomment_". a:ft ."_block")
        let cms = g:tcomment_{a:ft}_block
    elseif exists("g:tcomment_". a:ft)
        let cms = g:tcomment_{a:ft}
        let asBlock = 0
    elseif a:0 >= 1
        let cms = a:1
        let asBlock = 0
    else
        let cms = ""
        let asBlock = 0
    endif
    return <SID>RecordCMS(cms, asBlock)
endf

fun! <SID>RecordCMS(cms, asBlock)
    return 'let cms="'. escape(a:cms, '"') .'" | let asBlock='. a:asBlock
endf

fun! <SID>BlockGetCommentString(cms)
    return substitute(a:cms, '\n.*$', '', '')
endf

fun! <SID>BlockGetMiddleString(cms)
    let rv = substitute(a:cms, '^.\{-}\n\([^\n]*\)', '\1', '')
    return rv == a:cms ? "" : rv
endf

finish


-----------------------------------------------------------------------
History

0.1
- Initial release

0.2
- Fixed uncommenting of non-aligned comments
- improved support for block comments (with middle lines and indentation)
- using TCommentBlock for file types that don't have block comments creates 
single line comments
- removed the TCommentAsBlock command (TCommentAs provides its functionality)
- removed g:tcommentSetCMS
- the default key bindings have slightly changed

1.3
- slightly improved recognition of embedded syntax
- if no commentstring is defined in whatever way, reconstruct one from 
&comments
- The TComment... commands now have bang variants that don't act as toggles 
but always comment out the selected text
- fixed problem with commentstrings containing backslashes
- comment as visual block (allows commenting text to the right of the main 
text, i.e., this command doesn't work on whole lines but on the text to the 
right of the cursor)
- enable multimode for dsl, vim filetypes
- added explicit support for some other file types I ran into

1.4
- Fixed problem when &commentstring was invalid (e.g. lua)
- perl_block by Kyosuke Takayama.
- <c-_>s mapped to :TCommentAs <c-r>=&ft<cr>

