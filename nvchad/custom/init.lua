-- This file runs after main init.lua file

local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
-- 	pattern = "*",
-- 	command = "tabdo wincmd =",
-- })
