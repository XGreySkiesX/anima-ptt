local Obj={}

EntityList={}

Vector={
	x=0,
	y=0,
	__add=function(vec1,vec2)
			t1=vec1.x+vec2.x
			t2=vec1.y+vec2.y

			return Vector:new(t1,t2)
		end,
	__sub=function(vec1,vec2)
		t1=vec1.x-vec2.x
		t2=vec1.y-vec2.y

		return Vector:new(t1,t2)
	end,
	__unm=function(self)
	return Vector:new(-self.x,-self.y)
	end,
	new=function(self,x,y)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
		o.x=x
		o.y=y
		return o
	end
}

local orig=Vector:new(0,0)

Rect={
	x=0,
	y=0,
	w=20,
	h=20,
	new=function(self,o)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
		o.tl=Vector:new(o.x,o.y)
		o.tr=Vector:new(o.x+o.w,o.y)
		o.center=Vector:new(o.x+o.w/2,o.y+o.h/2)
		o.bl=Vector:new(o.x,o.y+o.h)
		o.br=Vector:new(o.x+o.w,o.y+o.h)
		o.min=o.tl
		o.max=o.br
		return o
	end,
	get_min=function(self)
	return self.bl
	end,
	get_max=function(self)
	return self.tr
	end,
	translate=function(self,vec)
		local nv=vec-self.tl
		self.center=self.center+nv
		self.tl=self.tl+nv
		self.tr=self.tl+nv
		self.bl=self.bl+nv
		self.br=self.br+nv
		self.min=self.tl
		self.max=self.br
	end,
	add_vector=function(self,vec)
		self.center=self.center+vec
		self.tl=self.tl+vec
		self.tr=self.tl+vec
		self.bl=self.bl+vec
		self.br=self.br+vec
		self.min=self.tl
		self.max=self.br
	end,
	sub_vector=function(self,vec)
		self.center=self.center-vec
		self.tl=self.tl-vec
		self.tr=self.tl-vec
		self.bl=self.bl-vec
		self.br=self.br-vec
		self.min=self.tl
		self.max=self.br
	end,
	contains_point=function(self,vec)
		if vec.x>self.min.x and vec.x<self.max.x and vec.y>self.min.y and vec.y<self.max.y then return true else return false end
	end,
	closest_point=function(self,vec)
		local min_distance=math.abs(vec.x-self.min.x)
		local p=Vector:new(self.min.x, vec.y)
		if math.abs(self.max.y-vec.y) < min_distance then
			min_distance=math.abs(self.max.y - vec.y)
			p=Vector:new(vec.x, self.max.y)
		end
		if math.abs(self.min.y-vec.y) < min_distance then
			min_distance=math.abs(self.min.y-vec.y)
			p=Vector:new(vec.x, self.min.y)
		end
		if math.abs(self.max.x-vec.x) < min_distance then
			min_distance=math.abs(self.max.x-vec.x)
			p=Vector:new(self.max.x, vec.y)
		end
		return p;
	end
}

--check if something is valid as an item
local function isItem(i)
	if type(i)=="table" then
		if i.body~=nil then
			return true
		else
			return false
		end
	else
		return false
	end
end

function Obj.rect_contains_point(obj,  vec) return vec.x>obj.min.x and vec.x<obj.max.x and vec.y>obj.min.y and vec.y<obj.max.y end

--Minkowski difference
function Obj.m_diff(obj1, obj2)
	if isItem(obj1) and isItem(obj2) then
		return Rect:new{x=obj1.body.min.x-obj2.body.max.x,y=obj1.body.min.y-obj2.body.max.y,w=obj1.w+obj2.w,h=obj1.h+obj2.h}
	end
end

--see if things are colliding
function are_colliding(obj1,obj2)
	if isItem(obj1) and isItem(obj2) then

		local md=Obj.m_diff(obj1,obj2)

		if md:contains_point(orig) then return true end

		return false

	--Or if one isn't an object...
	elseif isItem(obj1) and not isItem(obj2) then --first is? Error the second
		error "Object 2 isn't an item."
	elseif isItem(obj2) and not isItem(obj1) then --first isn't? Error it
		error "Object 1 isn't an item"
	else --Else, neither must be. Error
		error "Neither of those are objects."
	end
