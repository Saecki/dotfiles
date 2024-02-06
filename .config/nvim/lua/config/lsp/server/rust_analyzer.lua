local M = {}

local shared = require("shared")
local wk = require("which-key")

local KIND = {
    OTHER = 1,
    PARAM_HINTS = 2,
}

local namespace = vim.api.nvim_create_namespace("config.lsp.server.rust_analyzer")

local use_clippy = false
local function toggle_check_command()
    use_clippy = not use_clippy
    M.setup(M.server, M.on_attach, M.capabilities, { use_clippy = use_clippy })
    if use_clippy then
        vim.notify("cargo clippy", vim.log.levels.INFO)
    else
        vim.notify("cargo check", vim.log.levels.INFO)
    end
end

local function inlay_hints_handler(err, result, ctx)
    if err then
        return
    end
    if not shared.lsp.enable_inlay_hints then
        return
    end

    M.clear_inlay_hints(ctx.bufnr)

    local prefix = " "
    local highlight = "NonText"
    local hints = {}
    for _, item in ipairs(result) do
        if item.kind == KIND.OTHER then
            local line = tonumber(item.position.line)
            hints[line] = hints[line] or {}

            local text = ""
            if type(item.label) == "table" then
                local labels = vim.tbl_map(function(i)
                    return i.value
                end, item.label)
                text = table.concat(labels)
            else -- string
                text = item.label
            end
            local text = text:gsub(": ", "")
            table.insert(hints[line], prefix .. text)
        end
    end

    for l, t in pairs(hints) do
        local text = table.concat(t, " ")
        vim.api.nvim_buf_set_extmark(ctx.bufnr, namespace, l, 0, {
            virt_text = { { text, highlight } },
            virt_text_pos = "eol",
            hl_mode = "combine",
        })
    end
end

function M.inlay_hints()
    if not shared.lsp.enable_inlay_hints then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local line_count = vim.api.nvim_buf_line_count(bufnr) - 1
    local last_line = vim.api.nvim_buf_get_lines(bufnr, line_count, line_count + 1, true)

    local params = {
        textDocument = vim.lsp.util.make_text_document_params(bufnr),
        range = {
            start = {
                line = 0,
                character = 0,
            },
            ["end"] = {
                line = line_count,
                character = #last_line[1],
            },
        },
    }

    vim.lsp.buf_request(0, "textDocument/inlayHint", params, inlay_hints_handler)
end

function M.clear_inlay_hints(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr or 0, namespace, 0, -1)
end

local function wrap_on_attach(client, buf)
    M.on_attach(client, buf)

    local group = vim.api.nvim_create_augroup("LspInlayHints", {})
    vim.api.nvim_create_autocmd(
        { "TextChanged", "TextChangedI", "TextChangedP", "BufEnter", "BufWritePost" },
        {
            group = group,
            buffer = buf,
            callback = M.inlay_hints,
        }
    )

    M.inlay_hints()

    wk.register({
        ["<leader>i"] = {
            name = "Lsp",
            ["c"] = { toggle_check_command, "Rust check command" },
        },
    }, {
        buffer = buf,
    })
end


function M.setup(server, on_attach, capabilities, opts)
    M.server = server
    M.on_attach = on_attach
    M.capabilities = capabilities

    opts = opts or {}

    server.setup({
        on_attach = wrap_on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = opts.use_clippy and "clippy" or "check",
                },
                assist = {
                    importEnforceGranularity = true,
                    importGranularity = "module",
                    importPrefix = "crate",
                },
                inlayHints = {
                    maxLength = 40,
                },
            },
        },
        handlers = {
            -- hook into the progress handler so we can show inlay hints
            -- when the language server has started up.
            ["$/progress"] = function(err, result, ctx, config)
                local progress_handler = vim.lsp.handlers["$/progress"]
                if progress_handler then
                    progress_handler(err, result, ctx, config)
                end

                local indexing = result.token == "rustAnalyzer/Indexing"
                local finished = result.value.kind == "end"
                if result.value and indexing and finished then
                    M.inlay_hints()
                end
            end,
        },
    })
end

return M
