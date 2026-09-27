print('[SpookyV4 DEV] starting')
local url = 'https://raw.githubusercontent.com/LeonardoDecap/SpookyV4/dev/src/loader.lua'
local success, source = pcall(function()
	return game:HttpGet(url, true)
end)
if not success or type(source) ~= 'string' or source == '' or source == '404: Not Found' then
	error('[SpookyV4 DEV] loader unavailable: '..tostring(source))
end
local chunk, err = loadstring(source, 'SpookyV4 loader')
if not chunk then error('[SpookyV4 DEV] loader compile failed: '..tostring(err)) end
return chunk()
