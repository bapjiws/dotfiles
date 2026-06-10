return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim", "Snacks" },
      },
      workspace = {
        library = vim.list_extend(
          vim.api.nvim_get_runtime_file("", true),
          { vim.fn.stdpath("config") .. "/lua" }
        ),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
