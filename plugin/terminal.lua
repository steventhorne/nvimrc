local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or vim.o.columns - 6;
  local height = opts.height or vim.o.lines - 6;

  local col = 2;
  local row = 2;

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = vim.opt.shell._value
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local toggleTerminal = function(opts)
  opts = opts or {}
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window( { buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.term()
      vim.api.nvim_command("set nobuflisted")
      vim.api.nvim_buf_set_keymap(state.floating.buf, "n", "q", ":q<CR>", {})
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.keymap.set("n", "<LEADER>;", toggleTerminal)
