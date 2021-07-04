local Vector3 = require "lib.vector3"
local Matrix = require "lib.matrix"

local Model = {}
Model.__index = Model

local vertexFormat = {
  {"VertexPosition", "float", 3},
  {"VertexTexCoord", "float", 2},
  {"VertexNormal", "float", 3},
  {"VertexColor", "byte", 4},
}

function Model.new(vertexData, position, shader)
  local self = setmetatable({}, Model)
  self.mesh = love.graphics.newMesh(
    vertexFormat,
    vertexData,
    "triangles"
  )
  self.position = position
  self.rotation = Vector3.zero()
  self.scale = Vector3.one()
  self.shader = shader
  return self
end

function Model:update(dt)

end

function Model:draw()
  love.graphics.push("all")
  local modelMatrix = Matrix.transformMatrix(
    self.position,
    self.rotation,
    self.scale
  )
  self.shader:send("modelMatrix", modelMatrix)
  modelMatrix:release()
  love.graphics.setShader(self.shader.shader)
  love.graphics.draw(self.mesh)
  love.graphics.pop()
end

return Model