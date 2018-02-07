Collisions={}

EntityList={}

local function isItem(i)
	if type(i)=="table" then
		if i.type~=nil and i.x~=nil and i.y~=nil and i.w~=nil and i.h~=nil and (i.name~=nil or "") then
			return true
		else
			return false
		end
	else
		return false
	end
end
local function DrawTile(x,y,w,h,c1,c2)
	love.graphics.setColor(c1)
	love.graphics.rectangle("fill",x,y,w,h)
	love.graphics.setColor(c2)
	love.graphics.rectangle("line",x,y,w,h)
end
local function are_colliding(obj1,obj2)
	if isItem(obj1) and isItem(obj2) then
		local collision="none"
		local dx=(obj1.x+obj1.w/2)-(obj2.x+obj2.w/2)
		local dy=(obj1.y+obj1.h/2)-(obj2.y+obj2.h/2)
		local w=(obj1.w+obj2.w)/2
		local h=(obj1.h+obj2.h)/2

		local cw=w*dy
		local ch=h*dx

		if(math.abs(dx)<=w and math.abs(dy)<=h) then
			if (cw>ch) then
				if (cw>(-ch)) then
					collision="bottom"
				else
					collision="left"
				end
			else
				if (cw>-(ch)) then
					collision="right"
				else
					collision="top"
				end
			end
		end

		return collision
		elseif isItem(obj1) and not isItem(obj2) then
			error "Object 2 isn't an item."
			elseif isItem(obj2) and not isItem(obj1) then
				error "Object 1 isn't an item"
			else
				error "Neither of those are objects."
			end
		end


		function Collisions.m_diff(x1,y1,w1,h1, x2,y2,w2,h2)
			return x1-x2-w1,
			y2-y1-h1,
			w1+w2,
			h1+h2
		end


		Tile={
		x=0,
		y=0,
		w=0,
		h=0,
		active=false,
		new=function(self,o)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
		return o
	end
}

Level={
w=400,
h=600,
gravity=200,
new=function(self,o)
local o=o or {}
setmetatable(o,self)
self.__index=self
o.objects={}
o.tiles={}
o.active_tiles={}
if o.w>love.graphics.getWidth() then
	o.hscroll=true
else
	o.hscroll=false
end
if o.h>love.graphics.getHeight() then
	o.vscroll=true
else
	o.vscroll=false
end
if o.rows~=nil and o.cols~=nil then
	o.th=o.h/o.rows
	o.tw=o.w/o.cols
	elseif o.th~=nil and o.tw~=nil then
		o.rows=o.h/o.th
		o.cols=o.w/o.tw
	else
		o.rows=o.h/10
		o.cols=o.w/10
		o.th=10
		o.tw=10
	end
	for i=0,o.rows do
		for e=0,o.cols do
			table.insert(o.tiles,Tile:new{x=e*o.tw,y=i*o.th,w=o.tw,h=o.th,active=false})
		end
	end
	return o
	end,
	insert=function(self,objs)
	for i,v in ipairs(objs) do
		if isItem(v) then
			v.absolute_y=self.h
			v.absolute_x=self.w
			table.insert(self.objects,v)
		else
			error "Not an item."
		end
	end
	end,
	draw=function(self)
	for i,v in ipairs(self.objects) do
		v:draw()
	end
	end,
	detect=function(self,obj)
	for i,v in ipairs(self.objects) do
			if obj~=v and obj.type~="platform" then
				if are_colliding(obj,v)~="none" then
					obj:collides(v)
				else
					obj:not_colliding()
				end
			end
		end
	end,
	update=function(self,dt)
	for i,v in ipairs(self.objects) do
		v:update(dt)
		if v.is_g_affected then
			self:apply_gravity(dt,v)
		end
		self:detect(v)
	end
	self.active_tiles={}
	for i,v in ipairs(self.tiles) do
		if v.active then
			table.insert(self.active_tiles,{v.x,v.y})
		end
	end
	end,
	debug=function(self)
	local tx=""
	for i,v in ipairs(self.active_tiles) do
		tx=tx..v[1]..", "..v[2].." // "
	end
	love.graphics.setColor(255,255,255,255)
	love.graphics.print(tx,0,580)
end,
apply_gravity=function(self,dt,obj)
if obj.y+obj.h<obj.absolute_y then
obj.y_velocity=obj.y_velocity or 0
obj.y=obj.y-math.floor(obj.y_velocity*(dt*3))
obj.y_velocity=obj.y_velocity-math.floor(self.gravity*(dt*3))
else
obj.y=obj.absolute_y-obj.h
end
end
}

