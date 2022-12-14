local M = {}

local wk = require("which-key")

local function toggle_diff()
    if vim.o.diff then
        vim.cmd("diffoff")
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_name(bufnr):match("fugitive://.*") then
                vim.api.nvim_buf_delete(bufnr, { force = true })
            end
        end
    else
        vim.cmd("Gvdiffsplit!")
    end
end

function M.setup()
    wk.register({
        ["<leader>g"] = {
            name = "Git",
            ["d"] = { toggle_diff, "Toggle 3 way diff" },
            ["h"] = { ":diffget //2<cr>", "Get left diff" },
            ["l"] = { ":diffget //3<cr>", "Get right diff" },
        },
    })
end

return M
