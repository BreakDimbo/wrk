-- example dynamic request script which demonstrates changing
-- the request path and a header for each request
-------------------------------------------------------------
-- NOTE: each wrk thread has an independent Lua scripting
-- context and thus there will be one counter per thread

request = function()
   local base = require("base") 
   local sha1 = require("sha1")
   local method = "GET"
   local time_stamp = os.date("%Y%m%d%H%M%S", os.time())
   local user_name = "123456789abcdef"
   local auth_token="a61b82d5497f7a31b5f069c8bade"
   local sign_str = sha1(user_name..auth_token..time_stamp)
   local app_id = "14118cc8-7d46-4868-567d-e22179bb3408"
   local apigtw_host = "/cmd/v1/"
   local authorization = enc(user_name..":"..sign_str)

   path = apigtw_host.."?timestamp="..time_stamp.."&app_id="..app_id
   wrk.headers["Authorization"] = "Basic "..authorization
   
   return wrk.format(method, path, nil, body)
end