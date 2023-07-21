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
  },
}

return M
