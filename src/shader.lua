local Shader = {}
Shader.__index = Shader


local function lastModified(filePath)
  local info = love.filesystem.getInfo(filePath, "file")
  return info.modtime
end

function Shader.new(pixelPath, vertexPath)
  local self = setmetatable({}, Shader)
  self.watch = {
    [pixelPath] = lastModified(pixelPath),
    [vertexPath] = lastModified(vertexPath)
  }
  self.pixelPath = pixelPath
  self.vertexPath = vertexPath
  self.shader = love.graphics.newShader(pixelPath, vertexPath)
  return self
end

function Shader:changes()
  return self.watch[self.pixelPath] ~= lastModified(self.pixelPath)
    or self.watch[self.vertexPath] ~= lastModified(self.vertexPath)
end

function Shader:swap()
  local status, message = love.graphics.validateShader(
    false, self.pixelPath, self.vertexPath
  )

  if status then
    self.shader = love.graphics.newShader(self.pixelPath, self.vertexPath)
    self.watch[self.pixelPath] = lastModified(self.pixelPath)
    self.watch[self.vertexPath] = lastModified(self.vertexPath)
    return true
  end
  print(message)
  return false
end

function Shader:update(dt)
  if self:changes() then
    return self:swap()
  end
  return false
end

function Shader:send(variable, value)
  self.shader:send(variable, value)
end

return Shader