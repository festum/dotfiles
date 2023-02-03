---@type MappingsConfig
-- check core.mappings for table structure
-- https://github.com/NvChad/NvChad/blob/main/lua/core/mappings.luaZZ

local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
	},
}

-- more keybinds!

return M
