local g = vim.g

g.mapleader = ","

-- This file overrides default_config
-- Refer https://github.com/NvChad/example_config/blob/main/chadrc.lua
-- Install LSP by yourself
-- :MasonInstall bash-language-server black clangd cmake-language-server cmakelang commitlint cpplint css-lsp fourmolu gitlint go-debug-adapter goimports-reviser golangci-lint-langserver gopls gradle-language-server grammarly-languageserver jdtls jedi-language-server jq json-lsp json-to-struct jsonlint kotlin-debug-adapter kotlin-language-server ktlint lemminx lua-language-server markdownlint nginx-language-server prettier sql-formatter sqls terraform-ls tflint twigcs typescript-language-server vim-language-server yamllint zk zls

local M = {}

local pluginConf = require "custom.plugins.configs"

M.plugins = {
  options = {
    lspconfig = {
      setup_lspconf = "custom.plugins.lspconfig",
    },
  },
  override = {
    ["kyazdani42/nvim-tree.lua"] = pluginConf.nvimtree,
    ["nvim-treesitter/nvim-treesitter"] = pluginConf.treesitter,
    ["nvim-telescope/telescope.nvim"] = pluginConf.telescope,
  },
  ["goolord/alpha-nvim"] = { disable = false },
  ["nvim-telescope/telescope.nvim"] = { file_ignore_patterns = { "node_modules", ".git" } },

  install = require "custom.plugins",
}
M.ui = {
  theme_toggle = { "tokyonight", "one_light" },
  theme = "tokyonight",
  transparency = false,
}
M.mappings = require "custom.mappings"

return M


