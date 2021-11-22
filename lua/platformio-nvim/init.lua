  local curl = require('plenary.curl')
  local popup = require('plenary.popup')
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values

  baseUrl = 'https://api.registry.platformio.org/v2/lib/search?page=1&query='

  local function searchLib(query)
    local response = curl.get(baseUrl .. query)
    return vim.fn.json_decode(response.body)
  end

  local function formatResults(items)
    local lines = {}
    for i = 1, #items do
      table.insert(lines, items[i].name)
      table.insert(lines, items[i].description)
      table.insert(lines, '')
    end
    return lines
  end

  local function test()
  local width = 120
  local height = 40
  local borderchars =  { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
  local search_results = vim.api.nvim_create_buf(false, false)
  local win_id1 = popup.create(search_results, {
    title = "PlatformIO NVIM",
    highlight = "PlatformIO",
    relative = "editor",
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = borderchars,
  })
  local input_search_buf = vim.api.nvim_create_buf(false, false)
  -- Completed = false
  -- vim.api.nvim_buf_set_keymap(input_search_buf, 'i', '<cr>')

  local win_id2 = popup.create(input_search_buf, {
    relative = "editor",
    line = math.floor(((vim.o.lines - height) / 2) + height + 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = 1,
    borderchars = borderchars,
  })

  vim.api.nvim_buf_set_option(input_search_buf, "buftype", "prompt")
  vim.fn.prompt_setprompt(input_search_buf, '> ')
  vim.fn.prompt_setcallback(input_search_buf, function (text)
    local results = searchLib(text)
    vim.api.nvim_buf_set_lines(search_results, 0, 1, false, formatResults(results.items))
  end)
end

return {
  test = test
}