Item={
src="",
name="default",
x=0,
y=0,
w=10,
h=10,
absolute_y=love.graphics.getHeight(),
absolute_x=love.graphics.getWidth(),
text="Not colliding...",
c={0,255,0,150},
cc={255,0,0,150},
mode="fill",
type="item",
is_g_affected=true,
new=function(self,o)
local o=o or {}
setmetatable(o,self)
self.__index=self
o.dc=o.c
if o.src~="" then
	o.img=love.graphics.newImage(o.src)
	o.w=o.img:getWidth()
	o.h=o.img:getHeight()
end
return o
end,
draw=function(self)
if self.img~=nil then
	love.graphics.setColor(self.dc)
	love.graphics.draw(self.img,self.x,self.y)
else
	love.graphics.setColor(self.dc)
	love.graphics.rectangle(self.mode,self.x,self.y,self.w,self.h)
end
end,
move=function(self,way,val)
if way=="right" then
	self.x=self.x+val
end
if way=="left" then
	self.x=self.x-val
end
if way=="down" then
	self.y=self.y+val
end
if way=="up" then
	self.y=self.y-val
end
end,
collides=function(self,obj)
self.dc=self.cc
self.text="Colliding with "..obj.name
if are_colliding(self,obj)=="top" then
	self.y=obj.y-self.h
end
if are_colliding(self,obj)=="bottom" then
	self.y=obj.y+obj.h
end
if are_colliding(self,obj)=="right" then
	self.x=obj.x+obj.w
end
if are_colliding(self,obj)=="left" then
	self.x=obj.x-self.w
end
end,
not_colliding=function(self)
self.text="Not colliding"
self.dc=self.c
end,
update=function(self,dt)

end
}

Entity=Item:new{
c={255,255,255,255},
src="",
new=function(self,o)
local o=o or {}
setmetatable(o,self)
self.__index=self
if o.src~="" then
	o.img=love.graphics.newImage(o.src)
	o.w=o.img:getWidth()
	o.h=o.img:getHeight()
end
o.jumping=false
o.falling=false
o.colliding=false
return o
end
}

Platform=Item:new{type="platform",is_g_affected=false}
Ground=Platform:new{type="ground"}

Player=Entity:new{
speed=200,
type="player",
jumping=false,
y_velocity=0,
ground=0,
jump_height=200,
move=function(self,dt)
if love.keyboard.isDown("left") then
	self.x=self.x-math.floor(self.speed*dt)
end
if love.keyboard.isDown("right") then
	self.x=self.x+math.floor(self.speed*dt)
end
if love.keyboard.isDown("up") and not self.jumping then
	self.jumping=true
	self.y_velocity=self.jump_height
end
if self.y+self.h>self.absolute_y then
	self.y=self.absolute_y-self.h
	self.jumping=false
end
if self.x+self.w>self.absolute_x then
	self.x=self.absolute_x-self.w
end
if self.x<0 then
	self.x=0
end
if self.y<0 then
	self.y=0
end
end,
collides=function(self,obj)
self.colliding=true
if are_colliding(self,obj)=="top" then
	self.y=obj.y-self.h
	self.ground=obj.y-self.h
	self.y_velocity=0
	self.jumping=false
	self.falling=false
end
if are_colliding(self,obj)=="bottom" then
	self.y=obj.y+obj.h
end
if are_colliding(self,obj)=="right" then
	self.x=obj.x+obj.w
end
if are_colliding(self,obj)=="left" then
	self.x=obj.x-self.w
end
self.colliding=false
end,
update=function(self,dt)
self:move(dt)
end
}

return Collisions
