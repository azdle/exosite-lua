# exosite-lua

## About
exosite-lua is a pure Lua client library for Exosite's Remote Procedure Call
API. All procedures, current and future, are automatically supported.

## Requires
The standard version depends on `LuaSocket` and `dkjson`.

The "-webscript" version uses the built-in http and json modules and has no
dependancies (other than being run from https://webscript.io)

## Usage

### Include exosite-lua in Your Script

```lua
local exosite = require 'exosite'

-- or for webscript.io:
local exosite = require 'azdle/exosite-lua/exosite-webscript.lua'
```

### Create a Local RPC Client Instance

```lua
local exo = exosite.rpc:new{cik = "<INSERT CIK>"}
```

### General Procedure Format

```lua
local status, response = exo:<procedure>(<arguments table>)
```
See http://docs.exosite.com/rpc/ for a list of all procedures and what
arguments they each take.

### Create Dataport

```lua
local status, response = exo:create{"dataport", {<options>}}

-- status <==> true
-- response <==> {status = "ok", id = 3290, result = "<new dataport rid>"}
```

### Map an Alias
```lua
local status, response = exo:map{"alias", <rid_to_map>, "<new_alias>"}

-- status <==> true
-- response <==> {status = "ok", id = 324}
```

### Write to a Dataport
```lua
local status, response = exo:write{{alias = "<alias>", <value>}

-- status <==> true
-- response <==> {status = "ok", id = 6643, result = <timestamp>}
```

### Read from a Dataport
```lua
local status, response = exo:read{{alias = "<alias>", {<options>}}

-- status <==> true
-- response <==> {status = "ok", id = 3349
--                result = {{<timestamp>, <value>}, ...}}
```

### Drop a Resource
```lua
local status, response = exo:drop{{alias = "<alias>"}}

-- status <==> true
-- response <==> {status = "ok", id = 138}
```

### Get Information About a Resource
```lua
local status, response = exo:info{{alias = "<alias>"}, <options_tbl>}

-- status <==> true
-- response <==> {status = "ok", id = 8335, result = <info_tbl>}
```

## Author

Patrick Barrett <patrick@mkii.org>

## License
The files in this repository are distributed under the BSD-2-Clause license.
See the LICENSE file for more information.
