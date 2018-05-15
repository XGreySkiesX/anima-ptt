require "C.shapes"
require "C.sprites"

Entity={
	src="",
	mode="fill",
	name="default",
	x=0,
	y=0,
	w=10,
	h=10,
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
			--do stuff w/ type: if type==table then make a static or anim sprite; if type==string then just make a regular image
				o.img=love.graphics.newImage(o.src)
				o.w=o.img:getWidth()
				o.h=o.img:getHeight()
		end
		o.jumping=false
		o.body=Rect:new{x=o.x,y=o.y,w=o.w,h=o.h}
		return o
	end,
	draw=function(self,tp)
		if self.img~=nil then
			love.graphics.setColor(self.c)
			love.graphics.draw(self.img,self.body.tl.x,self.body.tl.y)
		elseif self.sprite~=nil then
			love.graphics.setColor(self.c)
			self.sprite:draw(self.body.tl.x,self.body.tl.y,tp or nil)
		else
			love.graphics.setColor(self.c)
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
		self.text="Colliding with "..obj.name
		local md=Obj.m_diff(self,obj)
		local bp=md:closest_point(orig)
		self.body:sub_vector(bp)
		if bp.y<self.body.bl.y then
			self.y_velocity=0
		end
	end,
	not_colliding=function(self)
		self.text="Not colliding"
	end,
	update=function(self,dt)
		if self.body.tl.x<=0 then
			self.body:translate(Vector:new(0,self.body.min.y))
		end
		if self.body.bl.y>=self.absolute_y then
			self.body:translate(Vector:new(self.body.min.x,self.absolute_y-self.h))
		end
		if self.body.tr.x>=self.absolute_x then
			self.body:translate(Vector:new(self.absolute_x-self.w,self.body.min.y))
		end
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
			if self.jumping then
				self.sprite.ptp=self.sprite.tp
				self.sprite.tp="idler"
			else
				self.sprite.ptp=self.sprite.tp
				self.sprite.tp="right"
			end
		end
		if love.keyboard.isDown("a") then
			self.body:translate(Vector:new(self.body.tl.x-math.floor(self.speed*dt),self.body.tl.y))
			if self.jumping then
				self.sprite.ptp=self.sprite.tp
				self.sprite.tp="idlel"
			else
				self.sprite.ptp=self.sprite.tp
				self.sprite.tp="left"
			end
		end
		if not (love.keyboard.isDown("a") or love.keyboard.isDown("space") or love.keyboard.isDown("d")) then
			if self.sprite.ptp=="left" then
				self.sprite.tp="idlel"
				self.sprite.ptp="idlel"
			elseif self.sprite.ptp=="right" then
				self.sprite.tp="idler"
				self.sprite.ptp="idler"
			end
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
