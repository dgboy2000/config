# @(#) Leland Systems .cshrc version 3.0.6
#
# Commands in the .cshrc file are executed after /etc/csh.cshrc
# and before those in the .login file.  This file is read each time
# you directly or indirectly start a shell process.
#
# This file is used by both tcsh and csh.  See the man page for
# tcsh for a list of the many options that the shell supports.
#
# tcsh reads files in the following order:
#    /etc/csh.cshrc	(system file, for all shells)
#    /etc/csh.login	(system file, for login shells only)
#    ~/.cshrc		(user file, for all shells)
#    ~/.login		(user file, for login shells only)

#------#
# Path #
#------#

# User path customizations go AFTER the endif line.

# First, set up a default path (site_path).  The local default
# should be set for you in /etc/csh.cshrc.  If none is set, we
# set a resonable default base system path here.

if ( ! $?site_path ) then
    if ( -f /etc/debian_version || -f /etc/redhat_release ) then
        set site_path=( \
            /usr/local/bin /usr/bin /bin /usr/bin/X11 /usr/sbin /sbin \
            /usr/games /usr/sweet/bin /usr/pubsw/bin /usr/pubsw/X/bin \
            )
    else
        set site_path=( \
            /usr/local/bin /usr/sweet/bin /usr/pubsw/bin \
            /usr/bin /bin /usr/sbin /sbin /usr/proc/bin \
            /usr/local/X/bin /usr/sweet/X/bin /usr/pubsw/X/bin /usr/bin/X11 \
            /opt/SUNWspro/bin /opt/langtools/bin /usr/lang /usr/ccs/bin \
            /usr/ucb /usr/bsd /usr/etc \
            /usr/dt/bin /usr/openwin/bin /usr/demos/bin /usr/audio/bin \
            /usr/games \
            )
    endif
endif

# Now we actually set the path.
# We add your home directory and bin directory to the system list.
# You may add additional path customizations here.
set path=( $site_path ~/bin ~ )
set path = ( /usr/class/cs140/`uname -m`/bin $path )

#------------#
# All Shells #
#------------#

umask 077		# file protection no read or write for others
			# umask 022 is no write but read for others

limit coredumpsize 0	# don't write core dumps
set noclobber		# don't overwrite existing file w/ redirect
set rmstar		# prompt before executing rm *
alias cp 'cp -i'	# prompt before overwriting file
alias mv 'mv -i'	# prompt before overwriting file
alias rm 'rm -i'	# prompt before removing file

if (! $?prompt) exit    # exit if noninteractive -- starts faster

# Everything below this line is only for interactive shells

#-------------------------#
# Environmental Variables #
#-------------------------#

# Environmental variables are used by both shell and the programs
# the shell runs.


### EDITOR (default editor)
# Common choices include pico, emacs, and vi.  Uncomment your choice.
#
# "pico" is the default since it has menu options and is simple.
#   It is extremely limited; experienced users may want to switch.
# "emacs" is a powerful editor with numerous features, but can be
#   non-intuitive for novices.  It is especially useful for
#   programming, html, and complex edits.  Run "teachemacs" for a tutorial.
# "vi" is the classic UNIX editor standard on all systems; it can be
#   hard to learn.  Run "vitutor" for a tutorial.  nvi, vim, and
#   vile are popular vi clones that are also available.
#
#setenv EDITOR "pico -tz"
#setenv EDITOR "emacs"
#setenv EDITOR "vi"

# Some programs honor VISUAL, so set this if EDITOR is set.
if ( $?EDITOR ) then
    setenv VISUAL "$EDITOR"
endif

#---------------------------------------#
# Shell-Dependent Variables and Aliases #
#---------------------------------------#

# tcsh is a near superset of csh.  Since this file is read by
# both shells, we only set those items particular to tcsh if
# tcsh is running.  Similarly, we handle csh-only settings here.

if ($?tcsh) then	# tcsh settings
    set prompt="%m:%~%# "	# set prompt to hostname:cwd>
    set autolist=ambiguous	# display possible completions
    set nobeep			# do not beep if completions exist
    set listmax=50		# ask if completion has >50 matches
    set symlinks=ignore		# treat symlinks as real
    set pushdtohome		# pushd w/o arguments defaults to ~
    alias back 'cd -'		# chdir to previous directory

else			# csh settings
    set filec			# allow Esc filename completion
    set host=`hostname | sed -e 's/\..*//'`
    alias setprompt 'set prompt="${host}:$cwd:t%"'
    alias cd 'chdir \!* && setprompt'	# ensure prompt has cwd
    setprompt			# set the prompt
endif

#-----------------#
# Shell Variables #
#-----------------#

# variables customize the shell.  See the man page for the full list.

set history=100		# number of history commands to save
set notify		# immediate notification when jobs finish
set ignoreeof		# disable ctrl-d from logging out
			# experienced users may want to delete this

# cdpath and fignore are time-savers, but can be confusing to novices
	# cdpath contains a search path for the cd command
#set cdpath=(. .. ~)
	# fignore contains suffixes to ignore for file completion
#set fignore=(\~ .o)

#---------------#
# Shell Aliases #
#---------------#

# Aliases provide a means to add commands and personalize your shell.

# Command aliases
alias .. 'cd ..'			# go up one directory
alias quiet '\!* >& /dev/null &'	# run a command with no output
alias orig 'cp -p \!:1 \!:1.orig'	# backup file

# Aliases which add or alter functionality
alias lpr 'lpr -h'		# suppress banner page (saves paper)
alias jobs 'jobs -l'		# also show process id's
alias dir 'ls -alg'		# show group, size information
#alias kinit 'kinit -t'		# obtain a token when getting a ticket
#alias ls 'ls -F'		# show file types
#alias enscript enscript -2rGh	# print 2up, rotated, fancy banner
#alias ftp ncftp 		# ncftp is a nicer ftp
#alias talk ytalk		# ytalk is a nicer talk

# Typo Protection: a forgiving shell is a friendly shell
#alias figner finger
#alias mroe more

#-------------#
# Completions #
#-------------#

# Programmable completion is one of the nicest features of tcsh.

if ($?tcsh) then

# shell variable and alias commands
complete set 'p/1/s/=/'		# set <shell variable>=
complete printenv 'p/1/e/'	# printenv <Environmental variable>
complete unsetenv 'p/1/e/'	# unsetenv <Environmental variable>
complete setenv 'p/1/e/'	# setenv <Environmental variable>

# common commands
complete elm 'c@=@F:'$HOME'/Mail/@'	# let elm -f =[TAB] work

# common user subcommands for the AFS fs command
complete fs 'p/1/(setacl listacl listquota examine help mkmount \
		rmmount checkservers flush)/'

endif

#-------------------#
# Terminal Settings #
#-------------------#

# turn off needless delays for special characters
stty cr0 nl0 -tabs ff0 bs0

# establish common bindings for terminal functions
stty intr '^C' erase '^?' kill '^U' quit '^\'

# set up common output settings
stty ixany -istrip

# disable the shell's own commandline editing for shell-mode in emacs
if ($?EMACS) then
    if ($EMACS == t) then
	unset edit
	stty -nl -onlcr -echo
    endif
endif
