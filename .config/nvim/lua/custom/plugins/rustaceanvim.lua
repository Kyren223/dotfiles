return {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false, -- already lazy
    init = function ()
        require("custom.config.rustaceanvim")
    end
}
