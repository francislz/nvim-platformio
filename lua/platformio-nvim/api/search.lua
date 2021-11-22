local curl = require('plenary.curl')

local function searchLib(query)
  local response = curl.request {
    url = 'https://api.registry.platformio.org/v2/lib/search?page=1&query=MQTT',
    method = 'GET',
  }
  print(response)
end

return {
  searchLib = searchLib,
}
