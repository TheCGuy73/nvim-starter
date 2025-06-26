local M = {}

function M.get_configs()
  local sep = package.config:sub(1,1)
  local config_spec_path = table.concat({vim.fn.stdpath('config'), 'lua', 'user', 'core', 'custom', 'configs', 'spec'}, sep) .. sep
  local files = vim.fn.glob(config_spec_path .. '*.lua', false, true)
  local configs = {}
  for _, file in ipairs(files) do
    local filename = file:gsub('[\\/]', '/'):match('([^/]+)%.lua$')
    local mod = 'user.core.custom.configs.spec.' .. filename
    table.insert(configs, require(mod))
  end
  return configs
end

return M
