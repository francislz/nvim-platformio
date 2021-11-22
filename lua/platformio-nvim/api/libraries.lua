local curl = require('plenary.curl')

local baseUrl = 'https://api.registry.platformio.org/v2/lib/search?page=1&query='

local function search(query)
  local response = curl.get(baseUrl .. query)
  return vim.fn.json_decode(response.body)
end

return {
  search = search,
}
