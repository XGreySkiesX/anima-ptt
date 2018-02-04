local Entities={}

EntityList={}

Entity={
  x=0,
  y=0,
  w=0,
  h=0,
  c={255,255,255,255},
  isrc="",
  new=function(self,o)
    local o=o or {}
    setmetatable(o,self)
    self.__index=self
		if o.isrc~="" then
      o.img=love.graphics.newImage(o.isrc)
      o.w=o.img:getWidth()
      o.h=o.img:getHeight()
    end
    o.colliding=false
    o.falling=false
    o.collisions={"none",{}}
    o.left={x1=o.x,y1=o.y,x2=o.x,y2=o.y+o.h}
    o.right={x1=o.x+o.w,y1=o.y,x2=o.x+o.w,y2=o.y+o.h}
    o.top={x1=o.x,y1=o.y,x2=o.x+o.w,y2=o.y}
    o.bottom={x1=o.x,y1=o.y+o.h,x2=o.x+o.w,y2=o.y+o.h}
    if o.name~=nil then
		   table.insert(EntityList,o)
    end
		return o
  end,
  draw=function(self)
    if self.isrc~="" then
      love.graphics.setColor(self.c)
      love.graphics.draw(self.img,self.x,self.y)
    else
      love.graphics.setColor(self.c)
      love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
    end
  end,
  move=function(self,attribute,val)
    self[attribute]=self[attribute]+val
  end,
  collide=function(self)
    local temp1=false
    local temp2="none"
    local temp3={}
    for i,v in ipairs(EntityList) do
      if self.name~=v.name then
        if self.right.x1>=v.left.x1 and v.left.y1>=self.right.y1 and v.left.y1<=self.right.y2 then
          temp1=true
          temp2="right"
          temp3=v
        end
      end
    end
    self.colliding=temp1
    self.collisions={temp2,temp3}
  end
}

Platform=Entity:new{
  type="platform"
}

Player=Entity:new{
  speed=200,
  type="player",
  jumping=false,
  gravity=200,
  y_velocity=0,
  ground=0,
  jump_height=200,
  move=function(self,dt)
    if love.keyboard.isDown("left") and not (self.x<=0) then
      self.x=self.x-math.floor(self.speed*dt)
    end
    if love.keyboard.isDown("right") and not (self.x+self.w>=love.graphics.getWidth()) then
      self.x=self.x+math.floor(self.speed*dt)
    end
    if self.colliding and self.collisions[1]=="bottom" then
      self.ground=self.collisions[2].y-self.h
      self.jumping=false
      self.falling=false
      self.y_velocity=0
    end
    if love.keyboard.isDown("up") and not (self.y<0) --[[and not self.jumping]] then
      self.y=self.y-math.floor(self.speed*dt)
      --[[self.jumping=true
      self.falling=true
      self.colliding=false
      self.collisions={}
      self.y_velocity=self.jump_height]]
    end
  --[[  if self.jumping or self.y<self.ground then
      self.y=self.y-math.floor(self.y_velocity*(dt*3))
      self.y_velocity=self.y_velocity-math.floor(self.gravity*(dt*3))
    end
    if self.y>=love.graphics.getHeight() then
      self.y=love.graphics.getHeight()-self.h
      self.jumping=false
      self.falling=false
      self.ground=love.graphics.getHeight()-self.h
    end
    if not self.colliding and not self.jumping then
      self.falling=true
    end]]
    if love.keyboard.isDown("down") and not (self.y>love.graphics.getHeight()) then
      self.y=self.y+math.floor(self.speed*dt)
    end
  end,
  update=function(self,dt)
    self:move(dt)
    self:collide()
  end
}

function Entities.update(dt)
  for i,v in ipairs(EntityList) do
    if v.update~=nil then
      v:update(dt)
    end
  end
end

function Entities.draw()
  for i,v in ipairs(EntityList) do
    v:draw()
  end
end

return Entities
