local overrides = require "custom.plugins.overrides"

---@type {[PluginName]: NvPluginConfig|false}


local plugins = {


    -- Override plugin definition options

    ["neovim/nvim-lspconfig"] = {
        config = function()
          require "plugins.configs.lspconfig"
          require "custom.plugins.lspconfig"
        end,
    },


    -- overrde plugin configs

    ["nvim-treesitter/nvim-treesitter"] = {
        override_options = overrides.treesitter,
    },
    ["williamboman/mason.nvim"] = {
        override_options = overrides.mason,
    },
    ["nvim-tree/nvim-tree.lua"] = {
        override_options = overrides.nvimtree,
    },

    -- Install plugins

    ["max397574/better-escape.nvim"] = {
        event = "InsertEnter",
        config = function()
          require("better_escape").setup()
        end,
    },
    ['glepnir/dashboard-nvim'] = {
        event = 'VimEnter',
        config = function()
          require('dashboard').setup {
              -- config
          }
        end,
        requires = { 'nvim-tree/nvim-web-devicons' }
    },

    -- code formatting, linting etc

    ["jose-elias-alvarez/null-ls.nvim"] = {
        after = "nvim-lspconfig",
        config = function()
          require "custom.plugins.null-ls"
        end,
    },

    -- Remove plugin
    -- ["hrsh7th/cmp-path"] = false,

    ["windwp/nvim-ts-autotag"] = {
        ft = { "html", "javascriptreact" },
        after = "nvim-treesitter",
        config = function()
          require("nvim-ts-autotag").setup()
        end,
    },
    ["nvim-telescope/telescope-media-files.nvim"] = {
        after = "telescope.nvim",
        config = function()
          require("telescope").load_extension "media_files"
        end,
    },
    ["Pocco81/TrueZen.nvim"] = {
        cmd = {
            "TZAtaraxis",
            "TZMinimalist",
            "TZFocus",
        },
        config = function()
          require "custom.plugins.truezen"
        end,
    },
}

return plugins