end



--For creating tiles, used on indexing drawn backgrounds
Tile={
	x=0,
	y=0,
	w=0,
	h=0,
	c={0,255,255,150},
	c2={255,0,0,255},
	active=false,
	new=function(self,o)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
		shape=Rect:new{x=o.x,y=o.y,w=o.w,h=o.h}
		return o
	end,
	draw=function(self)
	love.graphics.setColor(self.c)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
	love.graphics.setColor(self.c2)
	love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
	end
}

Camera= {
x=0,
y=0,
sx=1,
sy=1,
	new=function(self,o)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
		return o
	end,
	update=function(self)
	love.graphics.scale(1 / self.sx, 1 / self.sy)
  love.graphics.translate(-self.x, -self.y)
	end,
	move=function(self,x,y)
		self.x=self.x+x
		self.y=self.y+0
	end,
	set=function(self,x,y)
		self.x=x
		self.y=y
	end,
	tether=function(self,obj)
		if isItem(obj) then
			self.obj=obj
		else
			error "Object not an item."
		end
	end
}


--Where the magic happens
Level={
	w=love.graphics.getWidth(),
	h=love.graphics.getHeight(),
	timer=0,
	gravity=200, --gravity constant
	new=function(self,o)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
		o.objects={}
		o.tiles={}
		o.active_tiles={}
		if o.w>love.graphics.getWidth() then
			o.hscroll=true
			o.fr=love.graphics.getWidth()
			o.fl=0
		else
			o.hscroll=false
		end
		if o.h>love.graphics.getHeight() then
			o.vscroll=true
			o.ft=0
			o.fb=love.graphics.getHeight()
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
	insert=function(self,objs,cam)
		for i,v in ipairs(objs) do
			if isItem(v) then
				v.absolute_y=self.h
				v.absolute_x=self.w
				table.insert(self.objects,v)
			else
				error "Not an item."
			end
		end
		self.camera=cam or Camera:new{}
	end,
	draw=function(self,co)
	self.camera:update()
		for i,v in ipairs(self.objects) do
			v:draw()
		end
	end,
	detect=function(self,obj)
		for i,v in ipairs(self.objects) do
				if obj~=v and not obj.static then
					if are_colliding(obj,v) then
						obj:collides(v)
					else
						obj:not_colliding()
					end
				end
			end
	end,
	update=function(self,dt,co)
	self:scroll(co)
		for i,v in ipairs(self.objects) do

			if v.is_g_affected then
				self:apply_gravity(dt,v)
			end
			self:detect(v)
			v:update(dt)
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
		if obj.body.bl.y<=obj.absolute_y then
			obj.py=obj.body.tl.y
			obj.y_velocity=obj.y_velocity or 0
			obj.body:translate(Vector:new(obj.body.tl.x,obj.body.tl.y-math.floor(obj.y_velocity*(dt*3))))
			if math.abs(obj.y_velocity)>obj.max_y then
				if obj.y_velocity<0 then
					obj.y_velocity= -obj.max_y
				else
					obj.y_velocity=obj.y_velocity-math.floor(self.gravity*(dt*3))
				end
			else
				obj.y_velocity=obj.y_velocity-math.floor(self.gravity*(dt*3))
			end
		else
			obj.body:translate(Vector:new(obj.body.min.x,obj.absolute_y-obj.h))
		end
	end,
	scroll=function(self,c_obj)
		if isItem(c_obj) then
			if self.camera.x>=0 and self.camera.x<=self.w then
				self.camera:set(0-(love.graphics.getWidth()/2-c_obj.body.center.x),self.camera.y)
			end
			if self.camera.y<=0 and self.camera.y<=self.h then
				self.camera:set(self.camera.x,0-(love.graphics.getHeight()/2-c_obj.body.center.y))
			end
			if self.camera.x<0 then
				self.camera:set(0,self.camera.y)
			end
			if self.camera.x>self.w-love.graphics.getWidth() then
				self.camera:set(self.w-love.graphics.getWidth(),self.camera.y)
			end
			if self.camera.y>0 then
				self.camera:set(self.camera.x,0)
			end
			if self.camera.y<love.graphics.getHeight()-self.h then
				self.camera:set(self.camera.x,love.graphics.getHeight()-self.h)
			end
		end
	end
}

