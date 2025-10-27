# gc__enhanced_completion

**gc__enhanced_completion** is a Bash completion helper that extends the built‑in completions for **golemsp** and **yagna** by showing contextual help right in your terminal.  
No more guessing what options or arguments are available – just press `<Tab>` and see a short description of each possible choice.

> Works with both requestor and provider installations of the Golem software suite.  
> Learn more about the Golem Network at <https://www.golem.network>.

---

## Demo

![Animated gif demo](https://krunch3r76.github.io/gc__bash_completion/gc__completion.gif)

---

## Why this tool?

* **Built‑in yagna completion** only lists possible completions.  
* **gc__enhanced_completion** prints the help text for the current subcommand while you type, giving you instant context.

---

## Installation

### Quick & clean (recommended)

```bash
curl -sSf https://github.com/krunch3r76/gc__enhanced_completion/blob/main/install.sh | bash -
```

The script will:

1. Copy `gc_golem` to `$HOME/.local/share/bash-completion/completions/`
2. Add a line to your `.bashrc` (if it isn’t already there) so the completion is loaded automatically.

### Clone & tinker

```bash
git clone https://github.com/krunch3r76/gc__enhanced_completion.git
cd gc__enhanced_completion
```

#### Update from Git

```bash
git pull && ./install.sh
```

The script behaves exactly as in the quick install.

### Manual installation

If you prefer to do it yourself:

```bash
mkdir -p $HOME/.local/share/bash-completion/completions/
cp gc_golem $HOME/.local/share/bash-completion/completions/

# Add a source line to .bashrc if it isn’t already present
set -o noclobber; echo 'source $HOME/.local/share/bash-completion/completions/gc_golem' >> $HOME/.bashrc
```

---

## What changes are made?

1. `gc_golem` is installed to `$HOME/.local/share/bash-completion/completions/`.
2. (Optional) A line that sources the file is appended to your `.bashrc`.

No other files are touched, and the tool never modifies the original **golemsp** or **yagna** binaries. It also does not send telemetry or “phone home”.

---

## Tips & Troubleshooting

* **Disable the terminal bell** (the annoying beep when you hit `<Tab>` on an empty line):

  ```bash
  bind 'set bell-style none'
  ```

* If you’re using a different shell, adapt the installation path accordingly.

---

Happy hacking with Golem! 🚀
