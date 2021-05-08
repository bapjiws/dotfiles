require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "bash",
        "json",
        "yaml",
        "regex",
        "lua",
        "graphql"
    },
    highlight = {
        enable = true,
        use_languagetree = true
    },
    indent = {
        enable = true
    }
}
