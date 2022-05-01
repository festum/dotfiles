local g = vim.g

g.mapleader = ","


local M = {}

local plugin_conf = require "custom.plugins.configs"
local userPlugins = require "custom.plugins"

M.plugins = {

   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.lspconfig",
      },
   },

   override = {
      ["kyazdani42/nvim-tree.lua"] = plugin_conf.nvimtree,
      ["nvim-treesitter/nvim-treesitter"] = plugin_conf.treesitter,
      ["nvim-telescope/telescope.nvim"] = plugin_conf.telescope,
   },

   user = userPlugins,
   user = {
      ["goolord/alpha-nvim"] = {
         disable = false,
      },
   },
}

M.ui = {
   theme = "tokyonight",
   transparency = false,
}

return M
