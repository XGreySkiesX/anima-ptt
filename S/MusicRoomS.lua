--Music Room--
local MusicRoom={}

function MusicRoom:enter()
  Sounds.stopSounds()
  Text.clear()
  Display.clear()
  L=Level:new{}
  test=Item:new{w=100,h=100,name="t",is_g_affected=false,update=function(self,dt)
if love.keyboard.isDown("up") and self.y>0 then
    self:move("up",200*dt)
  elseif self.y<0 then
    self.y=0
  end
  if love.keyboard.isDown("left") and self.x>0 then
    self:move("left",200*dt)
  end
  if love.keyboard.isDown("right") and self.x+self.w<love.graphics.getWidth() then
    self:move("right",200*dt)
  end
  if love.keyboard.isDown("down") and self.y+self.h<love.graphics.getHeight() then
    self:move("down",200*dt)
  end
end}
  test2=Item:new{x=100,y=400,w=200,h=20,name="t2"}
  test3=Item:new{x=150,y=100,w=50,h=20,name="t3"}
  L:insert({test,test2,test3})

end

--so you can get outta the place
function MusicRoom:keypressed(k)

  if k=="escape" then
    Gamestate.switch(MenuScreen)
  end
end

function MusicRoom:update(dt)
  L:update(dt)
end

function MusicRoom:draw()
  L:debug()
  L:draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.print(test.text,0,580)
end


return MusicRoom
