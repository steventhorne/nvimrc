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
  dump = dump,
  get_mason_cmd = get_mason_cmd,
}
