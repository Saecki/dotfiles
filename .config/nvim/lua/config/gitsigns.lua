local gitsigns = require("gitsigns")
local gitsigns_actions = require("gitsigns.actions")
local wk = require("which-key")
local shared = require("shared")

local M = {}

-- Slightly modified version of default function
local function current_line_blame_formatter(name, blame_info, opts)
    if blame_info.author == name then
        blame_info.author = "You"
    end

    local text
    if blame_info.author == "Not Committed Yet" then
        text = blame_info.author
    else
        local date_time

        if opts.relative_time then
            date_time = require("gitsigns.util").get_relative_time(tonumber(blame_info["author_time"]))
        else
            date_time = os.date("%Y-%m-%d", tonumber(blame_info["author_time"]))
        end

        text = string.format("// %s, %s - %s", blame_info.author, date_time, blame_info.summary)
    end

    return { { text, "Comment" } }
end

function M.setup()
    ---@format disable-next
	gitsigns.setup({
		signs = {
			add          = { hl = "GitSignsAdd",    text = "▌", numhl = "GitSignsAddNr",    linehl = "GitSignsAddLn"    },
			change       = { hl = "GitSignsChange", text = "▌", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
			delete       = { hl = "GitSignsDelete", text = "▌", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
			topdelete    = { hl = "GitSignsDelete", text = "▌", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
			changedelete = { hl = "GitSignsChgDel", text = "▌", numhl = "GitSignsChgDelNr", linehl = "GitSignsChgDelLn" },
		},
        numhl = false,
		linehl = false,
		word_diff = false,
		current_line_blame = false,
		current_line_blame_formatter = current_line_blame_formatter,
		current_line_blame_formatter_opts = {
			relative_time = true,
		},
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 0,
		},
		sign_priority = 100,
		update_debounce = 100,
		diff_opts = {
			internal = true,
		},
		base = "HEAD",
		preview_config = {
			border = shared.window.border,
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	})
    wk.register({
        ["[g"] = { gitsigns_actions.prev_hunk, "Previous hunk" },
        ["]g"] = { gitsigns_actions.next_hunk, "Next hunk" },
        ["<leader>g"] = {
            name = "Git",
            ["u"] = { gitsigns.reset_hunk, "Undo hunk" },
            ["s"] = { gitsigns.preview_hunk, "Show hunk" },
            ["b"] = { gitsigns.toggle_current_line_blame, "Toggle inline blame" },
            ["B"] = { gitsigns.blame_line, "Blame line" },
            ["r"] = { gitsigns.refresh, "Refresh" },
        },
    })
end

return M
