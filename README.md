# angeldoc-vim

An open-source replacement for GhostDoc for Vim and NeoVim.

![Demo](assets/AngelDoc.gif)


## Seting it up
Put the plugin in your vimrc.

E.g. if you are using Plug:

`Plug 'jpfeiffer16/angeldoc-vim'`

Add a mapping to `AngelDoc#InsertXmlDoc()` in your .vimrc.

Example:
```
nnoremap /// :call AngelDoc#InsertXmlDoc()<CR>
```

### Windows

`powershell .\manage-releases.ps1`

### Unix

`./manage-releases.ps1`
