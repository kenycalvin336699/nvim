return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" }, -- snippet collection
  version = "1.*", -- use pre-built releases, avoids needing a rust toolchain
  opts = {
    keymap = { preset = "default" },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      documentation = { auto_show = true }, -- show docs popup for the selected item
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
}
