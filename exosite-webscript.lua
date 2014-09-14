local exosite = {
	_VERSION     = "exosite-lua-webscript 0.1.0",
	_DESCRIPTION = "A Lua client library for using the Exosite RPC API on webscript.io.",
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
	local request = json.stringify({
		auth = {cik = self.cik},
		calls = {call}
	})
	
	local resp = http.request{
		url = "https://m2.exosite.com/onep:v1/rpc/process",
		method = "POST",
		headers = {
			["Content-Type"] = "application/json"
		},
		data = request
	}

	if resp.statuscode == 200 then
		return true, json.parse(resp.content)[1]
	else 
		return false, code, resp.content
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
