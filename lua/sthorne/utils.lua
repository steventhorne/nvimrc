local function capitalize_drive_letter(path)
  if not vim.fn.has("win32") then return path end
  local has_drive_letter = string.match(path, "^%a:")
  if has_drive_letter then
    local drive_letter = string.sub(path, 1, 1)
    return string.upper(drive_letter) .. string.sub(path, 2)
  end

  return path
end

local function get_root_dir(patterns, use_cwd_as_fallback)
  use_cwd_as_fallback = use_cwd_as_fallback or false
  local cwd = vim.fn.getcwd()
  local prevbufdir = ""
  local bufdir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))

  while true do
    for _, pattern in ipairs(patterns) do
      for _, _ in ipairs(vim.fn.glob(bufdir .. "/" .. pattern, true, true)) do
        return capitalize_drive_letter(bufdir)
      end
    end
    if prevbufdir == bufdir or string.upper(bufdir) == string.upper(cwd) then
      break
    end
    prevbufdir = bufdir
    bufdir = vim.fs.dirname(bufdir)
  end

  if use_cwd_as_fallback then
    return capitalize_drive_letter(cwd)
  end

  return nil
end

local function dump(o)
  if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function get_mason_cmd(name)
  local masonBin = vim.fn.stdpath("data").."/mason/bin"
  local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
  if is_windows then
    name = name..".cmd"
  end
  return masonBin.."/"..name
end

return {
  get_root_dir = get_root_dir,
  dump = dump,
  get_mason_cmd = get_mason_cmd,
}
