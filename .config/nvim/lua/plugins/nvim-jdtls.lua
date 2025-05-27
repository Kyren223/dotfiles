return {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    opts = {
        cmd = { 'jdtls' },
        root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw', 'pom.xml' }, { upward = true })[1]),
    },
    config = function(_, opts)
        require('jdtls').start_or_attach(opts)
    end,
}
