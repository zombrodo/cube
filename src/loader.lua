local Loader = {}

-- HELPERS

local function reduce(fn, coll, init)
  local acc = init
  for i = 1, #coll do
    acc = fn(init, coll[i], i)
  end
  return acc
end

local function take(tbl, ...)
  return reduce(
    function(acc, index)
      table.insert(acc, tbl[index])
      return acc
    end,
    {...},
    {}
  )
end

local function map(fn, tbl)
  local result = {}
  for i, elem in ipairs(tbl) do
    table.insert(result, fn(elem))
  end
  return result
end

local function split(str, sep)
  local result = {}
  string.gsub(
    str,
    string.format("([^%s]+)", sep),
    function(c) table.insert(result, c) end
  )
  return result
end

local function addAll(tbl, ...)
  for i, elem in ipairs({...}) do
    table.insert(tbl, elem)
  end
end

local function flatten(tbl)
  local result = {}
  for i, child in ipairs(tbl) do
    local row = {}
    for j, innerChild in ipairs(child) do
      addAll(row, unpack(innerChild))
    end
    table.insert(result, row)
  end
  return result
end

-- FIXME: this doesn't smell like a general-purpose `toVertexData` fn.
function Loader.toVertexData(verticies, uvs, normals, faces)
  local result = {}

  for _, face in ipairs(faces) do
    for _, index in ipairs(face) do
      table.insert(result, {
        verticies[index[1]],
        uvs[index[2]],
        normals[index[3]]
      })
    end
  end
  return flatten(result)
end

-- Loaders

function Loader.loadObj(objPath)
  local verticies = {}
  local uvs = {}
  local normals = {}
  local faces = {}
  for line in love.filesystem.lines(objPath) do
    local tokens = split(line, " ")
    if tokens[1] == "v" then
      table.insert(verticies, map(tonumber, take(tokens, 2, 3, 4)))
    end

    if tokens[1] == "vt" then
      table.insert(uvs, map(tonumber, take(tokens, 2, 3)))
    end

    if tokens[1] == "vn" then
      table.insert(normals, map(tonumber, take(tokens, 2, 3, 4)))
    end

    if tokens[1] == "f" then
      local face = {}
      for i = 2, #tokens do
        table.insert(face, map(tonumber, split(tokens[i], "/")))
      end
      table.insert(faces, face)
    end
    -- TODO: not handled: s, o/g, usemtl
  end
  return Loader.toVertexData(verticies, uvs, normals, faces)
end

return Loader
