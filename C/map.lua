STile={
	x=0,
	y=0,
	w=32,
	h=32,
	type="",
	new=function(self,o)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
		return o
	end
}

ATile=STile:new{
	animated=true,
	timer=0,
	update=function(self)
		self.timer=td
		if self.upd_func~=nil then
			self.upd_func()
		end
	end
}

Map={
	tilesize=32,
	isLoaded=false,
	initialize=true,
	new=function(self,o)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
		o.bg_tiles={}
		o.tiles={}
		o.platforms={}
		o.img=love.image.newImageData(o.src)
		o.w=o.img:getWidth()
		o.h=o.img:getHeight()
		o.progress=0
		o.max_progress=(o.h*o.w)
		o.sheet=o.sheet
		if o.initialize then
			o.consectiles=0
			for y=0,o.h-1 do
				for x=0,o.w-1 do
					local pix={}
					local curtile={}
					pix.r,pix.g,pix.b,pix.a=o.img:getPixel(x,y)
					for i,v in pairs(o.sheet.colors) do
						if pix.r==v.r and pix.g==v.g and pix.b==v.b then
							local above,below,left,right
							if y~=0 then
								above={}
							above.r,above.g,above.b,above.a=o.img:getPixel(x,y-1)
							else
								above={}
								above.r,above.g,above.b,above.a=0,0,0,0
							end
							if y~=o.img:getHeight()-1 then
								below={}
							below.r,below.g,below.b,below.a=o.img:getPixel(x,y+1)
							else
								below={}
								below.r,below.g,below.b,below.a=0,0,0,0
							end
							if x~=0 then
								left={}
							left.r,left.g,left.b,left.a=o.img:getPixel(x-1,y)
							else
								left={}
								left.r,left.g,left.b,left.a=0,0,0,0
							end
							if x~=o.img:getWidth()-1 then
								right={}
							right.r,right.g,right.b,right.a=o.img:getPixel(x+1,y)
							else
								right={}
								right.r,right.g,right.b,right.a=0,0,0,0
							end

							curtile.type=i
							curtile.w,curtile.h,curtile.q,curtile.drawtop,curtile.isplat,curtile.shader=o.sheet[i].handle(o.sheet[i],pix,above,below,left,right)
							curtile.x=x*o.tilesize*(curtile.w/o.tilesize)
							curtile.y=y*o.tilesize*(curtile.w/o.tilesize)
							o.consectiles=o.consectiles+1
							break
						end
						curtile={}
					end
					if curtile.type~=nil then
						if curtile.drawtop then
							if type(o.sheet[curtile.type].coords.top[1])=="table" then
								o:add_tile(curtile.x,curtile.y-o.sheet[curtile.type].coords.top[1][4],curtile.w,curtile.h,o.sheet[curtile.type].img,o.sheet[curtile.type].coords.top,curtile.type,curtile.shader)
							else
								o:add_tile(curtile.x,curtile.y-o.sheet[curtile.type].coords.top[4],curtile.w,curtile.h,o.sheet[curtile.type].img,o.sheet[curtile.type].coords.top,curtile.type,curtile.shader)
							end
						end
						if curtile.isplat then
							if o.consectiles>1 and #o.platforms>0 then
								if o.platforms[#o.platforms].type==curtile.type then
									o.platforms[#o.platforms].w=o.platforms[#o.platforms].w+curtile.w
								else
									table.insert(o.platforms,{x=curtile.x,y=curtile.y,w=curtile.w,h=curtile.h,type=curtile.type})
									o.curtilex=o.consectiles
									o.consectiles=1

								end
							else
								table.insert(o.platforms,{x=curtile.x,y=curtile.y,w=curtile.w,h=curtile.h,type=curtile.type})
								o.curtilex=o.consectiles
								o.consectiles=1

							end
						else
							o.consectiles=0
						end
					o:add_tile(curtile.x,curtile.y,curtile.w,curtile.h,o.sheet[curtile.type].img,curtile.q,curtile.type,curtile.shader)
					elseif curtile.type==nil then
						o.consectiles=0
					end
					o.progress=o.progress+1
					if x%8==0 then
						coroutine.yield(o.progress,o.max_progress)
					end
				end
			end
		end
		o.isLoaded=true
		return o
		end,
		add_tile=function(self,x,y,w,h,img,q,tp,shader,updf)
			if type(q[1])=="table" then
				table.insert(self.tiles,ATile:new{x=x,y=y,w=w,h=h,imgsrc=img,q=q,type=tp,shc=shader or [[
					vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
					  	vec4 pixel = Texel(texture, texture_coords );
					  	if (pixel.r==0.0 && pixel.g==1.0 && pixel.b==1.0){
							pixel.a=0.0;
					  	}
						return pixel;
					}

				]],upd_func=updf or nil})
			else
				table.insert(self.tiles,STile:new{x=x,y=y,w=w,h=h,imgsrc=img,q=q,type=tp,shc=shader or [[
					vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
					  	vec4 pixel = Texel(texture, texture_coords );
					  	if (pixel.r==0.0 && pixel.g==1.0 && pixel.b==1.0){
							pixel.a=0.0;
					  	}
						return pixel;
					}

				]],upd_func=updf or nil})
			end
		end,
		draw=function(self)
			for i,v in ipairs(self.tiles) do
				if v.animated or type(v.q[1])=="table" then
					if v.qs==nil then
						v.qs={}
						if v.img==nil then
							v.img=love.graphics.newImage(v.imgsrc)
						end
						for _,s in ipairs(v.q) do
							table.insert(v.qs,love.graphics.newQuad(s[1],s[2],s[3],s[4],v.img:getWidth(),v.img:getHeight()))
						end
					end
					if v.shader==nil then
						v.shader=love.graphics.newShader(v.shc)

					end
					love.graphics.setShader(v.shader)
					love.graphics.draw(v.img,v.qs[math.floor((td*10)*.5%#v.qs)+1],v.x,v.y)
					love.graphics.setShader()
				else
					if v.qs==nil then
						if v.img==nil then
							v.img=love.graphics.newImage(v.imgsrc)
						end
						v.qs=love.graphics.newQuad(v.q[1],v.q[2],v.q[3],v.q[4],v.img:getWidth(),v.img:getHeight())
					end
					if v.shader==nil then
						v.shader=love.graphics.newShader(v.shc)
					end
					love.graphics.setShader(v.shader)
					love.graphics.draw(v.img,v.qs,v.x,v.y)
					love.graphics.setShader()
				end
			end
		end
}
