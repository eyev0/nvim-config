--- @param str string
--- @param sep string
local function split(str, sep)
  --- @type table<string>
  local t = {}
  for match in str:gmatch(("[^%s]+"):format(sep)) do
    table.insert(t, match)
  end
  return t
end

string.split = split
