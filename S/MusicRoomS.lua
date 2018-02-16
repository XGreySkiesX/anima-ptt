--Music Room--
local MusicRoom={}

function MusicRoom:enter()
  Sounds.stopSounds()
  Text.clear()
  Display.clear()
  v1=Vector:new(10,10)
  v2=Vector:new(5,0)

end

function MusicRoom:keypressed(k)

  if k=="escape" then
    Gamestate.switch(MenuScreen)
  end
end

function MusicRoom:update(dt)
  v3=v1+v2
end

function MusicRoom:draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.print(v3.x..", "..v3.y,0,0)
end


return MusicRoom
