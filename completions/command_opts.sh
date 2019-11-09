#!/bin/bash

have_optdump=('build' 'depends' 'fetch' 'pkglist' 'repo' 'repo-filter' 'query'
              'search' 'srcver' 'sync' 'vercmp')
no_optdump=('graph')

default_opts() {
    local cmd corecommands=() opts=()

    for cmd in "${have_optdump[@]}"; do
        mapfile -t opts < <(bash "../lib/aur-${cmd}" --dump-options | LC_ALL=C sort)
        corecommands+=("default_cmds[${cmd}]='${opts[*]}'")
    done

    for cmd in "${no_optdump[@]}"; do
        corecommands+=("default_cmds[${cmd}]=''")
    done

    printf '    %s\n' "${corecommands[@]}"
}
