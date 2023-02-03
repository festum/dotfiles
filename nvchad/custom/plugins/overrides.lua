-- overriding default plugin configs!
local M = {}

M.treesitter = {
   ensure_installed = {
      "bash",
      "c",
      "css",
      "go",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "toml",
      "vim",
      "yaml",
   },
}

M.nvimtree = {
   git = {
      enable = true,
   },
   update_cwd = true,
   update_focused_file = {
      enable = true,
      update_cwd = true,
   },
   renderer = {
      highlight_git = true,
      icons = {
         show = {
            git = true,
         },
      },
   },
}

M.telescope = {
   extensions = {
      -- fd is needed
      media_files = {
         filetypes = { "png", "webp", "jpg", "jpeg", "svg" },
      },
   },
}

M.statusline = {
   separator_style = "round", -- default/round/slant/block/arrow
}

M.mason = {
   ensure_installed = {
      -- lua stuff
      "lua-language-server",
      "stylua",

      -- web dev stuff
      "css-lsp",
      "html-lsp",
      "typescript-language-server",
      "deno",
   },
}


return M
-- Do :PackerSync after change
