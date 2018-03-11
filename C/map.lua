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
		o.img=love.graphics.newImage(o.imgsrc)
		o.quad=love.graphics.newQuad(o.q[1],o.q[2],o.q[3],o.q[4],o.img:getWidth(),o.img:getHeight())
		return o
	end,
	draw=function(self)
		love.graphics.draw(self.img,self.quad,self.x,self.y)
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
		local consectiles=0
		for y=0,o.h-1 do
			for x=0,o.w-1 do
				local pix={}
				pix.r,pix.g,pix.b,pix.a=o.img:getPixel(x,y)
				for i,v in pairs(o.sheet.colors) do
					local curtile={}
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
						curtile.isplat=false
						curtile.w,curtile.h,curtile.q,curtile.drawtop,curtile.isplat=o.sheet[i].handle(o.sheet[i],pix,above,below,left,right)
						curtile.x=x*o.tilesize
						curtile.y=y*o.tilesize

						o.curtilex=curtile.q[1]
					end
					if curtile.q~=nil then
						if curtile.drawtop then
							o:add_tile(curtile.x,curtile.y-o.tilesize,curtile.w,curtile.h,o.sheet[curtile.type].img,o.sheet[curtile.type].coords.top)
						end
						if curtile.isplat then
							consectiles=consectiles+1
							if consectiles>1 and #o.platforms>0 then
								if curtile.type==o.platforms[#o.platforms].type then
									o.platforms[#o.platforms].w=o.platforms[#o.platforms].w+curtile.w
								else
									table.insert(o.platforms,curtile)
								end
							else
								table.insert(o.platforms,curtile)
							end
						else
							consectiles=0
						end
					o:add_tile(curtile.x,curtile.y,curtile.w,curtile.h,o.sheet[curtile.type].img,curtile.q)
					else
						consectiles=0
					end
				end
			end
		end
		o.isLoaded=true
		return o
		end,
		add_tile=function(self,x,y,w,h,img,q)
			table.insert(self.tiles,Tile:new{x=x,y=y,w=w,h=h,imgsrc=img,q=q})
		end,
		draw=function(self,sh)
			for i,v in pairs(self.tiles) do
				v:draw()
			end
		end,
		drawbg=function(self,sh)
		if #self.bg_tiles>1 then
			for i,v in pairs(self.bg_tiles) do
				v:draw(sh)
			end
		end
		self.bgdraw=true
		end
}
