# gc__enhanced_completion
an enhanced bash completion engine that extends built-in completions by providing contextual help for golemsp and yagna

never again be at a loss in the middle of the command line as to what options or arguments are available to you _and what they mean_ when invoking **golemsp** or **yagna**. gc__enhanced_completion one-ups bash autocompletion at the press of a tab by providing contextual help straight from the command line. it will work seamlessly in every terminal session and integrate the official yagna completions from the current yagna installation without requiring the user to import them manually!

this program is designed to work with requestor and provider installations of the Golem software suite. for more information about the Golem Network, please visit: https://www.golem.network

# DEMO
![Animated gif demo](https://krunch3r76.github.io/gc__bash_completion/gc__completion.gif)

# BACKGROUND
The problem gc__enhanced_completion solves is providing detailed help during command entry at a full stop by printing the help menu for the current subcommand during entry. yagna's builtin completion engine alone will only list possible completions in a given subcommand. gc__enhanced_completion extends yagna's builtin completion engine by adding contextual help.


# INSTALLATION
## clone
```
git clone https://github.com/krunch3r76/gc__enhanced_completion.git
cd gc__enhanced_completion
```

### automatically install/update
```
$ git pull && ./install.sh
```
- installs the completion engine to $HOME/.local/share/bash-completion/completions/gc_golem (if file is absent or version different)
- updates .bashrc to automatically load the completion engine [optional] if needed

### manually install
```
(gc__enhanced_completion)$ mkdir -p $HOME/.local/share/bash-completion/completions/
(gc__enhanced_completion)$ cp gc_golem $HOME/.local/share/bash-completion/completions/
(gc__enhanced_completion)$ $(set -o noclobber; echo 'source $HOME/.local/share/bash-completion/completions/gc_golem' >> $HOME/.bashrc)
```

# UPDATE WITH EXISTING CLONED REPO
the following should not be necessary once the script has matured (it is only a couple days in) unless some unexpected behavior occurs, in which case it is recommended to check if an update is available to fix it:

```
$ cd gc__enhanced_completion
$ git pull # if message indicates already up to date it is still okay to run the install script
$ ./install.sh
```

# COMMENTS
The only changes made to the system after installation are
1) the file gc_golem is installed to $HOME/.local/share/bash-completion/completions/gc_golem
2) if requested, a line is added to $HOME/.bashrc to source the file from #1

The program does not in any way alter the original golemsp or yagna installation nor perform any actions on the user's behalf. Neither does it phone home or collect telemetry as well.
