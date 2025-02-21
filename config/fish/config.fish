if status is-interactive
    alias l='eza -a --group-directories-first'
    # alias f='cd ~/dev/'
    alias reboot='reboot-safe'

    bind \co 'xdg-open . &>/dev/null < /dev/null'
    bind \eo 'cd ~/dev; commandline -f repaint;'
    bind \ep 'cd-git-root; commandline -f repaint'
    bind \en nvim
    bind \ei zj
    # bind \e\cn 'code . 2>/dev/null'
    bind \er 'just --list; commandline -f repaint'
    bind \e\cr 'just --choose; commandline -f repaint'
    bind \cg 'echo; git status --show-stash && echo && gitx status; commandline -f repaint'
    # NOTE: if you what to clear screen prepend this with clear;
    # bind \el 'echo; eza -a --group-directories-first; commandline -f repaint'
    bind \el 'echo; eza -l -a --hyperlink --group-directories-first --git --icons --time-style=relative --git-repos; commandline -f repaint'
    bind \ek 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'

    # bind \t accept-autosuggestion
    # bind \t forward-word
    # bind \ej edit_command_buffer
    bind \cs complete

    # To delete an abbreviation use `abbr -e t`
    abbr -a g git
    abbr -a d docker
    abbr -a j just
    abbr -a rm trash
    abbr -a we watchexec -e

    set -gx FZF_DEFAULT_OPTS '--height 70% --layout reverse --bind tab:down,btab:up,alt-s:toggle+down,alt-e:jump-accept'
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --strip-cwd-prefix'
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --strip-cwd-prefix'
    set -gx FZF_CTRL_T_COMMAND 'fd --type f --type d --hidden --strip-cwd-prefix'

    set -gx FZF_ALT_C_OPTS "--preview 'eza -l -a --group-directories-first --git --icons --time-style=relative --total-size --git-repos --color always {}'"
    fzf_key_bindings

    fzf_configure_dunder_bindings

    # TODO: --git_log might me useful
    fzf_configure_bindings --git_status=\e\cg --variables=\e\cv --git_log= --history=

    if string match -r '\;15$' $COLORFGBG &>/dev/null
        set -gx MCFLY_LIGHT TRUE
    end

    bind --erase \cr
    mcfly init fish | source
    bind \cr __mcfly-history-widget

    # NOTE: unreadable anyway in alacritty tokyo-night
    set -gx MCFLY_DISABLE_MENU true

    set -gx MCFLY_RESULTS 25
    set -gx MCFLY_FUZZY 3
    set -gx MCFLY_PROMPT "❯"
    # set -gx MCFLY_RESULTS_SORT LAST_RUN

    bind \cH backward-kill-word

    # NOTE: this clears screen and scrollback buffer
    bind \e\cl "printf '\033[2J\033[3J\033[1;1H'; commandline -f repaint;"

    set -gx PATH "$PATH:$FORGIT_INSTALL_DIR/bin"
    set -gx FORGIT_CHECKOUT_BRANCH_BRANCH_GIT_OPTS '--sort=-committerdate'

    if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION no-cursor
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end
    # set -gx SHELL (command --search fish)

    # export http_proxy=socks5://127.0.0.1:1080
    # export https_proxy=socks5://127.0.0.1:1080
end

function fish_title
    if set -q argv[1]
        echo (fish_prompt_pwd_dir_length=1 prompt_pwd)
        # echo (fish_prompt_pwd_dir_length=1 prompt_pwd): $argv
    else
        echo (fish_prompt_pwd_dir_length=1 prompt_pwd)
    end
end

function _hydro_pwd
    set --local git_root (command git --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
    set --local git_base (string replace --all --regex -- "^.*/" "" "$git_root")
    set --local path_sep /

    test "$fish_prompt_pwd_dir_length" = 0 && set path_sep

    set --local hydro_pwd (
        string replace --ignore-case -- ~ \~ $PWD |
        string replace -- "/$git_base/" /:/ |
        string replace --regex --all -- "(\.?[^/]{"(
            string replace --regex --all -- '^$' 1 "$fish_prompt_pwd_dir_length"
        )"})[^/]*/" "\$1$path_sep" |
        string replace -- : "$git_base" |
        string replace --regex -- '([^/]+)$' "\x1b[1m\$1\x1b[22m"
    )

    echo -n $hydro_pwd
end

function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)
    set -q fish_color_status
    or set -g fish_color_status red

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l color_cwd black
    set -l suffix ' ❯'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # Write pipestatus
    # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color $bold_flag $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

    set -g __fish_git_prompt_show_informative_status true
    set -g __fish_git_prompt_showdirtystate true
    set -g __fish_git_prompt_showuntrackedfiles true
    set -g __fish_git_prompt_char_dirtystate "~"
    set -g __fish_git_prompt_char_stagedstate "+"
    set -g __fish_git_prompt_char_untrackedfiles "∗"
    set -g __fish_git_prompt_char_cleanstate ""
    set -g __fish_git_prompt_showcolorhints false
    set -g __fish_git_prompt_char_stateseparator " "

    # NOTE: handled by kitty
    # if test $CMD_DURATION -gt 10000
    #     set -l seconds (math $CMD_DURATION / 1000)
    #     set -l rounded_seconds (math "round($seconds)")
    #     notify-send -a fish "last command exited after $rounded_seconds seconds"
    #
    #     # clear so that no notifications occur on repaints
    #     set -gx CMD_DURATION 0
    # end

    set -l systemd_shell ""
    if test "$SAFE_SYSTEMD_SHELL" = yes
        set systemd_shell " SYSTEMD-SHELL"
    end

    set -l background_jobs ""
    if jobs | grep -q -v "No current job"
        set background_jobs " [background jobs]"
    end

    # (prompt_pwd)
    echo -n -s (set_color -b ffb6c1) (set_color $color_cwd) (_hydro_pwd) (set_color -b normal) $normal (fish_vcs_prompt) $normal " "$prompt_status $systemd_shell (set_color red) $background_jobs $normal $suffix " "
