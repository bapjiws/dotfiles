local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
  vim.diagnostic.config({
    virtual_text = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN]  = "",
        [vim.diagnostic.severity.HINT]  = "",
        [vim.diagnostic.severity.INFO]  = "",
      },
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  -- Show diagnostic float automatically after cursor is still
  vim.api.nvim_create_autocmd("CursorHold", {
    group = vim.api.nvim_create_augroup("UserDiagnosticFloat", { clear = true }),
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false })
    end,
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  -- Register LSP keymaps via LspAttach so they fire reliably for every server
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
    callback = function(ev)
      local bufnr = ev.buf
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true, buffer = bufnr }

      -- Disable LSP formatting for servers where conform takes over
      if client and (client.name == "ts_ls" or client.name == "lua_ls") then
        client.server_capabilities.documentFormattingProvider = false
      end

      map("n", "<leader>dcr", vim.lsp.buf.declaration,    vim.tbl_extend("force", opts, { desc = "Declaration" }))
      map("n", "<leader>imp", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Implementation" }))
      map("n", "<leader>dfn", vim.lsp.buf.definition,     vim.tbl_extend("force", opts, { desc = "Definition" }))
      map("n", "<leader>ref", vim.lsp.buf.references,     vim.tbl_extend("force", opts, { desc = "References" }))
      map("n", "<leader>hov", vim.lsp.buf.hover,          vim.tbl_extend("force", opts, { desc = "Hover" }))
      map("n", "<leader>sgn", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
      map("n", "<leader>cac", vim.lsp.buf.code_action,    vim.tbl_extend("force", opts, { desc = "Code action" }))
      map("n", "<leader>rnm", vim.lsp.buf.rename,         vim.tbl_extend("force", opts, { desc = "Rename" }))

      map("n", "<leader>dgn", vim.diagnostic.setloclist,  vim.tbl_extend("force", opts, { desc = "Diagnostics (loclist)" }))
      map("n", "<leader>dgl", vim.diagnostic.open_float,  vim.tbl_extend("force", opts, { desc = "Diagnostics (float)" }))
      map("n", "[d", function() vim.diagnostic.goto_prev({ float = true }) end, vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
      map("n", "]d", function() vim.diagnostic.goto_next({ float = true }) end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

      map("n", "<leader>fmt", function()
        require("conform").format({ lsp_fallback = true })
      end, vim.tbl_extend("force", opts, { desc = "Format" }))
    end,
  })
end

M.on_attach = function(client, bufnr)
  -- Kept for compatibility; keymaps are now handled via LspAttach autocmd in M.setup()
end

return M
