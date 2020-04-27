" phoenix.vim - Shortcuts and settings for project with the Phoenix framework
" Maintainer: Arjan van der Gaag <http://arjanvandergaag.nl>
" Version: 0.1

if exists('g:loaded_phoenix') || &cp
  finish
endif
let g:loaded_phoenix = 1

augroup phoenix
  autocmd!

  " Setup when openening a file without a filetype
  autocmd BufNewFile,BufReadPost *
    \ if empty(&filetype) |
    \   call phoenix#Setup(expand('<amatch>:p')) |
    \ endif

  " Setup when launching Vim for a file with any filetype
  autocmd FileType * call phoenix#Setup(expand('%:p'))

  " Setup when launching Vim without a buffer
  autocmd VimEnter *
    \ if expand('<amatch>') == '' |
    \   call phoenix#Setup(getcwd()) |
    \ endif
augroup end

let s:projections = {
  \ "lib/<project>_web/channels/*_channel.ex": {
  \   "type": "channel",
  \   "alternate": "test/<project>_web/channels/{basename}_channel_test.exs",
  \   "template": [
  \     "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Channel do",
  \     "  use {dirname|camelcase|capitalize}, :channel",
  \     "end"
  \   ]
  \ },
  \ "lib/<project>_web/controllers/*_controller.ex": {
  \   "type": "controller",
  \   "alternate": "test/<project>_web/controllers/{basename}_controller_test.exs",
  \   "template": [
  \     "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Controller do",
  \     "  use {dirname|camelcase|capitalize}, :controller",
  \     "end"
  \   ]
  \ },
  \ "lib/<project>_web/views/*_view.ex": {
  \   "type": "view",
  \   "alternate": "test/<project>_web/views/{basename}_view_test.exs",
  \   "template": [
  \     "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View do",
  \     "  use {dirname|camelcase|capitalize}, :view",
  \     "end"
  \   ]
  \ },
  \ "test/<project>_web/channels/*_channel_test.exs": {
  \   "alternate": "lib/<project>_web/channels/{basename}_channel.ex",
  \   "template": [
  \     "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ChannelTest do",
  \     "  use {dirname|camelcase|capitalize}.ConnCase, async: true",
  \     "end"
  \   ]
  \ },
  \ "test/<project>_web/controllers/*_controller_test.exs": {
  \   "alternate": "lib/<project>_web/controllers/{basename}_controller.ex",
  \   "template": [
  \     "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ControllerTest do",
  \     "  use {dirname|camelcase|capitalize}.ConnCase, async: true",
  \     "end"
  \   ]
  \ },
  \ "test/<project>_web/views/*_view_test.exs": {
  \   "alternate": "lib/<project>_web/views/{basename}_view.ex",
  \   "template": [
  \     "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ViewTest do",
  \     "  use {dirname|camelcase|capitalize}.ConnCase, async: true",
  \     "end"
  \   ]
  \ },
  \ "lib/<project>_web/templates/*.html.eex": {
  \   "type": "template"
  \ },
  \ "lib/<project>_web/router.ex": {
  \   "type": "router"
  \ },
  \ "assets/css/*": {
  \   "type": "stylesheet"
  \ },
  \ "assets/js/*": {
  \   "type": "javascript"
  \ },
  \ "config/*.exs": {
  \   "type": "config"
  \ },
  \ "lib/*.ex": {
  \   "type": "lib",
  \   "alternate": "test/{basename}_test.exs",
  \   "template": [
  \     "defmodule {basename|camelcase|capitalize|dot} do",
  \     "end"
  \   ]
  \ },
  \ "test/*_test.exs": {
  \   "type": "test",
  \   "alternate": "lib/{basename}.ex",
  \   "template": [
  \     "defmodule {camelcase|capitalize|dot}Test do",
  \     "end"
  \   ]
  \ },
  \ "priv/repo/migrations/*.exs": {
  \   "type": "migration"
  \ }
\ }

augroup phoenix_projections
  autocmd!
  autocmd User ProjectionistDetect call phoenix#ProjectionistDetect(s:projections)
augroup END

augroup phoenix_path
  autocmd!
  autocmd User Phoenix call phoenix#SetupSnippets()
  autocmd User Phoenix call phoenix#DefineMixCommand()
  autocmd User Phoenix call phoenix#SetupSurround()
  autocmd User Phoenix
        \ let &l:path = 'lib/**,test/**,config/**,assets/**' . &path |
        \ let &l:suffixesadd = '.ex,.exs,.html.eex' . &suffixesadd
augroup END