end

# function fish_right_prompt -d "Write out the right prompt"
#     date '+%m/%d/%y'
# end

# NOTE: to disable fish greeting
set fish_greeting

# function fish_greeting
#     if test $TERM = alacritty
#         # echo The time is (set_color yellow; date +%T; set_color normal)
#         eza -a --group-directories-first
#     end
# end


# Change working dir in fish to last dir in lf on exit (adapted from ranger).
#
# You may put this file to a directory in $fish_function_path variable:
#
#     mkdir -p ~/.config/fish/functions
#     ln -s "/path/to/lfcd.fish" ~/.config/fish/functions
#
# You may also like to assign a key (Ctrl-O) to this command:
#
#     bind \co 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'
#
# You may put this in a function called fish_user_key_bindings.

function lfcd --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
    # `command` is needed in case `lfcd` is aliased to `lf`.
    # Quotes will cause `cd` to not change directory if `lf` prints nothing to stdout due to an error.
    cd "$(command lf -print-last-dir $argv)"
end

function zj
    zellij attach
    if test $status != 0
        zellij
    end
    commandline -f repaint
end

function run
    if test (count $argv) -ne 1
        echo "run <file>"
        return
    end
    set -f file_full $argv[1]
    set -f file (string split -r -m1 -f2 / $file_full)
    set -f file_project_path (string replace "$PWD/" '' $file_full)
    set -f pretty_pwd (string replace $HOME '~' $PWD)
    echo "PWD: $pretty_pwd  FILE: $file_project_path"
    set -f basename (string split -r -m1 -f1 . $file)
    set -f ext (string split -r -m1 -f2 . $file)
    dotenv
    set -f start_time (date +%s)

    switch $ext
        case py
            if test -d ./.venv
                . .venv/bin/activate.fish
            end
            set -l py_version $(python --version)
            set -l py_version_num $(string split -r -m1 -f2 ' ' $py_version)
            echo "python: $(which python) $py_version_num"
            print-line
            python $file_full
        case go
            set -f go_version (go version)
            set -f go_version_short (string split -f3 ' ' $go_version)
            if [ $file = "main.go" ]
                set -f go_cmd "go run -race"
                echo "$go_version_short  CMD: $go_cmd"
                print-line
                go run -race $file_full
            else
                set -f pkg_path (string replace $file '.' $file_full)
                set -f go_cmd "go test -cover -v -race"
                echo "$go_version_short  CMD: $go_cmd"
                print-line
                go test -cover -v -race $pkg_path
            end
        case lua
            luajit -v && print-line
            luajit $file_full
        case js
            set -l node_version $(node --version)
            echo "node $node_version" && print-line
            node $file_full
        case sh
            print-line
            echo "Not executing sh files. Too dangerous."
        case sql
            psql --version
            print-line
            psql postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB -a -f $file_full
        case md
            glow --version
            print-line
            glow $file_full
        case rs
            rustc --version
            print-line
            rustc $file_full && ./$basename && trash $basename
        case php
            docker run -it --rm --name temp-php --network host -v "$PWD":/usr/src/myapp -w /usr/src/myapp php:7.4-cli php $file
        case dockerfile
            print-line
            docker build -f $file_full -t temp:latest . && echo "EXECUTING docker run <image> bash" && docker run --rm -it temp:latest bash
        case c
            clang $file_full -o ./maintemp.bin && ./maintemp.bin && rm ./maintemp.bin
        case ''
            if test "$file" = Dockerfile
                print-line
                docker build -f $file_full -t temp:latest . && echo "EXECUTING docker run <image> bash" && docker run --rm -it temp:latest bash
            else
                echo "no file extension"
            end
        case '*'
            echo "running '$ext' files not configured"
    end

    set -f cmd_status $status
    set -f end_time (date +%s)
    set -f runtime (math $end_time - $start_time)
    print-line
    echo "Status code: $cmd_status | Runtime: $runtime""s"
