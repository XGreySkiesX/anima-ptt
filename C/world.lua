Level={
	timer=0,
	src="",
	bgsrc="",
	lvsrc="",
	loaded=false,
	tdone=false,
	adv=0,
	sheet_coords={},
	shader=love.graphics.newShader([[
	  vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );
      /*if (pixel.r==0.0 && pixel.g==1.0 && pixel.b==1.0){
				pixel.a=0.0;
			}*/
			return pixel;
    }
	]]),
	handleflags=function(self)
	end,
	upd_func=function(self)
	end,
	gravity=200, --gravity constant
	new=function(self,o)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
		o.objects={}
		o.msgs={}
		if o.src~="" then
			local fl=require("Levels."..o.src)
			for i,v in pairs(fl) do
				o[i]=v
			end
		end
			o.img=love.graphics.newImage(o.lvsrc)
			o.w=o.img:getWidth()*32
			o.h=o.img:getHeight()*32
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
		if #o.msgs<1 then
			o.tdone=true
		end
		for i,v in ipairs(o.objects) do
			if v.type=="player" then
				o.player=v
			end
			v.absolute_y=o.h
			v.absolute_x=o.w
		end
		return o
	end,
	setup=function(self)
		return
	end,
	insert=function(self,objs,cam)
		for i,v in ipairs(objs) do
			if Objects.isItem(v) then
				v.absolute_y=self.h
				v.absolute_x=self.w
				table.insert(self.objects,v)
			else
				error "Not an item."
			end
		end
		if self.camera==nil then self.camera=cam or Camera:new{} end
	end,
	draw=function(self,co)
		if not self.loaded then return end
	love.graphics.push()
	love.graphics.setShader(self.shader)
	if self.camera~=nil then
		self.camera:update()
	end
		self.bgmap:draw()
		self.map:draw()

		self.player:draw()
		love.graphics.setShader()
		love.graphics.pop()
		if not self.tdone and self.adv>0 then
   	 		self.msgs[self.adv]:draw()
  		end
	end,
	detect=function(self,obj)
		for i,v in ipairs(self.objects) do
				if obj~=v and not obj.static then
					if Objects.are_colliding(obj,v) then
						obj:collides(v)
					else
						obj:not_colliding()
					end
				end
			end
	end,
	update=function(self,dt)
		if not self.loaded then return end
	self:scroll(self.player)
	self:handleflags()
		for i,v in ipairs(self.objects) do
			if self.tdone then
				v:update(dt)
			end
			if v.is_g_affected then
				self:apply_gravity(dt,v)
			end
			
				self:detect(v)
				
		end
		self:msg_upd(dt)
		self:upd_func()
	end,
	keys=function(self,key)
		if key=="a" and not self.tdone then
			if self.msgs[self.adv].td then
		      self.msgs[self.adv].advance:play()
		      self.msgs[self.adv]:hide()
		      self.msgs[self.adv]:reset()
		      self.adv=self.adv+1
		    else
		      self.msgs[self.adv].delay=0.005
		    end
		end
	end,
	msg_init=function(self)
	self.tdone=false
	self.adv=1
	end,
	msg_upd=function(self,dt)
		if not self.tdone and self.adv>0 then
	    if self.adv<=#self.msgs then
	      if self.msgs[self.adv].active and not self.msgs[self.adv].hidden then
	        self.msgs[self.adv]:update(dt)
	      else
	        self.msgs[self.adv]:show()
	      end
	    else
	      self.tdone=true
  		  self.adv=0
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
		if obj.body.bl.y<obj.absolute_y then
			obj.py=obj.body.tl.y
			if obj.y_velocity < -(obj.max_y) then
					obj.y_velocity= 0-obj.max_y
			else
				obj.y_velocity=obj.y_velocity-math.floor(self.gravity*(dt*3))
			end
			obj.body:translate(Vector:new(obj.body.tl.x,obj.body.tl.y-math.floor(obj.y_velocity*(dt*3))))
		else
			obj.body:translate(Vector:new(obj.body.min.x,obj.absolute_y-obj.h))
			obj.y_velocity=0
		end
	end,
	scroll=function(self,c_obj)
		if Objects.isItem(c_obj) and self.camera~=nil and (self.hscroll or self.vscroll) then
			if self.camera.x>=0 and self.camera.x<=(self.w-love.graphics.getWidth())*self.camera.sx then
			self.camera:set((c_obj.body.center.x-love.graphics.getWidth()/2),self.camera.y)
		end
		if self.camera.y>=0 and self.camera.y<=(self.h-love.graphics.getHeight())*self.camera.sy then
			self.camera:set(self.camera.x,(c_obj.body.center.y-love.graphics.getHeight()/2))
		end
		if self.camera.x<0 then
			self.camera:set(0,self.camera.y)
		end
		if self.camera.x>(self.w-love.graphics.getWidth())*self.camera.sx then
			self.camera:set((self.w-love.graphics.getWidth())*self.camera.sx,self.camera.y)
		end
		if self.camera.y<0 then
			self.camera:set(self.camera.x,0)
		end
		if self.camera.y>(self.h-love.graphics.getHeight())*self.camera.sy then
			self.camera:set(self.camera.x,(self.h-love.graphics.getHeight())*self.camera.sy)
		end
			self.camera:update()
		end
	end,
	player_dead=function(self,pln)
		local pln=pln or 1
		for i,v in ipairs(self.objects) do
			if v.type=="player" then
				if v.num==pln and v.dead then
					return true
				end
			end
		end
		return false
	end
}
