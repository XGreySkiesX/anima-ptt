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
	__concat=function(v1,v2)
		return v1.x..", "..v1.y..v2
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

orig=Vector:new(0,0)

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