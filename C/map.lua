Tile={
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
							curtile.x=x*o.tilesize
							curtile.y=y*o.tilesize
							o.consectiles=o.consectiles+1
							break
						end
						curtile={}
					end
					if curtile.type~=nil then
						if curtile.drawtop then
							o:add_tile(curtile.x,curtile.y-o.sheet[curtile.type].coords.top[4],curtile.w,curtile.h,o.sheet[curtile.type].img,o.sheet[curtile.type].coords.top,curtile.type,curtile.shader)
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
				end
			end
		end
		o.isLoaded=true
		return o
		end,
		add_tile=function(self,x,y,w,h,img,q,type,shader)
			table.insert(self.tiles,Tile:new{x=x,y=y,w=w,h=h,imgsrc=img,q=q,type=type,shc=shader or [[
					vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
					  	vec4 pixel = Texel(texture, texture_coords );
					  	if (pixel.r==0.0 && pixel.g==1.0 && pixel.b==1.0){
							pixel.a=0.0;
					  	}
						return pixel;
					}
				]]})
		end,
		draw=function(self)
			for i,v in ipairs(self.tiles) do
				if v.quad==nil then
					if v.img==nil then
						v.img=love.graphics.newImage(v.imgsrc)
					end
					v.quad=love.graphics.newQuad(v.q[1],v.q[2],v.q[3],v.q[4],v.img:getWidth(),v.img:getHeight())
				end
				if v.shader==nil then
					v.shader=love.graphics.newShader(v.shc)
				end
				love.graphics.setShader(v.shader)
				love.graphics.draw(v.img,v.quad,v.x,v.y)
				love.graphics.setShader()
			end
		end
}
