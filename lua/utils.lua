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

return {
  map_key = map_key,
}

