Entity=Item:new{
	c={255,255,255,255},
	src="",
	static=false,
	dead=false,
	is_g_affected=true,
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
		o.body=Rect:new{x=o.x,y=o.y,w=o.w,h=o.h}
		return o
	end
}

Player=Entity:new{
	num=1,
	dead=false,
	speed=200,
	type="player",
	jumping=false,
	colliding=false,
	y_velocity=0,
	ground=0,
	static=false,
	jump_height=300,
	max_y=10,
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
		if self.body.tl.y<0 then
			self.body:translate(Vector:new(self.body.tl.x,0))
			self.y_velocity=0
		end
		if self.body.bl.y>=self.absolute_y then
			self.body:translate(Vector:new(self.body.tl.x,self.absolute_y-self.h))
			self.jumping=false
			self.ground=self.absolute_y-self.h
			self.y_velocity=0
		end
		if self.body.max.x>self.absolute_x then
			self.body:translate(Vector:new(self.absolute_x-self.w,self.body.tl.y))
		end
	end,
	collides=function(self,obj)
	if obj.type=="enemy" then
		self.dead=true
		return
	end
	if not self.dead then
		local md=Objects.m_diff(self,obj)
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
	end
	end,
	not_colliding=function(self)
		return
	end,
	update=function(self,dt)
	if not self.dead then
		self:move(dt)
	end
	end
}

Enemy=Entity:new{
	type="enemy",
	collides=function(self,obj)
		if obj.type=="player" then
			return
		end
		local md=Objects.m_diff(self,obj)
		local bp=md:closest_point(orig)
		self.body:sub_vector(bp)
		if bp.y<self.body.bl.y then
			self.y_velocity=0
		end
	end
}