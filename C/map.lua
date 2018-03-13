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

--[[AnimatedTile=Tile:new{
	timer=0,
	draw=function(self,sheet)
	self.timer=self.timer+1
	love.graphics.draw
	end
}]]

Map={
	tilesize=32,
	bgdrawn=false,
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
							curtile.w,curtile.h,curtile.q,curtile.drawtop,curtile.isplat=o.sheet[i].handle(o.sheet[i],pix,above,below,left,right)
							curtile.x=x*o.tilesize
							curtile.y=y*o.tilesize
							o.consectiles=o.consectiles+1
							break
						end
						curtile={}
					end
					if curtile.type~=nil then
						if curtile.drawtop then
							o:add_tile(curtile.x,curtile.y-o.sheet[curtile.type].coords.top[4],curtile.w,curtile.h,o.sheet[curtile.type].img,o.sheet[curtile.type].coords.top,curtile.type)
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
					o:add_tile(curtile.x,curtile.y,curtile.w,curtile.h,o.sheet[curtile.type].img,curtile.q,curtile.type)
					elseif curtile.type==nil then
						o.consectiles=0
					end
				end
			end
		end
		o.isLoaded=true
		return o
		end,
		add_tile=function(self,x,y,w,h,img,q,type)
			table.insert(self.tiles,Tile:new{x=x,y=y,w=w,h=h,imgsrc=img,q=q,type=type})
		end,
		draw=function(self)
			for i,v in ipairs(self.tiles) do
				if v.quad==nil then
					if v.img==nil then
						v.img=love.graphics.newImage(v.imgsrc)
					end
					v.quad=love.graphics.newQuad(v.q[1],v.q[2],v.q[3],v.q[4],v.img:getWidth(),v.img:getHeight())
				end
				love.graphics.draw(v.img,v.quad,v.x,v.y)
			end
		end
}