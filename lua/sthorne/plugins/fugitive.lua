return {
  config = function()
    local map_key = require("sthorne.utils").map_key
    map_key("n", "<LEADER>gs", ":Git<CR>")
    map_key("n", "<LEADER>gb", ":Git blame<CR>")
    map_key("n", "<LEADER>gd", ":Ghdiffsplit<CR>")
    map_key("n", "<LEADER>gl", ":Git log<CR>")
  end
}
