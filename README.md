# gc__bash_completion
a bash completion engine and context helper for golemsp and yagna

never again be at a loss in the middle of the command line as to what options or arguments are available to you when invoking **golemsp** or **yagna**. gc__bash_completion will autocomplete entries at the press of a tab and provide contextual help straight from the command line. and after installing, it works seamlessly in every terminal session!

this program is designed to work with requestor and provider installations of the Golem software suite. for more information about the Golem Network, please visit: https://www.golem.network

# INSTALLATION
## clone
```
git clone https://github.com/krunch3r76/gc__bash_completion.git
cd gc__bash_completion.git
```

### automatically install/update
```
$ ./install.sh
```
- installs the completion engine to $HOME/.local/share/bash-completion/completions/gc_golem (if file is absent or version different)
- updates .bashrc automatically load the completion engine [optional] if needed

### manually install
```
$ mkdir -p $HOME/.local/share/bash-completion/completions
$ cp gc_golem $HOME/.local/share/bash-completion/completions
$ $(set -o noclobber; echo 'source $HOME/.local/share/bash-completion/completions/gc_golem' >> $HOME/.bashrc)
```

# DEMO
![Animated gif demo](https://krunch3r76.github.io/gc__bash_completion/gc__completion.gif)

# COMMENTS
The only changes made to the system after installation are
1) the file gc_golem is installed to $HOME/.local/share/bash-completion/completions/gc_golem
2) if requested, a line is added to $HOME/.bashrc to source the file from #1

The program does not in any way alter the original golemsp or yagna installation nor perform any actions on the user's behalf. Neither does it phone home or collect telemetry as well.
