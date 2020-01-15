setopt no_beep                # dont beep on error
setopt interactive_comments   # Allow comments in interactive shells
setopt cdablevars             # if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt pushd_ignore_dups      # dont push multiple copies of the same directory onto the directory stack
setopt extended_glob          # treat #, ~, and ^ as part of patterns for filename generation
setopt append_history         # Allow multiple terminal sessions to all append to one zsh command history
setopt extended_history       # save timestamp of command and duration
setopt inc_append_history     # Add comamnds as they are typed, dont wait until shell exit
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt hist_ignore_dups       # Do not write events to history that are duplicates of immediately prior events
setopt hist_ignore_all_dups   # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space      # remove command line from history list when first character on the line is a space
setopt hist_find_no_dups      # When searching history dont display results already cycled through twice
setopt hist_reduce_blanks     # Remove extra blanks from each command line being added to history
setopt hist_fcntl_lock
setopt share_history          # imports new commands and appends typed commands to history
setopt always_to_end          # When completing from the middle of a word, move the cursor to the end of the word
setopt auto_menu              # show completion menu on successive tab press. needs unsetop menu_complete to work
unsetopt auto_name_dirs       # disable: any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word       # Allow completion from within a word/phrase
unsetopt menu_complete        # autoselect the first completion entry
setopt correct                # spelling correction for commands
unsetopt correctall           # spelling correction for arguments
setopt prompt_subst           # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt transient_rprompt      # only show the rprompt on the current prompt
setopt multios                # perform implicit tees or cats when multiple redirections are attempted
unsetopt case_match
setopt glob_dots
setopt numeric_glob_sort
setopt autopushd
setopt pushdminus
unsetopt flow_control
setopt auto_param_slash
setopt case_glob
setopt long_list_jobs     # List jobs in the long format by default.
setopt notify             # Report status of background jobs immediately.
unsetopt bg_nice          # Don't run all background jobs at a lower priority.
unsetopt hup              # Don't kill jobs on shell exit.
unsetopt check_jobs       # Don't report on jobs when shell exit.
setopt combining_chars
unsetopt mail_warning

HISTSIZE=1000000
SAVEHIST=1000000
