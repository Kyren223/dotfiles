return {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'Alpha',
    config = function()
        local alpha = require('alpha')
        local dashboard = require('alpha.themes.dashboard')

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

        local date = os.date('  %A, %B ') .. get_natural_day(tonumber(os.date('%d')))
        local plugins = '  ' .. require('lazy').stats().count .. ' plugins '
        local v = vim.version()
        local version = '  v' .. v.major .. '.' .. v.minor .. '.' .. v.patch
        local info_line = date .. plugins .. version

        -- WARN: Just hardcoded the length of the first line in the header
        local header_length = #'                                                                     '
        local padding = (header_length - #info_line) / 2
        info_line = string.rep(' ', padding) .. info_line

        dashboard.section.header.val = {
            [[                                                                     ]],
            [[       ████ ██████           █████  ██ ██                     ]],
            [[      ███████████             █████ ███                          ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
            info_line,
        }

        dashboard.section.buttons.opts.spacing = 0
        dashboard.section.buttons.val = {
            dashboard.button('q', '󰈆  > Quit NVIM', '<cmd>qa<cr>'),
        }

        dashboard.section.footer.val = require('alpha.fortune')()

        alpha.setup(dashboard.opts)
    end,
}
