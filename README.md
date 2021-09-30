# gc__enhanced_bash_completion
an enhanced bash completion engine **_and_** context helper for golemsp and yagna

never again be at a loss in the middle of the command line as to what options or arguments are available to you _and what they do_ when invoking **golemsp** or **yagna**. gc__bash_completion will autocomplete entries at the press of a tab and provide contextual help straight from the command line. and after installing, it works seamlessly in every terminal session and integrates the official yagna completions from the current yagna installation without requiring the user to import them!

this program is designed to work with requestor and provider installations of the Golem software suite. for more information about the Golem Network, please visit: https://www.golem.network

# BACKGROUND
The problem gc__bash_completion solves is providing detailed help during command entry at a full stop by printing the help menu for the current subcommand during entry. yagna's builtin completion engine alone will only list possible completions in a given subcommand. gc__bash_completion extends yagna's builtin completion engine by adding contextual help.


# INSTALLATION
## clone
```
git clone https://github.com/krunch3r76/gc__bash_completion.git
cd gc__bash_completion.git
```

### automatically install/update
```
$ git pull && ./install.sh
```
- installs the completion engine to $HOME/.local/share/bash-completion/completions/gc_golem (if file is absent or version different)
- updates .bashrc automatically load the completion engine [optional] if needed

### manually install
```
$ mkdir -p $HOME/.local/share/bash-completion/completions/
$ cp gc_golem $HOME/.local/share/bash-completion/completions/
$ $(set -o noclobber; echo 'source $HOME/.local/share/bash-completion/completions/gc_golem' >> $HOME/.bashrc)
```

# DEMO
![Animated gif demo](https://krunch3r76.github.io/gc__bash_completion/gc__completion.gif)

# UPDATE WITH EXISTING CLONED REPO
the reader is encouraged to keep an existing cloned repo and update and install periodically. this should not be necessary inbetween releases but if some unexpected behavior occurs, it is recommended to check if an update is available to fix it. additoinally, it should not be necessary also when Golem provides a built in completion engine for golemsp.
```
$ cd gc__bash_completion
$ git pull # if message indicates already up to date it is still okay to run the install script
$ ./install.sh
```

# COMMENTS
The only changes made to the system after installation are
1) the file gc_golem is installed to $HOME/.local/share/bash-completion/completions/gc_golem
2) if requested, a line is added to $HOME/.bashrc to source the file from #1

The program does not in any way alter the original golemsp or yagna installation nor perform any actions on the user's behalf. Neither does it phone home or collect telemetry as well.
