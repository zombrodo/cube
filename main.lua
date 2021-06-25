local Cube = require "src.primitives.cube"
local Camera = require "src.camera"
local Vector3 = require "lib.vector3"

local camera
local cube
local vertexShader

function love.load()
  love.graphics.setDepthMode("lequal", true)
  vertexShader = love.graphics.newShader("assets/main.glsl")
  camera = Camera.new(vertexShader)
  cube = Cube.new(Vector3.new(0, 0, 4), vertexShader)
  camera.position = Vector3.new(0, 0, 0)
  camera.target = Vector3.new(0, 0, 1)

  camera:updateProjectionMatrix()
  camera:updateViewMatrix()
end

function love.update(dt)
  camera:updateMovement(dt)
end

function love.mousemoved(_x, _y, dx, dy)
  camera:firstPersonLook(dx, dy)
end

function love.draw()
  cube:draw()
end