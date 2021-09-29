# gc__bash_completion
a bash completion engine and context helper for golemsp and yagna

never again be at a loss in the middle of the command line as to what options or arguments are available to you when invoking **golemsp** or **yagna**. gc__bash_completion will autocomplete entries with a tab and provide contextual help straight from the command line. and after installing, it works seamlessly in every terminal session!

# INSTALLATION
$ ./install.sh # this installs the completion engine to $HOME/.local/share/bash-completion/completions/gc_golem
#follow instructions to automatically load the completion engine

# DEMO
![Animated gif demo](https://krunch3r76.github.io/gc__bash_completion/gc__completion.gif)

# COMMENTS
The only changes made to the system after installation are
1) the file gc_golem is installed to $HOME/.local/share/bash-completion/completions/gc_golem
2) if requested, a line is added to $HOME/.bashrc to source the file from #1

The program does not in any way alter the original golemsp or yagna installation nor perform any actions on the user's behalf. Neither does it phone home as well.
