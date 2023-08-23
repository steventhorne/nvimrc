# Prerequisites
In order to use this repository, you will need to install and run [Neovim](https://neovim.io/) at least once.

Telescope-fzf-native relies on [cmake](https://cmake.org/) to be installed.

Icons used in this configuration rely on [nerd fonts](https://www.nerdfonts.com/).

# Installation
Clone or extract the files into the nvim folder in your `'runtimepath'` (for most users, this will mean `~/.config/nvim` on *nix systems and `%localappdata%/nvim` on Windows).
If you have cloned/extracted the files correctly, you will now have this readme file directly inside of your nvim folder.

Once the files are in your `'runtimepath'`, simply restart Neovim and these dotfiles will take care of installing packages.

# External Tools
These Neovim dotfiles make optional use of external tools for things like language servers, debuggers, linters, and formatters.

If you want support for any of the following languages, you will need to install their related packages via [Mason](https://github.com/williamboman/mason.nvim).
Simply type `:Mason` to open the Mason UI and search for the package you want to install.

These dotfiles currently support the following languages and their listed packages:

TypeScript
- eslint-lsp
- node-debug2-adapter
- prettier
- typescript-language-server

HTML
- html-lsp
- prettier

CSS
- css-lsp
- prettier

Lua
- lua-language-server
- stylua

Csharp
- netcoredbg
- omnisharp

Angular
- angular-language-server

Astro
- astro-language-server

Svelte
- svelte-language-server

Note: you may need to restart Neovim after installing these packages.
