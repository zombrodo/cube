local Vector3 = require "lib.vector3"
local Matrix = require "lib.matrix"

-- A port of Groverburger's Camera from g3d
-- https://github.com/groverburger/g3d/blob/master/g3d/camera.lua

local Camera = {}
Camera.__index = Camera

function Camera.new(shader)
  local self = setmetatable({}, Camera)
  self.fov = math.pi / 2
  self.nearClip = 0.01
  self.farClip = 1000
  self.aspectRatio = love.graphics.getWidth() / love.graphics.getHeight()

  self.position = Vector3.fromPool(0, 0, 0)
  self.target = Vector3.fromPool(0, 0, 1)
  self.down = Vector3.fromPool(0, -1, 0)

  self.direction = 0
  self.pitch = 0

  self.shader = shader

  self.mouseGrabbed = true
  return self
end

function Camera:getLookVector()
  local v = self.target - self.position
  local length = v:length()

  if length > 0 then
    return Vector3.fromPool(v.x / length, v.y / length, v.z / length)
  end
  return Vector3.fromPool(v.x, v.y, v.z)
end

function Camera:lookAt(from, at)
  self.position = from
  self.target = at

  local lookVector = self:getLookVector()
  self.direction = math.pi / 2 - math.atan2(lookVector.z, lookVector.x)
  self.pitch = -math.atan2(lookVector.y,
  math.sqrt(lookVector.x * lookVector.x + lookVector.z * lookVector.z))
  lookVector:release()
  self:updateViewMatrix()
end

function Camera:lookInDirection(directionTowards, pitchTowards)
  self.direction = directionTowards or self.direction
  self.pitch = pitchTowards or self.pitch

  local sign = math.cos(self.pitch)
  sign = (sign > 0 and 1) or (sign < 0 and -1) or 0

  local cosPitch = sign * math.max(math.abs(math.cos(self.pitch)), 0.00001)

  self.target:set(
    self.position.x + math.sin(self.direction) * cosPitch,
    self.position.y - math.sin(self.pitch),
    self.position.z + math.cos(self.direction) * cosPitch
  )

  self:updateViewMatrix()
end

function Camera:updateViewMatrix()
  local viewMatrix = Matrix.viewMatrix(
    self.position,
    self.target,
    self.down)
  self.shader:send("viewMatrix", viewMatrix)
  viewMatrix:release()
end

function Camera:updateProjectionMatrix()
  local projectionMatrix = Matrix.projectionMatrix(
    self.fov,
    self.nearClip,
    self.farClip,
    self.aspectRatio
  )
  self.shader:send("projectionMatrix", projectionMatrix)
  projectionMatrix:release()
end

local moveDirection = { x = 0, y = 0 }
local speed = 3

function Camera:updateMovement(dt)
  moveDirection.x = 0
  moveDirection.y = 0

  local didMove = false

  if love.keyboard.isDown("w") then
    moveDirection.y = moveDirection.y - 1
  end

  if love.keyboard.isDown("s") then
    moveDirection.y = moveDirection.y + 1
  end

  if love.keyboard.isDown("a") then
    moveDirection.x = moveDirection.x - 1
  end

  if love.keyboard.isDown("d") then
    moveDirection.x = moveDirection.x + 1
  end

  if love.keyboard.isDown("space") then
    self.position.y = self.position.y - speed * dt
    didMove = true
  end

  if love.keyboard.isDown("lshift") then
    self.position.y = self.position.y + speed * dt
    didMove = true
  end

  if moveDirection.x ~= 0 or moveDirection.y ~= 0 then
    local angle = math.atan2(moveDirection.y, moveDirection.x)
    self.position:set(
      self.position.x + math.cos(self.direction + angle) * speed * dt,
      self.position.y,
      self.position.z + math.sin(self.direction + angle + math.pi) * speed * dt
    )
    didMove = true
  end

  if didMove then
    self:lookInDirection()
  end
end

function Camera:firstPersonLook(dx, dy)
  love.mouse.setRelativeMode(true)
  local sensitivity = 1 / 200
  self.direction = self.direction + dx * sensitivity
  self.pitch = math.max(math.min(self.pitch - dy * sensitivity, math.pi * 0.5), math.pi * -0.5)
  self:lookInDirection(self.direction, self.pitch)
end

return Camera
