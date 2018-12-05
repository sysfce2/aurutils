divert(-1)dnl
dnl List of commands to be completed
dnl
define(`CORECOMMANDS',
HAVE_OPTDUMP(build,fetch-snapshot,search,fetch,repo-filter,
             repo,chroot,pkglist,fetch-git,vercmp,sync,rpc)dnl
NO_OPTDUMP(depends,jobs,graph,srcver,vercmp-devel))

dnl recursively print all elements
dnl How the element is ultimately printed depends on the
dnl wrap_has_dump and wrap_no_dump macros
dnl
define(`HAVE_OPTDUMP',`ifelse(`$#',`0', ,`$#',`1',`wrap_has_dump(`$1') ',`wrap_has_dump($1)' `HAVE_OPTDUMP(shift($@))')')
define(`NO_OPTDUMP',`ifelse(`$#',`0', ,`$#',`1',`wrap_no_dump(`$1') ',`wrap_no_dump($1)' `NO_OPTDUMP(shift($@))')')

dnl override how elements are printed for SUBCOMMANDS macro
dnl which defines an array with all avaliable subcommands
dnl
pushdef(`wrap_has_dump','$1')
pushdef(`wrap_no_dump','$1')
define(SUBCOMMANDS,subcommands=(CORECOMMANDS))

dnl override how elements are printed for the DEFAULT_OPTS
dnl which is a simple function that returns the options available for a
dnl subcommand using case statement construct.
dnl
pushdef(`wrap_has_dump',`
	$1) printf -- GET_OPTS($1) ;;')
pushdef(`wrap_no_dump',`
	$1) : nothing to print ;;')
define(DEFAULT_OPTS,
`_get_default_opts() {
    case "`$'1" in CORECOMMANDS
    esac
}')

dnl Helper macro to retrieves options from subcommand --dump-options
dnl
define(GET_OPTS,'`translit(esyscmd(../lib/aur-$1 --dump-options),`
',` ')'')
divert(0)dnl
