local function term_nav(dir)
    ---@param self snacks.terminal
    return function(self)
        return self:is_floating() and '<c-' .. dir .. '>'
            or vim.schedule(function()
                vim.cmd.wincmd(dir)
            end)
    end
end

return {
    'asiryk/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        styles = {
            input = { row = 0.4 },
        },

        -- bigfile = {},
        ---@class snacks.dashboard.Config
        ---@field enabled? boolean
        ---@field sections snacks.dashboard.Section
        ---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
        dashboard = {
            width = 60,
            row = nil, -- dashboard position. nil for center
            col = nil, -- dashboard position. nil for center
            pane_gap = 4, -- empty columns between vertical panes
            autokeys = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', -- autokey sequence
            -- These settings are used by some built-in sections
            preset = {
                -- Used by the `keys` section to show keymaps.
                -- Set your custom keymaps here.
                -- When using a function, the `items` argument are the default keymaps.
                ---@type snacks.dashboard.Item[]
                keys = {
                    {
                        icon = ' ',
                        key = 'f',
                        desc = 'Find File',
                        action = ":lua Snacks.dashboard.pick('files')",
                    },
                    { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
                    {
                        icon = ' ',
                        key = 'g',
                        desc = 'Find Text',
                        action = ":lua Snacks.dashboard.pick('live_grep')",
                    },
                    {
                        icon = ' ',
                        key = 'r',
                        desc = 'Recent Files',
                        action = ":lua Snacks.dashboard.pick('oldfiles')",
                    },
                    {
                        icon = ' ',
                        key = 'c',
                        desc = 'Config',
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                    },
                    { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
                    {
                        icon = '󰒲 ',
                        key = 'L',
                        desc = 'Lazy',
                        action = ':Lazy',
                        enabled = package.loaded.lazy ~= nil,
                    },
                    { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
                },
                -- Used by the `header` section
                header = (function()
                    return os.time() % 2 == 0
                            and [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]
                        or [[
                                                                     
       ████ ██████           █████  ██ ██                     
      ███████████             █████ ███                          
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ ]]
                end)(),
                --                                                                        ]],
            },
            -- item field formatters
            formats = {
                icon = function(item)
                    if item.file and item.icon == 'file' or item.icon == 'directory' then
                        return Snacks.dashboard.icon(item.file, item.icon)
                    end
                    return { item.icon, width = 2, hl = 'icon' }
                end,
                footer = { '%s', align = 'center' },
                header = { '%s', align = 'center', hl = '@function.call' },
                file = function(item, ctx)
                    local fname = vim.fn.fnamemodify(item.file, ':~')
                    fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                    if #fname > ctx.width then
                        local dir = vim.fn.fnamemodify(fname, ':h')
                        local file = vim.fn.fnamemodify(fname, ':t')
                        if dir and file then
                            file = file:sub(-(ctx.width - #dir - 2))
                            fname = dir .. '/…' .. file
                        end
                    end
                    local dir, file = fname:match('^(.*)/(.+)$')
                    return dir and { { dir .. '/', hl = 'dir' }, { file, hl = 'file' } } or { { fname, hl = 'file' } }
                end,
            },
            sections = {
                { section = 'header' },
                function()
                    local function get_natural_day(day)
                        local suffix = 'th'
                        local day_mod = day % 10

                        if day_mod == 1 and day ~= 11 then
                            suffix = 'st'
                        elseif day_mod == 2 and day ~= 12 then
                            suffix = 'nd'
                        elseif day_mod == 3 and day ~= 13 then
                            suffix = 'rd'
                        end

                        return tostring(day) .. suffix
                    end

                    local date = os.date(' 📅 %A, %B ') .. get_natural_day(tonumber(os.date('%d')))
                    local v = vim.version()
                    local version = '  v' .. v.major .. '.' .. v.minor .. '.' .. v.patch
                    return {
                        align = 'center',
                        text = {
                            { date, hl = '@boolean' },
                            { version, hl = 'DevIconQt' },
                        },
                        padding = 1,
                    }
                end,
                { section = 'keys', gap = 1, padding = 1 },
                { section = 'startup' },
                function()
                    local fortune = table.concat(require('fortune')(), '\n'):sub(2)
                    return { title = { fortune, hl = 'CursorLineNr' }, padding = 0 }
                end,
            },
        },
        gitbrowse = {},
        image = {
            math = { enabled = false },
        },
        input = {},
        picker = {
            actions = {
                -- NOTE(kyren): fixes oil buffers not getting replaced
                smart_open = function(picker, item)
                    if not item then
                        return
                    end

                    local target_win = picker.main
                    local alt_win = vim.fn.win_getid(vim.fn.winnr('#'))

                    if vim.api.nvim_win_is_valid(alt_win) then
                        local alt_buf = vim.api.nvim_win_get_buf(alt_win)
                        local alt_ft = vim.bo[alt_buf].filetype
                        if alt_ft == 'oil' or alt_ft == 'build_terminal' then
                            target_win = alt_win
                        end
                    end

                    local target_buf = vim.api.nvim_win_get_buf(target_win)
                    local ft = vim.bo[target_buf].filetype

                    if (ft == 'oil' or ft == 'build_terminal') and item.file then
                        picker:close()
                        -- CRITICAL: Force execution AFTER the picker finishes tearing down its UI
                        vim.schedule(function()
                            if vim.api.nvim_win_is_valid(target_win) then
                                vim.api.nvim_set_current_win(target_win)
                                vim.cmd('edit ' .. vim.fn.fnameescape(item.file))
                            end
                        end)
                        return
                    end

                    -- Fallback to standard confirm behavior for everything else
                    return picker:action('confirm')
                end,
                -- NOTE(kyren): end
            },
            win = {
                -- NOTE(kyren): fixes oil buffers not getting replaced
                input = {
                    keys = {
                        ['<CR>'] = { 'smart_open', mode = { 'n', 'i' } },
                    },
                },
                list = {
                    keys = {
                        ['<CR>'] = 'smart_open',
                    },
                },
                -- NOTE(kyren): end
            },
        },
        quickfile = {},
        terminal = {
            win = {
                keys = {
                    nav_h = { '<C-h>', term_nav('h'), desc = 'Go to Left Window', expr = true, mode = 't' },
                    nav_j = { '<C-j>', term_nav('j'), desc = 'Go to Lower Window', expr = true, mode = 't' },
                    nav_k = { '<C-k>', term_nav('k'), desc = 'Go to Upper Window', expr = true, mode = 't' },
                    nav_l = { '<C-l>', term_nav('l'), desc = 'Go to Right Window', expr = true, mode = 't' },
                },
            },
        },
    },
    keys = {
        {
            '<leader>go',
            function()
                Snacks.gitbrowse.open()
            end,
            desc = '[G]it [O]pen',
        },
        {
            '<leader>gc',
            function()
                Snacks.gitbrowse.open({
                    open = function(url)
                        vim.fn.setreg('+', url)
                    end,
                })
            end,
            desc = '[G]it [C]opy',
        },

        {
            '<leader>ri',
            function()
                Snacks.image.hover()
            end,
            desc = '[R]ender [I]mage',
        },

        {
            '<leader>nd',
            function()
                Snacks.notifier.hide()
            end,
            desc = '[N]otification [D]ismiss All',
        },
        {
            '<leader>nh',
            function()
                Snacks.picker.notifications({ layout = 'dropdown' })
            end,
            desc = '[N]otification [H]istory',
        },

        {
            '<leader>sp',
            function()
                Snacks.picker.pickers({ layout = 'telescope' })
            end,
            desc = '[S]how [P]ickers',
        },
        {
            '<leader>fa',
            function()
                Snacks.picker.files({
                    layout = 'telescope',
                    hidden = true,
                    ignored = true,
                    follow = true,
                })
            end,
            desc = '[F]ind [A]ll',
        },
        {
            '<leader>fs',
            function()
                Snacks.picker.files({
                    layout = 'telescope',
                    hidden = true,
                    follow = true,
                })
            end,
            desc = '[F]ile [S]ystem',
        },
        {
            '<leader>lv',
            function()
                Snacks.picker.grep({
                    layout = 'telescope',
                    hidden = true,
                    follow = true,
                })
            end,
            desc = '[L]ive [G]rep',
        },
        {
            'gi',
            function()
                Snacks.picker.lsp_implementations()
            end,
            { desc = '[G]oto [I]mplementations' },
        },
        {
            'gt',
            function()
                Snacks.picker.lsp_type_definitions()
            end,
            { desc = '[G]oto [T]ype Definitions' },
        },
        {
            '<leader>ds',
            function()
                Snacks.picker.lsp_symbols({ layout = 'telescope' })
            end,
            desc = '[D]ocument [S]ymbols',
        },
        {
            '<leader>ps',
            function()
                Snacks.picker.lsp_workspace_symbols({ layout = 'telescope' })
            end,
            desc = '[P]roject [S]ymbols',
        },
        {
            '<leader>di',
            function()
                Snacks.picker.diagnostics({ layout = 'telescope' })
            end,
            desc = '[Di]agnostics',
        },
        {
            '<leader>dl',
            function()
                Snacks.picker.diagnostics_buffer({ layout = 'telescope' })
            end,
            desc = '[D]iagnostics [L]ocal',
        },
        {
            '<leader>fh',
            function()
                Snacks.picker.help({ layout = 'telescope' })
            end,
            desc = '[F]ind [H]elp',
        },
        {
            '<leader>H',
            function()
                Snacks.picker.highlights({
                    layout = 'telescope',
                    hidden = true,
                    follow = true,
                })
            end,
            desc = '[H]light Groups',
        },
        {
            '<leader>si',
            function()
                Snacks.picker.icons({ layout = 'select' })
            end,
            desc = '[S]earch [I]cons',
        },
        {
            '<leader>sk',
            function()
                Snacks.picker.keymaps({ layout = 'dropdown' })
            end,
            desc = '[S]earch [K]eymaps',
        },
        {
            '<leader>bl',
            function()
                Snacks.picker.buffers({ layout = 'dropdown' })
            end,
            desc = '[B]uffers [L]ist',
        },
        {
            '<leader>th',
            function()
                Snacks.picker.colorschemes({ layout = 'dropdown' })
            end,
            desc = '[T]hemes [P]icker',
        },

        {
            '<leader>rn',
            function()
                Snacks.rename.rename_file()
            end,
            desc = '[R]e[n]ame',
        },
        {
            '<C-t>',
            function()
                Snacks.terminal(nil, { win = { style = 'minimal' } })
            end,
            desc = 'Toggle [T]erminal',
        },
    },
}
