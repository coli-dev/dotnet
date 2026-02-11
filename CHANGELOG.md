## [Unreleased]

### Added
- Added `TUTORIAL_FISH_OPENCODE_SETUP.md` with step-by-step instructions to install Fish via APT, install Homebrew, install required Brew packages, and apply Fish/OpenCode config.

### Changed
- Copied `.config/fish` and `.config/opencode` into this repository as requested.
- Sanitized sensitive values in copied config files and replaced them with environment-based placeholders.
- Removed runtime/metadata directories from copied OpenCode config (`.git`, `node_modules`, `opencode-mem`).
- Updated tutorial to include installing `bin/aicommit` into `/usr/local/bun` and setting execute permission.
- Updated tutorial with an interactive prompt script to ask users for env values and replace placeholders in copied config files.
- Updated tutorial to install OpenCode via `brew install anomalyco/tap/opencode`.
- Updated tutorial to install Bun explicitly via `brew install oven-sh/bun/bun`.
- Updated setup guide with WSL2 hostname configuration (`/etc/wsl.conf`, `/etc/hostname`, `/etc/hosts`) and restart/verification steps.
- Updated setup guide to include Git identity setup and explicit Fish PATH setup for `/usr/local/bun` after installing `aicommit`.
