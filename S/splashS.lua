--Splash State--

local Splash={}
local centerx,centery=love.graphics.getWidth()/2,love.graphics.getHeight()/2
local splash_fnt=love.graphics.newFont(16)

function Splash:enter()
  duration=2
  ss=love.timer.getTime()
end

function Splash:update(dt)
  if duration-(love.timer.getTime()-ss) < 0 then
    Gamestate.switch(MS)
  end
end

function Splash:draw()
  se=(duration-(love.timer.getTime()-ss))/8
  love.graphics.setColor(100/255,1,1,se)
  love.graphics.rectangle("fill",centerx-32,centery-32,64,64)
  love.graphics.setFont(splash_fnt)
  love.graphics.setColor(1, 1, 1, 1)
  printc("Anima Prototype",splash_fnt,centerx,centery+64)
end

function Splash:keypressed(key)
  if key then
    duration=-1
  end
end

return Splash
