local M = {}

local wk = require("which-key")

local use_clippy = false

local function setup_server(server, on_attach, capabilities, opts)
    opts = opts or {}
    local check_command = opts.check_command or CARGO_CHECK
    server.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = check_command,
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
    })
end

local function toggle_check_command()
    local cmd = use_clippy and "clippy" or "check"
    setup_server(M.server, M.on_attach, M.capabilities, { check_command = cmd })
    vim.notify("cargo " .. cmd, vim.log.levels.INFO)
end

function M.setup(server, on_attach, capabilities, opts)
    M.server = server
    M.on_attach = on_attach
    M.capabilities = capabilities

    setup_server(server, on_attach, capabilities)

    local group = vim.api.nvim_create_augroup("config.lsp.server.rust-analyzer", {})
    vim.api.nvim_create_autocmd("BufRead", {
        group = group,
        pattern = "*.rs",
        callback = function(ev)
            wk.register({
                ["<leader>i"] = {
                    name = "Lsp",
                    ["c"] = { toggle_check_command, "Rust check command" },
                },
            }, {
                buffer = ev.buf,
            })
        end
    })
end

return M
