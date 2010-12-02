" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @GIT:         http://github.com/tomtom/tcommand_vim/
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2010-03-12.
" @Last Change: 2010-10-24.
" @Revision:    19
" GetLatestVimScripts: 3013 0 :AutoInstall: tcommand.vim
" Select and execute a command or menu item from a list

if &cp || exists("loaded_tcommand")
    finish
endif
if !exists('g:loaded_tlib') || g:loaded_tlib < 36
    runtime plugin/02tlib.vim
    if !exists('g:loaded_tlib') || g:loaded_tlib < 36
        echoerr 'tlib >= 0.36 is required'
        finish
    endif
endif
let loaded_tcommand = 2


" :display: TCommand[!] [INITIAL_FILTER]
" With a '!', reset the list of known commands and menu items.
command! -bang -nargs=? TCommand call tcommand#Select(!empty("<bang>"), <q-args>)


finish

CHANGES:
0.1
- Initial release

0.2
- Default to horizontal split
- Optional integration with WhereFrom
- Missed nore menus items
- Display help on pressing f1 (not <c-o>)
- Don't automatically select the only item matching the filter
- Favourites
- Include the file where a command was defined in the list.

