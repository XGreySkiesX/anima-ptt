local Sprs={}

td=0
asprites={}

AnimSprite={
  type="animated",
	ind=false,
	x=0,
	y=0,
	new=function(self,o)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
    o.txt=""
		o.timer=0
		o.sprs={}
		o.sheet=love.graphics.newImage(o.src)
		for i,v in pairs(o.qs) do
      o.txt=o.txt..i
			if #o.sprs<1 then
				o.tp=i
				o.ptp=i
			end
			o.sprs[i]={}
			for w,x in pairs(v) do
				table.insert(o.sprs[i],love.graphics.newQuad(x[1], x[2], x[3], x[4], o.sheet:getWidth(), o.sheet:getHeight()))
			end
		end
		table.insert(asprites,o)
		return o
	end,
	update=function(self,dt)
		if dt then
			self.timer=self.timer+dt
			if self.ptp~=self.tp then
				self.timer=0
			end
		else
			self.timer=td
		end
		if self.upd_func~=nil then
			self:upd_func(dt)
		end
	end,
	draw=function(self,x,y,dt)
		love.graphics.setColor(1,1,1,1)
		self.x=x or self.x
		self.y=y or self.y
    if self.tp~="" or self.sprs[self.tp][1]~=nil then
			love.graphics.draw(self.sheet,self.sprs[self.tp][math.floor((self.timer*10)*(self.spd or .5)%#self.sprs[self.tp])+1], x or self.x, y or self.y)
		else
			error( "Something went wrong with the tp. Current tp: "..self.tp )
		end
	end,
	reset_timer=function(self)
		self.timer=0
	end,
	set_speed=function(self,spd)
		self.spd=spd
	end,
	translate=function(self,x,y)
	if (x or 0)<0 then
		self.x=self.x-(math.abs(x or 0))
	elseif (x or 0)>0 then
		self.x=self.x+(x or 0)
	end
	if (y or 0)<0 then
		self.y=self.y-(math.abs(y or 0))
	elseif (y or 0)>0 then
		self.y=self.y+(y or 0)
	end

	end,
	setpos=function(self,x,y)
	self.x=(x or self.x)
	self.y=(y or self.y)
	end
}

StaticSprite={
  type="static",
  x=0,
  y=0,
  new=function(self,o)
    local o=o or {}
		setmetatable(o,self)
		self.__index=self
    o.sheet=love.graphics.newImage(o.src)
    o.sprs={}
    for i,v in ipairs(o.qs) do
      sprs[i]=love.graphics.newQuad(v[1], v[2], v[3], v[5], o.sheet:getWidth(), o.sheet:getHeight())
    end
    o.tp=1
    return o
  end,
  draw=function(self,x,y,tp)
  	love.graphics.setColor(1,1,1,1)
  	if tp then
  		if self.sprs[tp][1]~=nil then self.tp=tp end
  	else
  		if not self.sprs[self.tp]~=nil then self.tp=1 end
  	end
    love.graphics.draw(self.sheet,self.sprs[self.tp],x or self.x,y or self.y)
  end
}

function Sprs.update(dt)
	for i,v in ipairs(asprites) do
		if v.ind then
			v:update(dt)
		else
			v:update()
		end
	end
end

return Sprs
