local function map_key(mode, key, result, opts)
  opts = opts or {
    noremap = true,
    silent = true,
  }
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    opts
  )
end

local function get_root_dir(patterns, use_cwd_as_fallback)
  use_cwd_as_fallback = use_cwd_as_fallback or false
  local cwd = vim.fn.getcwd()
  local bufdir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))

  while true do
    for _, pattern in ipairs(patterns) do
      for _, _ in ipairs(vim.fn.glob(bufdir .. "/" .. pattern, true, true)) do
        return bufdir
      end
    end
    if string.upper(bufdir) == string.upper(cwd) then
      break
    end
    bufdir = vim.fs.dirname(bufdir)
  end

  if use_cwd_as_fallback then
    return cwd
  end

  return nil
end

return {
  map_key = map_key,
  get_root_dir = get_root_dir,
}
