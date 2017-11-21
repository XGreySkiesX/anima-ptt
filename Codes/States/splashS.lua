--Splash State--

local Splash={}
local centerx,centery=love.graphics.getWidth()/2,love.graphics.getHeight()/2

function Splash:enter()
self.duration=4
end

function Splash:update(dt)
self.duration=self.duration-dt
if self.duration < 0 then
Gamestate.switch(Menu)
end
end

function Splash:draw()
se=self.duration/8
love.graphics.setColor(100,255,255,255*se)
love.graphics.rectangle("fill",centerx-32,centery-32,64,64)
love.graphics.setColor(255, 255, 255, 255)
love.graphics.print("Tag.OS Prototype", centerx-32, centery+32)
  end

  function Splash:keypressed(key)
  if key then
  Gamestate.switch(Menu)
  end
  end

return Splash
