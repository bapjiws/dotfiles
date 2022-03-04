-- https://www.schemastore.org/json

local function read_json(file_path)
    local file = io.open(file_path, "r")
    local table = vim.fn.json_decode(file:read("a"))
    file.close()

    return table
end

local default_schemas = nil
local status_ok, nlspsettings = pcall(require, "nlspsettings")
if status_ok then
    local all_schemas = nlspsettings.get_default_schemas()
    for _, schema in ipairs(all_schemas) do
        if schema["fileMatch"][1] == "jsonls.json" then
            local file_path = schema["url"]
            default_schemas = read_json(file_path)
            break
        end
    end
end

-- local default_schemas = nil
-- local status_ok, jsonls_settings = pcall(require, "nlspsettings.jsonls")
-- if status_ok then
--   default_schemas = jsonls_settings.get_default_schemas()
-- end

local schemas = {
  {
    description = "Babel configuration",
    fileMatch = {
      ".babelrc.json",
      ".babelrc",
      "babel.config.json",
    },
    url = "https://json.schemastore.org/babelrc.json",
  },
  {
    description = "ESLint config",
    fileMatch = {
      ".eslintrc.json",
      ".eslintrc",
    },
    url = "https://json.schemastore.org/eslintrc.json",
  },
  {
    description = "NPM configuration file",
    fileMatch = {
      "package.json",
    },
    url = "https://json.schemastore.org/package.json",
  },
  {
    description = "Prettier config",
    fileMatch = {
      ".prettierrc",
      ".prettierrc.json",
      "prettier.config.json",
    },
    url = "https://json.schemastore.org/prettierrc",
  },
  {
    description = "TypeScript compiler configuration file",
    fileMatch = {
      "tsconfig.json",
      "tsconfig.*.json",
    },
    url = "https://json.schemastore.org/tsconfig.json",
  },
}

local function extend(tab1, tab2)
  for _, value in ipairs(tab2) do
    table.insert(tab1, value)
  end
  return tab1
end

local extended_schemas = extend(schemas, default_schemas)

local opts = {
  settings = {
    json = {
      schemas = extended_schemas,
    },
  },
  setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
        end,
      },
    },
  },
}

return opts
