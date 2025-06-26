local M = {}

function M.get_plugins()
  local sep = package.config:sub(1,1)
  local plugin_spec_path = table.concat({vim.fn.stdpath('config'), 'lua', 'user', 'core', 'custom', 'plugins', 'spec'}, sep) .. sep
  local files = vim.fn.glob(plugin_spec_path .. '*.lua', false, true)
  local plugins = {}
  for _, file in ipairs(files) do
    local filename = file:gsub('[\\/]', '/'):match('([^/]+)%.lua$')
    local mod = 'user.core.custom.plugins.spec.' .. filename
    table.insert(plugins, require(mod))
  end
  return plugins
end

return M
