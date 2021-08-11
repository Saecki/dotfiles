-- modes
local modemap = {
    ['n']    = 'N ',
    ['no']   = 'O ',
    ['nov']  = 'O ',
    ['noV']  = 'O ',
    ['no'] = 'O ',
    ['niI']  = 'N ',
    ['niR']  = 'N ',
    ['niV']  = 'N ',
    ['v']    = 'V ',
    ['V']    = 'VL',
    ['']   = 'VB',
    ['s']    = 'S ',
    ['S']    = 'SL',
    ['']   = 'SB',
    ['i']    = 'I ',
    ['ic']   = 'I ',
    ['ix']   = 'I ',
    ['R']    = 'R ',
    ['Rc']   = 'R ',
    ['Rv']   = 'VR',
    ['Rx']   = 'R ',
    ['c']    = 'C ',
    ['cv']   = 'EX',
    ['ce']   = 'EX',
    ['r']    = 'R ',
    ['rm']   = 'MORE',
    ['r?']   = 'CONFIRM',
    ['!']    = 'SHELL',
    ['t']    = 'TERMINAL',
}
local function get_mode()
    local mode_code = vim.api.nvim_get_mode().mode
    if modemap[mode_code] == nil then return mode_code end
    return modemap[mode_code]
end

-- position
local function get_pos()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local linecount = vim.api.nvim_buf_line_count(0)
    local digits = math.floor(math.log10(linecount)) + 1
    local template = "%" .. digits .. "d:%-3d"
    return string.format(template, cursor[1], cursor[2])
end

-- setup
local function setup()
    local theme = require('colors.mineauto').lualine

    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = theme,
            section_separators = { '', '' },
            component_separators = { '', '' },
        },
        sections = {
            lualine_a = { get_mode },
            lualine_b = { require('lsp-status').status },
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = { 'encoding', 'filetype' },
            lualine_y = { 'branch', 'diff' },
            lualine_z = {
                get_pos,
                { 
                    'diagnostics',
                    sources = { 'nvim_lsp' },
                          sections = { 'error', 'warn', 'info', 'hint' },
                          --color_error = nil, TODO
                          --color_warn  = nil, TODO
                          --color_info  = nil, TODO
                          --color_hint  = nil, TODO
                    symbols = { error = ' ', warn = ' ', info = 'I', hint = 'H' }
                } 
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        extensions = {}
    }
end

return {
    setup = setup,
}
