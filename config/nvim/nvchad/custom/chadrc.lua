---@type ChadrcConfig
-- !NeoVim level settiongs
local g = vim.g
g.mapleader = ","

-- !NvChad
local highlights = require "custom.highlights"
local M = {
  plugins = "custom.plugins",
  -- check core.mappings for table structure
  mappings = require "custom.mappings",
  ui = {
    theme = "pastelbeans",
    theme_toggle = { "pastelbeans", "blossom_light" },
    hl_override = highlights.override,
    hl_add = highlights.add,
    nvdash = {
      load_on_startup = true,
      header = {
        "   ╔═╗┌─┐┌─┐┌┬┐┬ ┬┌┬┐   ",
        "   ╠╣ ├┤ └─┐ │ │ ││││   ",
        "   ╚  └─┘└─┘ ┴ └─┘┴ ┴   ",
        "   ╔╗╔┌─┐┌─┐ ╦  ╦┬┌┬┐   ",
        "   ║║║├┤ │ │ ╚╗╔╝││││   ",
        "   ╝╚╝└─┘└─┘  ╚╝ ┴┴ ┴   ",
      },
    },
    statusline = {
      theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
      separator_style = "block", -- default/round/block/arrow (separators work only for "default" statusline theme; round and block will work for the minimal theme only)
      overriden_modules = nil,
    },
    tabufline = {
      lazyload = true,
      overriden_modules = nil,
    },
  },
}

return M
