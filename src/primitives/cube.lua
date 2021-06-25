local Matrix = require "lib.matrix"
local Vector3 = require "lib.Vector3"

local Cube = {}
Cube.__index = Cube

local vertexFormat = {
  {"VertexPosition", "float", 3},
  {"VertexTexCoord", "float", 2},
  {"VertexColor", "byte", 4},
}

local verts = {
  {-1, -1, -1, 0, 0, 1, 0, 0, 1},
  { 1, -1, -1, 1, 0, 1, 0, 0, 1},
  {-1,  1, -1, 0, 1, 1, 0, 0, 1},
  { 1,  1, -1, 1, 1, 1, 0, 0, 1},
  { 1, -1, -1, 1, 0, 1, 0, 0, 1},
  {-1,  1, -1, 0, 1, 1, 0, 0, 1},

  {-1, -1,  1, 0, 0, 0, 0, 1, 1},
  { 1, -1,  1, 1, 0, 0, 0, 1, 1},
  {-1,  1,  1, 0, 1, 0, 0, 1, 1},
  { 1,  1,  1, 1, 1, 0, 0, 1, 1},
  { 1, -1,  1, 1, 0, 0, 0, 1, 1},
  {-1,  1,  1, 0, 1, 0, 0, 1, 1},

  {-1, -1, -1, 0, 0, 0, 1, 0, 1},
  { 1, -1, -1, 1, 0, 0, 1, 0, 1},
  {-1, -1,  1, 0, 1, 0, 1, 0, 1},
  { 1, -1,  1, 1, 1, 0, 1, 0, 1},
  { 1, -1, -1, 1, 0, 0, 1, 0, 1},
  {-1, -1,  1, 0, 1, 0, 1, 0, 1},

  {-1,  1, -1, 0, 0, 1, 1, 0, 1},
  { 1,  1, -1, 1, 0, 1, 1, 0, 1},
  {-1,  1,  1, 0, 1, 1, 1, 0, 1},
  { 1,  1,  1, 1, 1, 1, 1, 0, 1},
  { 1,  1, -1, 1, 0, 1, 1, 0, 1},
  {-1,  1,  1, 0, 1, 1, 1, 0, 1},

  {-1, -1, -1, 0, 0, 0, 1, 1, 1},
  {-1,  1, -1, 1, 0, 0, 1, 1, 1},
  {-1, -1,  1, 0, 1, 0, 1, 1, 1},
  {-1,  1,  1, 1, 1, 0, 1, 1, 1},
  {-1,  1, -1, 1, 0, 0, 1, 1, 1},
  {-1, -1,  1, 0, 1, 0, 1, 1, 1},

  { 1, -1, -1, 0, 0, 1, 0, 1, 1},
  { 1,  1, -1, 1, 0, 1, 0, 1, 1},
  { 1, -1,  1, 0, 1, 1, 0, 1, 1},
  { 1,  1,  1, 1, 1, 1, 0, 1, 1},
  { 1,  1, -1, 1, 0, 1, 0, 1, 1},
  { 1, -1,  1, 0, 1, 1, 0, 1, 1},
}

function Cube.new(position, shader)
  local self = setmetatable({}, Cube)
  self.mesh = love.graphics.newMesh(vertexFormat, verts, "triangles")
  self.position = position
  self.shader = shader
  return self
end

function Cube:update(dt)
end

function Cube:draw()
  love.graphics.push("all")
  local modelMatrix = Matrix.transformMatrix(
    self.position,
    Vector3.zero(),
    Vector3.one()
  )
  self.shader:send("modelMatrix", modelMatrix)
  modelMatrix:release()
  love.graphics.setShader(self.shader)
  love.graphics.draw(self.mesh)
  love.graphics.pop()
end

return Cube