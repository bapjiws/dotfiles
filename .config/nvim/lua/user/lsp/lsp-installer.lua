local mason_ok, mason = pcall(require, "mason")
if not mason_ok then return end
mason.setup()

local mlsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mlsp_ok then return end

local servers = {
  "bashls",
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "eslint",
  "html",
  "jsonls",
  "lua_ls",
  "ts_ls",
  "vimls",
  "yamlls",
}

mason_lspconfig.setup({
  ensure_installed = servers,
  handlers = {
    function(server_name)
      local opts = {
        on_attach    = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
      }

      if server_name == "lua_ls" then
        opts = vim.tbl_deep_extend("force", require("user.lsp.settings.lua_ls"), opts)
      end
      if server_name == "jsonls" then
        opts = vim.tbl_deep_extend("force", require("user.lsp.settings.jsonls"), opts)
      end
      if server_name == "yamlls" then
        opts = vim.tbl_deep_extend("force", require("user.lsp.settings.yamlls"), opts)
      end

      require("lspconfig")[server_name].setup(opts)
    end,
  },
})
