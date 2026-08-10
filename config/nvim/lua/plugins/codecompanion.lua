return {
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- Default adapter is GitHub Copilot (uses copilot.lua auth).
      interactions = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
        cmd = { adapter = "copilot" },
      },
    },
    keys = {
      {
        "<C-a>",
        "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" },
        desc = "CodeCompanion Actions",
      },
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" },
        desc = "CodeCompanion Chat",
      },
      {
        "ga",
        "<cmd>CodeCompanionChat Add<cr>",
        mode = "v",
        desc = "CodeCompanion Add Selection",
      },
    },
  },
}
