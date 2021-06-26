local Cube = require "src.primitives.cube"
local Camera = require "src.camera"
local Vector3 = require "lib.vector3"
local Shader = require "src.shader"

local camera
local cube
local shader
local focused

local lightPosition = Vector3.fromPool(1, 1, 4)

function love.load()
  love.graphics.setDepthMode("lequal", true)
  shader = Shader.new("assets/pixel.glsl", "assets/vert.glsl")
  shader:send("lightPosition", { lightPosition:unpack() })
  camera = Camera.new(shader)
  cube = Cube.new(Vector3.new(0, 0, 4), shader)
  camera.position = Vector3.new(0, 0, 0)
  camera.target = Vector3.new(0, 0, 1)

  camera:updateProjectionMatrix()
  camera:updateViewMatrix()
end

function love.update(dt)
  camera:updateMovement(dt)
  local updated = shader:update(dt)
  if updated then
    camera:reload()
  end
end

function love.mousemoved(_x, _y, dx, dy)
  if focused then
    camera:firstPersonLook(dx, dy)
  end
end

function love.focus(focus)
  love.mouse.setRelativeMode(focus)
  focused = focus
end

function love.draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle('fill', 0, 0, 256, 64)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)
  love.graphics.print('Memory: ' .. math.floor(collectgarbage 'count') .. ' kb', 0, 16)

  cube:draw()
end