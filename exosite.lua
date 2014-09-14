local http = require 'socket.http'
local json = require 'dkjson'

local exosite = {
  _VERSION     = "exosite-lua 0.1.0",
  _DESCRIPTION = "A Lua client library for the Exosite RPC API.",
  _AUTHOR      = "Patrick Barrett <patrick@mkii.org>",
  _COPYRIGHT   = "Copyright 2014 Patrick Barrett",
  _LICENSE     = "http://opensource.org/licenses/BSD-2-Clause"
}

exosite.rpc = {
  URL = 'https://m2.exosite.com/onep:v1/rpc/process'
}

local mt = {
  __index = function(self, procedure)
    return function(self, arguments)
      local this_call = {
        id = math.random(10000),
        procedure = procedure,
        arguments = arguments
      }

      local status, ret, err = self:call(this_call)

      if status == false then
        return false, ret, err
      else
        return true, ret
      end
    end
  end
}

function exosite.rpc:call(call)
  local request = json.encode({
    auth = {cik = self.cik},
    calls = {call}
  })

  local resp = {}
  local ret,code,hrd = http.request{
    method = "POST",
    url = self.URL,
    headers = {
      ["content-length"] = #request,
      ["content-type"] = "application/json"
    },
    source = ltn12.source.string(request),
    sink = ltn12.sink.table(resp)
  }

  if code == 200 then
    return true, json.decode(table.concat(resp))[1]
  else 
    return false, code, table.concat(resp)
  end
end

function exosite.rpc:new(tbl)
  assert(type(tbl.cik) == "string" and #tbl.cik == 40)

  local o = tbl
  setmetatable(o, {__index = self})
  return o
end

setmetatable(exosite.rpc, mt)

-- Need to ensure this gets seeded
math.randomseed( os.time() )

return exosite
