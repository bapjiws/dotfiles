local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  return
end

mason.setup()

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

local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
  return
end

mason_lspconfig.setup {
  ensure_installed = servers,
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then 
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  if server == "lua_ls" then
    local lua_opts = require "user.lsp.settings.lua_ls"
    opts = vim.tbl_deep_extend("force", lua_opts, opts)
  end

	if server.name == "jsonls" then
    local jsonls_opts = require("user.lsp.settings.jsonls")
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

  lspconfig[server].setup(opts)
end 
