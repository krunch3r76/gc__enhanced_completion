# gc__bash_completion
an enhanced bash completion engine **_and_** context helper for golemsp and yagna

never again be at a loss in the middle of the command line as to what options or arguments are available to you when invoking **golemsp** or **yagna**. gc__bash_completion will autocomplete entries at the press of a tab and provide contextual help straight from the command line. and after installing, it works seamlessly in every terminal session!

this program is designed to work with requestor and provider installations of the Golem software suite. for more information about the Golem Network, please visit: https://www.golem.network

# BACKGROUND
The problem gc__bash_completion solves is providing pertinent, concise and cogent help from the command-line. Currently, Golem provides a yagna tabbed completion engine. Until it becomes part of the standard install, it can be added via the command `yagna complete bash 2>&1 >$HOME/.local/share/bash-completion/completions/yagna`. Note that gc__bash_completion is designed to work with and will not break Golem's in-house completion script.

But the in-house tabbed completion lists all possible subcommands and arguments and without the contextual help this provides. This makes it difficult for someone new to the interface to readily identify desirable completions. gc__bash_completion aims to declutter and enhance the autocompletion experience by making suggestions pertinent to the current command or argument and providing contextual help. the engine is always up to date as it imports whatever yagna completions are currently installed. note, it is not necessary to manually install the golem in-house completions as the script does this for you.

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
currently this project is expected to be stable on the main branch with updates to the engine as they emerge.
the reader is encouraged to keep an existing cloned repo and update and install periodically. this should not be necessary inbetween releases but if some unexpected behavior occurs, it is recommended to check if an update is available to fix it.
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
