local is_inside_work_tree = {}

local function is_git_repo()
  local cwd = vim.uv.cwd() or ""
  if is_inside_work_tree[cwd] == nil then
    local ok, _ = vim.loop.fs_stat(cwd.."/.git")
    is_inside_work_tree[cwd] = ok
  end

  return is_inside_work_tree[cwd]
end

local function git_files_with_fallback(all)
  local builtin = require("telescope.builtin")
  local opts = {
    hidden = true,
    no_ignore = all,
    no_ignore_parent = all,
  }
  if is_git_repo() and not all then
    builtin.git_files()
  else
    builtin.find_files(opts)
  end
end

return {
  git_files_with_fallback = git_files_with_fallback,
}
