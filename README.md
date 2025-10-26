# gc__enhanced_completion
an enhanced bash completion engine that extends built-in completions by providing contextual help for golemsp and yagna

never again be at a loss in the middle of the command line as to what options or arguments are available to you _and what they mean_ when invoking **golemsp** or **yagna**. gc__enhanced_completion one-ups bash autocompletion at the press of a tab by providing contextual help straight from the command line. it will work seamlessly in every terminal session and integrate the official yagna completions from the current yagna installation without requiring the user to import them manually!

this program is designed to work with requestor and provider installations of the Golem software suite. for more information about the Golem Network, please visit: https://www.golem.network

# DEMO
![Animated gif demo](https://krunch3r76.github.io/gc__bash_completion/gc__completion.gif)

# BACKGROUND
The problem gc__enhanced_completion solves is providing detailed help during command entry at a full stop by printing the help menu for the current subcommand during entry. yagna's builtin completion engine alone will only list possible completions in a given subcommand. gc__enhanced_completion extends yagna's builtin completion engine by adding contextual help.


# INSTALLATION
## quick and clean
```
curl -sSf https://github.com/krunch3r76/gc__enhanced_completion/blob/main/install.sh | bash -
```

## clone and tinker method
```
git clone https://github.com/krunch3r76/gc__enhanced_completion.git
cd gc__enhanced_completion
```

### automatically install/update via git
```
$ git pull && ./install.sh
```
- installs the completion engine to $HOME/.local/share/bash-completion/completions/gc_golem (if file is absent or version different)
- updates .bashrc to automatically load the completion engine [optional] if needed

## manually install
```
(gc__enhanced_completion)$ mkdir -p $HOME/.local/share/bash-completion/completions/
(gc__enhanced_completion)$ cp gc_golem $HOME/.local/share/bash-completion/completions/
(gc__enhanced_completion)$ $(set -o noclobber; echo 'source $HOME/.local/share/bash-completion/completions/gc_golem' >> $HOME/.bashrc)
```

# COMMENTS
The only changes made to the system after installation are
1) the file gc_golem is installed to $HOME/.local/share/bash-completion/completions/gc_golem
2) $HOME/.bashrc if adding a line to source gc_golem

The program does not in any way alter the original golemsp or yagna installation nor perform any actions on the user's behalf. Neither does it phone home or collect telemetry as well.

# TIPS
The annoying beep sound you may be hearing when tabbing an empty space can be turned off via terminal preferences or in a session with `bind 'set bell-style none'`
