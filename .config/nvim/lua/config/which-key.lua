local wk = require("which-key")
local shared = require("shared")

local M = {}

function M.setup()
    vim.opt.timeoutlen = 400
    wk.setup({
        plugins = {
            spelling = {
                enabled = true,
                suggestions = 40,
            },
        },
        icons = {
            breadcrumb = "»",
            separator = "➜",
            group = "+",
            rules = false,
        },
        window = {
            border = shared.window.border,
            position = "bottom",
            margin = { 2, 2, 2, 4 },
            padding = { 0, 0, 0, 0 },
            winblend = 0,
        },
        hidden = {
            "<silent>",
            "<cmd>",
            "<Cmd>",
            "<plug>",
            "<Plug>",
            "<CR>",
            "call",
            "lua",
            "^:",
            "^ ",
        },
        triggers_blacklist = {
            n = { "v", "<a-j>", "<a-s-j>", "<a-k>" },
            v = { "v", "<a-j>", "<a-s-j>", "<a-k>" },
        },
    })

    wk.add({
        { "<leader>e", group = "Toggle (enable)" },
        { "<leader>k", ":WhichKey<cr>", desc = "Which key?" },
    })
end

return M
