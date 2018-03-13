local Obj={}
--check if something is valid as an item
function Obj.isItem(i)
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
	if Obj.isItem(obj1) and Obj.isItem(obj2) then
		return Rect:new{x=obj1.body.min.x-obj2.body.max.x,y=obj1.body.min.y-obj2.body.max.y,w=obj1.w+obj2.w,h=obj1.h+obj2.h}
	end
end

--see if things are colliding
function Obj.are_colliding(obj1,obj2)
	if Obj.isItem(obj1) and Obj.isItem(obj2) then

		local md=Obj.m_diff(obj1,obj2)

		if md:contains_point(orig) then return true end

		return false

	--Or if one isn't an object...
	elseif Obj.isItem(obj1) and not Obj.isItem(obj2) then --first is? Error the second
		error "Object 2 isn't an item."
	elseif Obj.isItem(obj2) and not Obj.isItem(obj1) then --first isn't? Error it
		error "Object 1 isn't an item"
	else --Else, neither must be. Error
		error "Neither of those are objects."
	end
end

Camera={
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
	if self.obj~=nil then
		self.x=self.obj.body.center.x-(love.graphics.getWidth()/2)
		self.y=self.obj.body.center.y-(love.graphics.getHeight()/2)
	end
	love.graphics.scale(self.sx, self.sy)
	love.graphics.translate(-self.x, -self.y)
	end,
	pan=function(self,x,y)
		self.x=self.x+x
		self.y=self.y+y
	end,
	set=function(self,x,y)
		self.x=x
		self.y=y
	end,
	tether=function(self,obj)
		if Obj.isItem(obj) then
			self.obj=obj
		else
			error "Object not an item."
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
	rotation=0,
	sx=1,
	sy=1,
	max_y=200,
	pc="none",
	pc_t=0,
	static=true,
	absolute_y=love.graphics.getHeight(),
	absolute_x=love.graphics.getWidth(),
	text="Not colliding...",
	c={255,0,0,255},
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
			love.graphics.setColor(self.c)
			love.graphics.draw(self.img,self.body.tl.x,self.body.tl.y)
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

Platform=Item:new{
	type="platform",
	is_g_affected=false,
	update=function(self) end,
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
			o.drawable=love.graphics.newMesh({
				{0,0,0,0,o.c[1],o.c[2],o.c[3],o.c[4]},
				{o.w,0,1,0,o.c[1],o.c[2],o.c[3],o.c[4]},
				{o.w,o.h,1,1,o.c[1],o.c[2],o.c[3],o.c[4]},
				{0,o.h,0,1,o.c[1],o.c[2],o.c[3],o.c[4]}},
				"fan")
			return o
		end,
	draw=function(self)
		love.graphics.draw(self.drawable,self.body.tl.x,self.body.tl.y)
	end
}

Ground=Platform:new{type="ground",update=function(self) end}

return Obj
