-- overriding default plugin configs!
local M = {}

M.treesitter = {
   ensure_installed = {
      "vim",
      "markdown",
      "yaml",
      "json",
      "toml",
      "bash",
      "go",
      "c",
      "javascript",
      "lua",
      "html",
      "css",
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
}

M.telescope = {
   extensions = {
      -- fd is needed
      media_files = {
         filetypes = { "png", "webp", "jpg", "jpeg" },
      },
   },
}

M.statusline = {
   separator_style = "round", -- default/round/slant/block/arrow
}


return M
-- Do :PackerSync after change
