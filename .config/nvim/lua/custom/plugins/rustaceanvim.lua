return {
    'mrcjkb/rustaceanvim',
    version = '^4',
    lazy = false, -- already lazy
    init = function ()
        require("custom.config.rustaceanvim")
    end
}
