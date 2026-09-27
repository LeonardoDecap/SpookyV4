local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local commit = readfile('newvape/profiles/commit.txt')
		local url = 'https://raw.githubusercontent.com/LeonardoDecap/SpookyV4/'..commit..'/dev-build/'..select(1, path:gsub('newvape/', ''))
		local suc, res = pcall(function()
			return game:HttpGet(url, true)
		end)
		if not suc or type(res) ~= 'string' or res == '' or res == '404: Not Found' then
			error('[SpookyV4 DEV] required file unavailable: '..path..' ('..tostring(res)..')')
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'newvape', 'newvape/games', 'newvape/profiles', 'newvape/assets', 'newvape/libraries', 'newvape/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

local api = 'https://api.github.com/repos/LeonardoDecap/SpookyV4/commits/dev'
local success, response = pcall(function()
	return game:HttpGet(api, true)
end)
if not success or type(response) ~= 'string' then
	error('[SpookyV4 DEV] unable to resolve dev commit: '..tostring(response))
end
local decoded, data = pcall(function()
	return game:GetService('HttpService'):JSONDecode(response)
end)
local commit = decoded and type(data) == 'table' and data.sha or nil
if type(commit) ~= 'string' or not commit:match('^[0-9a-fA-F]+$') or #commit ~= 40 then
	error('[SpookyV4 DEV] invalid dev commit response; stopping')
end

print('[SpookyV4 DEV] build '..commit:sub(1, 8))
local assetVer = '1'
if (isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or '') ~= commit then
	wipeFolder('newvape')
	wipeFolder('newvape/games')
	wipeFolder('newvape/guis')
	wipeFolder('newvape/libraries')
end
if (isfile('newvape/profiles/asset.txt') and readfile('newvape/profiles/asset.txt') or '') ~= assetVer then
	wipeFolder('newvape/assets')
end

writefile('newvape/profiles/asset.txt', assetVer)
writefile('newvape/profiles/commit.txt', commit)
local source = downloadFile('newvape/main.lua')
local chunk, err = loadstring(source, 'main')
if not chunk then error('[SpookyV4 DEV] main.lua compile failed: '..tostring(err)) end
return chunk()
