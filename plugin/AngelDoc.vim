let s:plugin_root_dir = expand('<sfile>:p:h:h')

let s:angeldoc_path = get(g:, 'angeldoc_path', '')

function! AngelDoc#InsertXmlDoc()
    if (empty(s:angeldoc_path))
        let command = 'dotnet '.fnamemodify('~', ':p').'.angeldoc/bin/AngelDoc.dll - gendoccsharp '.line('.')
    else
        let command = 'dotnet '.s:angeldoc_path.' - gendoccsharp '.line('.')
    endif
    let code = join(getline(1,'$'), "\n")
    execute "normal! mA"
    if has('nvim')
        call AngelDoc#InsertXmlDocNeoVim(command, code)
    else
        call AngelDoc#InsertXmlDocVim(command, code)
    endif
    execute "normal! `A"
endfunction

function! AngelDoc#InsertXmlDocVim(command, code)
    let job = job_start(a:command, { "mode" : "nl" })
    call ch_sendraw(job, a:code)
    call ch_close_in(job)
    let linesInserted = 0
    while (ch_status(job) != "closed")
        let response = ch_read(job)
        if !empty(trim(response))
            let linesInserted += 1
            call append(line('.') - 1, response)
        endif
    endwhile

    if linesInserted > 0
        let command = (line(".") - linesInserted).','.(line('.') - 1).'normal! =='
        execute command
    endif
endfunction

function! AngelDoc#InsertXmlDocNeoVim(command, code)
    let s:linesInserted = 0
    function! OnStdout(id, data, event)
        for line in a:data
            if !empty(trim(line))
                let s:linesInserted += 1
                call append(line('.') - 1, line)
            endif
        endfor
    endfunction
    function! OnExit(id, data, event)
        if s:linesInserted > 0
            let command = (line(".") - s:linesInserted).','.(line('.') - 1).'normal! =='
            execute command
        endif
    endfunction
    let opts = { "stdout_buffered" : v:true, "on_stdout" : "OnStdout", "on_exit" : "OnExit" }
    let job = jobstart(a:command, opts)
    call chansend(job, a:code)
    call chanclose(job, "stdin")
    call jobwait([job], 500)
endfunction

function! AngelDoc#Install(...)
    let angeldoc_version = ''
    if a:0 > 0
        let angeldoc_version = a:1
    endif
    if has('win32')
        let script = shellescape('powershell '.s:plugin_root_dir.'/manage-releases.ps1')
        let script_command = printf('%s', script)
        if !empty(angeldoc_version)
            let script_command = script_command.' -v '.angeldoc_version
        endif
        execute '!'.script_command
    else
        let script = shellescape(s:plugin_root_dir.'/manage-releases.sh')
        let script_command = printf('%s', script)
        if !empty(angeldoc_version)
            let script_command = script_command.' -v '.angeldoc_version
        endif
        execute '!'.script_command
    endif
endfunction

command! -bar -nargs=? AngelDocInstall call AngelDoc#Install(<f-args>)
