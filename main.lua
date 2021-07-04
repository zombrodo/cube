local Cube = require "src.primitives.cube"
local Camera = require "src.camera"
local Vector3 = require "lib.vector3"
local Shader = require "src.shader"
local Loader = require "src.loader"
local Model = require "src.primitives.model"

local camera
local cube
local shader
local focused
local timer = 0

function love.load()
  love.graphics.setDepthMode("lequal", true)
  shader = Shader.new("assets/shaders/pixel.glsl", "assets/shaders/vert.glsl")
  camera = Camera.new(shader)

  local cubeData = Loader.loadObj("assets/models/cube.obj")
  cube = Model.new(cubeData, Vector3.fromPool(0, 0, 4), shader)

  camera.position = Vector3.fromPool(0, 0, 0)
  camera.target = Vector3.fromPool(0, 0, 1)

  camera:updateProjectionMatrix()
  camera:updateViewMatrix()
end

function love.update(dt)
  timer = timer + dt
  camera:updateMovement(dt)
  shader:send("lightPosition", { camera.position:unpack() })
  shader:send("viewPosition", { camera.position:unpack() })

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