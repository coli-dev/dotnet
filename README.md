# Fish + OpenCode Setup Tutorial (Ubuntu/Debian)

This repository now contains a copied and sanitized setup under:

- `.config/fish`
- `.config/opencode`

Secrets were removed and replaced with placeholders.

## 0) WSL2 hostname setup (recommended on Windows)

If you run this on WSL2, pin the hostname via `/etc/wsl.conf`.

```bash
sudo tee /etc/wsl.conf >/dev/null <<'EOF'
[boot]
systemd=true

[network]
hostname=your-hostname
generateHosts=false
EOF
```

Then keep Linux hostname files aligned:

```bash
echo "your-hostname" | sudo tee /etc/hostname
sudo tee /etc/hosts >/dev/null <<'EOF'
127.0.0.1 localhost
127.0.1.1 your-hostname

::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF
```

Apply changes by restarting WSL from Windows PowerShell:

```powershell
wsl --shutdown
```

Then reopen distro and verify:

```bash
hostname
cat /etc/wsl.conf
```

## 1) Install Fish with APT

```bash
sudo apt update
sudo apt install -y fish curl jq perl python3 git unzip
```

Set Git identity (recommended):

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Optional: set Fish as default shell:

```bash
chsh -s /usr/bin/fish
```

Log out and log in again.

## 2) Install Homebrew (Linux)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then load brew in your shell:

```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

## 3) Install required packages from Brew

Based on `.config/fish/config.fish`, install these required tools:

```bash
brew install zoxide starship ncdu go gh ripgrep
brew install oven-sh/bun/bun
brew install anomalyco/tap/opencode
brew install --cask copilot-cli
```

Notes:

- `jq`, `curl`, `perl`, `python3` are required by `bin/aicommit`.
- `unzip` is useful for WakaTime plugin CLI extraction.

## 4) Configure Fish using the copied config

This repo already has:

- `.config/fish/config.fish`
- `.config/fish/conf.d/go.fish`

To apply to your local account:

```bash
mkdir -p ~/.config
rsync -a .config/fish/ ~/.config/fish/
```

## 5) Configure OpenCode using the copied config

This repo already has a copied OpenCode setup in `.config/opencode`.

To apply it locally:

```bash
mkdir -p ~/.config
rsync -a .config/opencode/ ~/.config/opencode/
cd ~/.config/opencode
bun install
```

## 6) Ask user for env values and replace placeholders

The copied config is sanitized and contains placeholders.

Run this script to prompt for values, export them in the current shell, and replace placeholders in local copied files:

```bash
read -rsp "ANTHROPIC_AUTH_TOKEN: " ANTHROPIC_AUTH_TOKEN; echo
read -rsp "LLMGATE_API_KEY: " LLMGATE_API_KEY; echo
read -rsp "CONTEXT7_API_KEY: " CONTEXT7_API_KEY; echo
read -rsp "LITELLM_API_KEY: " LITELLM_API_KEY; echo
read -rsp "MORPH_API_KEY: " MORPH_API_KEY; echo
read -rsp "EXA_API_KEY: " EXA_API_KEY; echo
read -rsp "OPENAI_API_KEY (for aicommit): " OPENAI_API_KEY; echo

export ANTHROPIC_AUTH_TOKEN LLMGATE_API_KEY CONTEXT7_API_KEY LITELLM_API_KEY MORPH_API_KEY EXA_API_KEY OPENAI_API_KEY

python3 - <<'PY'
import os
from pathlib import Path

replacements = {
    "env://LLMGATE_API_KEY": os.environ["LLMGATE_API_KEY"],
    "env://CONTEXT7_API_KEY": os.environ["CONTEXT7_API_KEY"],
    "env://MORPH_API_KEY": os.environ["MORPH_API_KEY"],
    "env://LITELLM_API_KEY": os.environ["LITELLM_API_KEY"],
    "<EXA_API_KEY>": os.environ["EXA_API_KEY"],
    "<set-in-env-or-local-secret>": os.environ["ANTHROPIC_AUTH_TOKEN"],
}

targets = [
    Path('.config/opencode/opencode.json'),
    Path('.config/opencode/opencode-mem.jsonc'),
    Path('.config/fish/config.fish'),
]

for path in targets:
    data = path.read_text(encoding='utf-8')
    for old, new in replacements.items():
        data = data.replace(old, new)
    path.write_text(data, encoding='utf-8')
    print(f"Updated: {path}")
PY
```

If you do not want secrets written into files, skip replacement and keep env-based placeholders.

Then persist envs for fish sessions (recommended):

```bash
set -Ux ANTHROPIC_AUTH_TOKEN "$ANTHROPIC_AUTH_TOKEN"
set -Ux LLMGATE_API_KEY "$LLMGATE_API_KEY"
set -Ux CONTEXT7_API_KEY "$CONTEXT7_API_KEY"
set -Ux LITELLM_API_KEY "$LITELLM_API_KEY"
set -Ux MORPH_API_KEY "$MORPH_API_KEY"
set -Ux EXA_API_KEY "$EXA_API_KEY"
set -Ux OPENAI_API_KEY "$OPENAI_API_KEY"
```

Optional API URL/model envs for `aicommit`:

```bash
set -Ux OPENAI_BASE_URL "https://api.llmgate.dev"
set -Ux OPENAI_MODEL "gpt-5.2-codex-mini"
```

Optional auth for CLI tools not copied with secrets:

```bash
gh auth login
npm login
```

## 7) Validate installation

```bash
fish --version
brew --version
zoxide --version
starship --version
go version
bun --version
jq --version
opencode --version
gh --version
aicommit --help >/dev/null && echo "aicommit ok"
```

Also confirm Fish PATH contains these entries:

- `/home/linuxbrew/.linuxbrew/bin`
- `$HOME/.bun/bin`
- `$HOME/.go/bin`
- `/usr/local/bun`

## 8) Install `aicommit` script from this repo

If you use the `commit='aicommit -ayp'` alias, install the script from `bin/aicommit`:

```bash
sudo mkdir -p /usr/local/bun
sudo cp bin/aicommit /usr/local/bun/aicommit
sudo chmod +x /usr/local/bun/aicommit
```

Make sure `/usr/local/bun` is in your `PATH`:

```fish
fish_add_path /usr/local/bun
```

Verify:

```bash
command -v aicommit
```

## 9) Optional command tools referenced by aliases

Your fish aliases also reference these commands:

- `code-insiders`
- `copilot`
- `claude`
- `aicommit`

Install them separately if you use those aliases.