--Individual objects
Item={
	src="",
	name="default",
	x=0,
	y=0,
	w=10,
	h=10,
	max_y=200,
	pc="none",
	pc_t=0,
	static=true,
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
		o.body=Rect:new{x=o.x,y=o.y,w=o.w,h=o.h}
		return o
	end,
	draw=function(self)
		if self.img~=nil then
			love.graphics.setColor(self.dc)
			love.graphics.draw(self.img,self.body.tl.x,self.body.tl.y)
		else
			love.graphics.setColor(self.dc)
			love.graphics.rectangle(self.mode,self.body.tl.x,self.body.tl.y,self.w,self.h)
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
		local md=Obj.m_diff(self,obj)
		local bp=md:closest_point(orig)
		self.body:sub_vector(bp)
		if bp.y<self.body.bl.y --[[and orig.x==self.body.tl.x]] then
			self.y_velocity=0
		end
		if self.body.tl.x<=0 then
			self.body:translate(Vector:new(0,self.body.min.y))
		end
		if self.body.bl.y>=self.absolute_y then
			self.body:translate(Vector:new(self.body.min.x,self.absolute_y-self.h))
		end
		if self.body.tr.x>=self.absolute_x then
			self.body:translate(Vector:new(self.absolute_x-self.w,self.body.min.y))
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
	static=false,
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
		o.body=Rect:new{x=o.x,y=o.y,w=o.w,h=o.h}
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
	static=false,
	jump_height=300,
	max_y=100,
	px=0,
	py=0,
	move=function(self,dt)
		self.px=self.body.tl.x
		self.py=self.body.tl.y
		if love.keyboard.isDown("space") and not self.jumping and self.y_velocity==0 then
			self.jumping=true
			self.y_velocity=self.jump_height
		end
		if love.keyboard.isDown("d") then
			self.body:translate(Vector:new(self.body.tl.x+math.floor(self.speed*dt),self.body.tl.y))
		end
		if love.keyboard.isDown("a") then
			self.body:translate(Vector:new(self.body.tl.x-math.floor(self.speed*dt),self.body.tl.y))
		end
		if self.body.tl.x<0 then
			self.body:translate(Vector:new(0,self.body.tl.y))
		end
		if self.body.bl.y<0 then
			self.body:translate(Vector:new(self.body.tl.x,0))
		end
		if self.body.bl.y>self.absolute_y then
			self.body:translate(Vector:new(self.body.tl.x,self.absolute_y-self.h))
			self.jumping=false
			self.ground=self.absolute_y-self.h
			self.y_velocity=0
		end
		if self.body.tr.x>self.absolute_x then
			self.body:translate(Vector:new(self.absolute_x-self.w,self.body.tl.y))
		end
	end,
	collides=function(self,obj)
		self.c={255,0,0,150}
		local md=Obj.m_diff(self,obj)
		local bp=md:closest_point(orig)
		self.body:sub_vector(bp)
		if bp.y<self.body.bl.y  and bp.x==0 and self.body.tl.y~=obj.body.bl.y and self.py<=self.body.tl.y then
			self.jumping=false
			self.ground=bp.y-self.h
			self.y_velocity=0
		end
		if self.body.bl.y==obj.body.tl.y then
			self.body:translate(Vector:new(self.body.min.x,obj.body.tl.y-self.h))
		end
		if self.body.tl.y==obj.body.bl.y and (self.py>=self.body.tl.y) then
			self.y_velocity=0
		end
	end,
	not_colliding=function(self)
		self.c={255,255,255,150}
	end,
	update=function(self,dt)
		self:move(dt)
	end
}

return Obj