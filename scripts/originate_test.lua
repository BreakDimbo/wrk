-- example dynamic request script which demonstrates changing
-- the request path and a header for each request
-------------------------------------------------------------
-- NOTE: each wrk thread has an independent Lua scripting
-- context and thus there will be one counter per thread

init = function (args)
  local base = require("base") 
  local sha1 = require("sha1")
  local time_stamp = os.date("%Y%m%d%H%M%S", os.time())
  local user_name = "123456789abcdef"
  local auth_token="a61b82d5497f7a31b5f069c8bade"
  local sign_str = sha1(user_name..auth_token..time_stamp)
  local app_id = "0aac88e9-ccc3-4f91-76bc-a1f443857aed"
  local apigtw_host = "/cmd/v1/originate"

  authorization = enc(user_name..":"..sign_str)
  method = "POST"
  path = apigtw_host.."?timestamp="..time_stamp.."&app_id="..app_id
  -- body = {
  --         ["caller"] = 13240345451,
  --         ["called"] = 04712110288,
  --         ["called_display"] = 04712556365,
  --         ["agent_id"] = "99999999991001",
  -- }
  body = '{"caller": "98765432268400", "called": "13240345451", "called_display": "04718888888", "agent_id": "570"}'
end


request = function()
   wrk.headers["Authorization"] = "Basic "..authorization
   wrk.headers["Content-Type"] = "application/json"
   return wrk.format(method, path, nil, body)
end