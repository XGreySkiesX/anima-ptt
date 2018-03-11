--Splash State--

local Splash={}
local centerx,centery=love.graphics.getWidth()/2,love.graphics.getHeight()/2

function Splash:enter()
  duration=4
end

function Splash:update(dt)
  duration=duration-dt
  if duration < 0 then
    Gamestate.switch(MS)
  end
end

function Splash:draw()
  se=duration/8
  love.graphics.setColor(100,255,255,255*se)
  love.graphics.rectangle("fill",centerx-32,centery-32,64,64)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("Tag.OS Prototype", centerx-32, centery+32)
end

function Splash:keypressed(key)
  if key then
    duration=-1
  end
end

return Splash
