# what is this

If you want to use [blindFS/topiary-nushell: topiary formatter for nushell](https://github.com/blindFS/topiary-nushell), you should do:

```
cargo install topiary
git clone https://github.com/blindFS/topiary-nushell ($env.XDG_CONFIG_HOME | path join topiary)
$env.TOPIARY_CONFIG_FILE = ($env.XDG_CONFIG_HOME | path join topiary languages.ncl)
$env.TOPIARY_LANGUAGE_DIR = ($env.XDG_CONFIG_HOME | path join topiary languages)
```

but organizing where `topiary-nushell` is lazy task for me, so it will do:

- Automatically clone `topiary-nushell` on setup and offers `:TopiaryNuUpdate` to update it.
- Automatically set envs for formatter.
- Offers `topiary` formatter via mason. (of course you can manually do `cargo install topiary` too)

# install

## lazy

```lua
{
  "zknx/topiary-nushell.nvim",
  dependencies = {
    "stevearc/conform.nvim",
  },
  ft = "nu",
  opts = {},
}
```

or

```lua
{
  "zknx/topiary-nushell.nvim",
  ft = "nu",
  opts = {
    add_formatter_to_conform = false,
  },
}
```

# configuration

## mason

```lua
  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:zknx/topiary-nushell.nvim",
      },
    },
  },
```

then `:MasonInstall topiary` should works

## lsp

```lua
vim.lsp.enable("nushell")
```