end

# yes_or_no "question" true  -> default is yes
# yes_or_no "question" false  -> default is no
function yes_or_no
    set -f QUESTION $argv[1]
    set -f DEFAULT $argv[2]
    if test "$DEFAULT" = true
        set -f OPTIONS "[Y/n]"
        set -f DEFAULT y
    else
        set -f OPTIONS "[y/N]"
        set -f DEFAULT n
    end
    read -P "$QUESTION $OPTIONS " -n 1 -f INPUT
    if test ! -n $INPUT
        set -f INPUT $DEFAULT
    end
    if string match -r '^[yY]$' "$INPUT"
        return 0
    else
        return 1
    end
end

function search-and-replace
    set help "search-and-replace <filetype> 'foo' 'bar'
Special type `all` is available. Alternatively 'sad' can be used."
    if test "$argv" = --help
        echo $help
        return
    end
    if test "$argv" = -h
        echo $help
        return
    end
    if test (count $argv) -ne 3
        echo $help
        return
    end
    rg -C 1 --type $argv[1] $argv[2]
    if yes_or_no "All good?" false
        rg --files-with-matches --type $argv[1] $argv[2] | xargs sd $argv[2] $argv[3]
    else
        echo "Ok, aborted."
    end
    echo "All done!"
end

function cd-git-root --description "cd to the root of the current repo or home dir"
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
    if test $status = 0
        cd (git rev-parse --show-toplevel)
    else
        cd
    end
end

function down --description "cd to the root of the current repo"
    cd ~/Downloads/
end

function mkcd --description "make and cd to a directory"
    if test (count $argv) -ne 1
        echo "mkcd <dir>"
    end
    mkdir -pv $argv[1]
    and cd $argv[1]
end

function randpass
    if test -n "$argv[1]"
        if yes_or_no "Add extra characters?" true
            tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c "$argv[1]" | wl-copy
        else
            tr -dc A-Za-z0-9 </dev/urandom | head -c "$argv[1]" | wl-copy
        end
        echo "Password copied to clipboard."
    else
        echo "No length passed!"
    end
end

function pyvenv --description "create python virtual environment, activate and install packages"
    set help "pyvenv <package1> <package2> ...
Will create and activate python venv in current directory and install packages.
No argements can be provided to simply create empty venv.
Oherwise 3 modes are available:
`-r` - install from requirements.txt
`-ds` - install ds packages
`<pkg1> <pkg2> ...` - install specified packages
"
    if test "$argv" = --help
        echo $help
        return
    end
    if test "$argv" = -h
        echo $help
        return
    end
    if test -d ./.venv
        echo ".venv directory found"
    else
        yes_or_no "Create virtual environment?" false
        if test $status = 0
            python -m venv .venv
            and echo "created .venv directory"
        else
            echo aborted
            return 1
        end
    end

    if test $status = 0
        . .venv/bin/activate.fish
    end

    if test $status = 0 -a (which python) = (pwd)/.venv/bin/python
        echo "activated venv"
        if test (count $argv) -gt 0
            if test $argv[1] = -r
                echo "installing packages from requirements.txt"
                python -m pip install --upgrade pip
                and python -m pip install -U wheel
                and python -m pip install -r requirements.txt
                and echo "installed packages"
            else if test $argv[1] = -ds
                set -l ds numpy matplotlib pandas seaborn ipykernel jupyterlab scipy scikit-learn SQLAlchemy Pillow requests beautifulsoup4 opencv-python ipywidgets ydata-profiling scikit-image[optional] tqdm python-dotenv sympy
                echo "installing these: $ds; and pytorch"
                python -m pip install --upgrade pip
                and python -m pip install -U wheel
                and python -m pip install -U $ds
                and python -m pip install -U torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
                and python -m pip install -U torchinfo timm
                and jupyter labextension enable widgetsnbextension
            else
                echo "installing packages from arguments"
                python -m pip install --upgrade pip
                and python -m pip install -U wheel
                and python -m pip install -U $argv
                and set -l npkg (count $argv)
                and echo "installed $npkg packages"
            end
        end
    else
        echo "failed to create and activate venv"
    end
end

function pyvenv-silent
    if test -d ./.venv
        . .venv/bin/activate.fish
        notify-send ".venv activated - nvim"
    end
end

function print-line
    set -l terminal_width $(tput cols)
    printf '%*s\n' "$terminal_width" '' | tr " " -
end

function we
    set help "we <filetype> <cmd>
