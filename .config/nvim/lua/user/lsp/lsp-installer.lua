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
  "denols",
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

  if server == "jsonls" then
    local jsonls_opts = require("user.lsp.settings.jsonls")
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
  end

  if server == "denols" then
    opts = vim.tbl_deep_extend("force", {
      root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    }, opts)
  end

  if server == "ts_ls" then
    opts = vim.tbl_deep_extend("force", {
      root_dir = function(filename)
        local denoRootDir = lspconfig.util.root_pattern("deno.json", "deno.json")(filename);
        if denoRootDir then
          print('This seems to be a Deno project; returning nil so that tsserver does not attach');
          return nil;
        else
          print('This seems to be a TS project; return root dir based on package.json')
        end

        return lspconfig.util.root_pattern("package.json")(filename);
      end,
      single_file_support = false,
    }, opts)
  end

  lspconfig[server].setup(opts)
end
