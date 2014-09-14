local exosite = require 'exosite'
local json = require 'dkjson'

local exo = exosite.rpc:new{cik = "9829879a04efb8f4a1b42e22245739678fd4a94e"}

local status, response = exo:create{
	"dataport",
	{
		format = "float",
		name = "Temperature",
		retention = {
			count = "infinity",
			duration = "infinity"
		}
	}
}
print(status, json.encode(response))
local rid = response.result

local status, response = exo:map{"alias", rid, "temp"}
print(status, json.encode(response))

local status, response = exo:write{{alias="temp"}, 23.3}
print(status, json.encode(response))

local status, response = exo:read{{alias="temp"}, {}}
print(status, json.encode(response))

local status, response = exo:drop{{alias="temp"}}
print(status, json.encode(response))

local status, response = exo:info{{alias=""}, {}}
print(status, json.encode(response))