Watch files and execute <cmd> on change."
    if test "$argv" = --help
        echo $help
        return
    end
    if test "$argv" = -h
        echo $help
        return
    end
    if test (count $argv) -ne 2
        echo $help
        return
    end
    set -l ft $argv[1]
    set -l cmd $argv[2..(count $argv)]
    watchexec -e $ft --shell='fish -i' -- "clear && echo '$ft --> $cmd'  && date +%T && print-line && $cmd"
end

function wer
    set help "we <filetype> <cmd>
Watch files and reload <cmd> on change."
    if test "$argv" = --help
        echo $help
        return
    end
    if test "$argv" = -h
        echo $help
        return
    end
    if test (count $argv) -ne 2
        echo $help
        return
    end
    set -l ft $argv[1]
    set -l cmd $argv[2..(count $argv)]
    watchexec -r --debounce 1sec -e $ft --shell='fish -i' -- "notify-send -t 1000 'Restarting: $cmd' && clear && echo '$ft --> $cmd'  && date && print-line && $cmd"
end

# function pre-commit-init
#     if test -e ".pre-commit-config.yaml"
#         echo 'pre-commit file already exists'
#     else
#         curl -L -O https://raw.githubusercontent.com/barklan/common/main/touse/.pre-commit-config.yaml
#     end
#     pre-commit install
#     and pre-commit install --hook-type commit-msg
#     and pre-commit install --hook-type post-commit
# end
#
#
# function pre-commit-rm
#     pre-commit uninstall
#     and pre-commit uninstall --hook-type commit-msg
#     and pre-commit uninstall --hook-type post-commit
# end

function nvim-sessions-clean
    rm ~/.local/share/nvim/sessions/*
end

function dotenv
    # Parses commend-line arguments and sets _flag_[xuh] variables. Complains if the user tries to use both -x and -u.
    argparse --name=dotenv -x 'u,x' u/unset h/help x/export q/quiet -- $argv

    # If the h or --help flags are set (both can be checked using _flag_h), display help, and ignore everything else.
    if test $_flag_h
        __help_dotenv
    else
        # Any non-option command-line arguments are assumed to be .env files, so we check to see if any are present.
        if set -q argv; and test (count $argv) -gt 0
            set env_files $argv
            # If no environment files are specified on the command-line, we default to .env
        else
            set env_files .env
        end
        # Loop through all of the specified environment variable files and set any variables found within
        for env_file in $env_files
            if test -r $env_file
                while read -l line
                    # Set variables to be global, otherwise they will not be available in your shell once this script
                    # has finished running.
                    set set_args -g

                    # Remove the "export" directive from the line if present, and set a variable indicating whether or
                    # not it was found. Negate the return value of "string replace" so that 1/true means we found the
                    # export directive. This makes its usage easier to follow in subsequent lines.
                    set trimmed_line (not string replace -r '^\s*export\s+' '' -- $line)
                    set export $status

                    # If we found the export directive in the previous step, or if -x/--export was specified on the
                    # command-line, set the export flag for the upcoming 'set' command.
                    if test $export -eq 1; or begin
                            set -q _flag_x; and test "$_flag_x" = -x
                        end
                        set set_args "$set_args"x
                    end

                    # Check to see if the line we are processing is basically sane. The fish set command will ignore
                    # leading white space on the variable name, so we allow it in our check.
                    if string match -q --regex -- '^\s*[a-zA-Z0-9_]+=' "$trimmed_line"
                        # Split the current line into name and value, and store them in $kv. We use -m1 because we only
                        # want to split on the first "=" we encounter. Everything after that, including additional "="
                        # characters, is part of the value.
                        set kv (string split -m 1 = -- $trimmed_line)
                        # If -u/--unset has been specified, erase the variable.
                        if set -q _flag_u; and test "$_flag_u" = -u
                            set -e $kv[1]
                            # Otherwise, set the shell variable. The variable $kv contains both the name and the value we
                            # want to set.
                        else
                            set $set_args $kv
                        end
                    end
                    # Combined with the `while` keyword, this reads $env_file one line at a time.
                end <$env_file
                echo "read $env_file"

            else
                if not set -q _flag_q; or test "$_flag_q" != -q
                    echo "Unable to locate $env_file file"
                end
            end
        end
    end

    # This function will be available to be called directly from the shell, even though it is defined inside of dotenv.
    # I put it into its own function because I think it looks a little cleaner than having a big blob of echoes inside
    # the "if" statement near the top of this function.
    function __help_dotenv
        echo "Usage: dotenv [-u] [files]"
        echo "-h/--help: Display this help message."
        echo "-u/--unset: Read [files] and unset the variables found therein."
        echo "-x/--export: Force variables to be exported, regardless of whether or not they are preceded by 'export' in the env file."
        echo "[files]: One or more files containing name=value pairs to be read into the environment. Defaults to .env."
        echo ""
    end
end
