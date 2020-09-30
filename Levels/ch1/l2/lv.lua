local ch1l2={
bgsrc="Levels/ch1/l2/bg.png",
lvsrc="Levels/ch1/l2/level.png",
tile_sources={grass="Levels.ch1.shared.Graphics.Tiles.grass",platform1="Levels.ch1.shared.Graphics.Tiles.platform1",sky3="Levels.ch1.shared.Graphics.Tiles.sky3"},
lvname="ch1l2",
setup=function(self)
self.thread=love.thread.newThread([[
	require('C.tilesheets')
	require('C.map')
	require('love.image')
	local lvsrc,tsrcs,lvname=...
	local tilesheet=TSheet:new{srcs=tsrcs}

	local map=Map:new{src=lvsrc,sheet=tilesheet}
	love.thread.getChannel('mp_t_'..lvname):push(map.tiles)
	love.thread.getChannel('mp_p_'..lvname):push(map.platforms)

	]])
self.map=Map:new{src=self.lvsrc,initialize=false}
self.tilesheet=TSheet:new{src=self.ts_source}
self.shader=love.graphics.newShader(self.scode)
self.shader:send("screenWidth",self.w)
self.thread:start(self.lvsrc,self.tile_sources,self.lvname)
end,

load=function(self)
	print 'starting load'
	local channels={}
	-- channels.a=love.thread.getChannel('bgm_t_'..self.lvname):pop()
	channels.b=love.thread.getChannel('mp_t_'..self.lvname):pop()
	channels.c=love.thread.getChannel('mp_p_'..self.lvname):pop()
	if channels.b and channels.c then
		print('channels popped')
		--self.bgmap.tiles=channels.a
		self.map.tiles=channels.b
		print(self.map.tiles[0])
		self.map.platforms=channels.c
		self.w=self.map.w*self.map.tilesize
		self.h=self.map.h*self.map.tilesize
		local cc=255
		for i,v in ipairs(self.map.platforms) do
			v.c={cc,255,255,150}
			table.insert(self.objects,Platform:new{x=v.x,y=v.y,w=v.w,h=v.h,c=v.c})
			print(i)
			cc=cc-10
		end
		-- for i,v in ipairs(self.bgm_srcs) do
		-- 	table.insert(self.soundlist,Song:new{src=v[1],loopstart=v[2],loopend=v[3],isloop=true})
		-- end
		self.shader=love.graphics.newShader(self.scode)
		self:msg_init()
		self.tmr=0
		-- self.soundlist[1]:play(.3)
		self.thread=nil
		self.loaded=true
	elseif channels.b and not channels.c then
		print('50%')
		self.progress=50
	end
end,

upd_func=function(self)
self.shader:send("offset",self.camera.x)
end,

objects={
	Player:new{
	x=100,
	y=900,
	w=32,
	h=64,
	gravity=100,
	y_velocity=0,
	max_y=200,
	speed=200,
	name="player",
	ground=0,
	src="Levels/ch1/shared/Graphics/Sprites/player.png",
	jump_height=210
	}
	
},

sh_coords={dirt={0,0,16,16},grass={16,16,16,16}},

--[[enemies={
	Enemy:new{x=310,y=500}
},]]

flags={
	dead=Flag:new{}
},
handleflags=function(self)
	if self:player_dead(1) then
		self.flags.dead:set(true)
	end
end,
camera=Camera:new{},
msgs={
	[1]=TextBox:new{
	x=0,y=600,w=love.graphics.getWidth(),
	string=Strings.ch1.l1[1],
	c={0,0,100/255,150/255},tc={1,1,1,1},
	delay=0.1
	},
	[2]=TextBox:new{
	x=0,y=600,w=love.graphics.getWidth(),
	string=Strings.ch1.l1[2],
	c={0,0,100/255,150/255},
	tc={1,1,1,1},
	delay=0.1
	}
},
scode=[[
extern number screenWidth;
extern number offset;
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 window_coords ){
vec4 pix=Texel(texture,texture_coords);
vec4 result;
if(pix.r==0.0 && pix.g==1.0 && pix.b==1.0){
	pix.a=0.0;
	return pix;
}
  if(window_coords.x > screenWidth/2-offset){
  	result.r=pix.r;
  	result.g=pix.g*.5;
  	result.b=pix.b*.5;
  	result.a=pix.a;
  }
  else
  {
    result.r=pix.r*.5;
    result.g=pix.g*.5;
    result.b=pix.b;
    result.a=pix.a;
  }
  return result;
}
  ]]

}

return ch1l2