#!/bin/bash
# set -x
export PS4='`[[ $? == 0 ]] || echo "\e[1;31;40m($?)\e[m\n "`:.$LINENO:'

# "sp" -- scratch-pad operations for files
#
# use a "scratch-pad" directory to copy and move files around

# 2020-07-13
#   -   uses ~/.cache so that moves are instantaneous even for humongous files
#   -   uses `cp --reflink=auto` so that copies, at least on file systems that
#       support reflinks/CoW, are also instantaneous

# 2022-12-11
#   -   now can do piped in/out data also, idea from a recent reddit thread
#   -   now behaves like you might expect from a GUI file manager -- nothing
#       actually happens on disk until you run "sp paste"
#   -   **specifically**, consecutive "sp cut file..." without paste in
#       between don't act like a glorified form of "delete"
#   -   added brief usage blurb

SPDIR=$HOME/.cache/SPDIR
mkdir -p $SPDIR

# ----------------------------------------------------------------------

die() { echo >&2 "$*"; exit 1; }
usage() {
    cat <<-EOF
	Usage:
	    sp verb list
	    command | sp
	    sp | command
	where, in the first form,
	    verb: is s|status, c|copy, C|cut, p|paste, pp|paste-with-parents
	        (short or long forms may be used)
	    list: is a list of files and directories relative to current
	        directory, and is only needed for the copy and cut operations
EOF
}

ln_pwd() {
    rm -f $SPDIR/.dir
    ln -sf $PWD $SPDIR/.dir
}

if [[ -z $1 ]]; then
    [[ -t 0 ]] || [[ -t 1 ]] || die "pipein AND pipeout does not make sense"
    [[ -t 0 ]] && [[ -t 1 ]] && usage
    [[ -t 0 ]] || set -- pipein
    [[ -t 1 ]] || set -- pipeout
fi

op=$1; shift
case $op in
    -h|--help )
        usage
        ;;
    s|status )
        cd $SPDIR
        [[ -d .dir ]] || die "nothing here"
        rp=$(realpath .dir)
        [[ -f .cut  ]] && echo "files to be moved from '$rp':"  && cat .cut
        [[ -f .copy ]] && echo "files to be copied from '$rp':" && cat .copy
        ;;
    c|copy )
        ln_pwd
        rm -f $SPDIR/.cut
        printf "%s\n" "$@" > $SPDIR/.copy
        ;;
    C|cut )
        ln_pwd
        rm -f $SPDIR/.copy
        printf "%s\n" "$@" > $SPDIR/.cut
        ;;
    p|paste )
        od="$PWD"
        cd $SPDIR
        [[ -d .dir ]] || die "nothing here"
        cd .dir
        [[ -f $SPDIR/.cut  ]] && cat $SPDIR/.cut  | xargs -d$'\n' mv -t "$od"
        [[ -f $SPDIR/.copy ]] && cat $SPDIR/.copy | xargs -d$'\n' cp -t "$od"
        rm -f $SPDIR/.cut
        ;;
    pp|paste-with-parents )
        od="$PWD"
        cd $SPDIR
        [[ -d .dir ]] || die "nothing here"
        cd .dir
        [[ -f $SPDIR/.cut  ]] && die NOT YET IMPLEMENTED
        [[ -f $SPDIR/.copy ]] && cat $SPDIR/.copy | xargs -d$'\n' cp --parents -t "$od"
        # -- will be needed when cut/pp is implemented -- rm -f $SPDIR/.cut
        :
        ;;
    pipein )
        cd $SPDIR
        cat > .piped-data
        ;;
    pipeout )
        cd $SPDIR
        cat .piped-data
        ;;
esac

