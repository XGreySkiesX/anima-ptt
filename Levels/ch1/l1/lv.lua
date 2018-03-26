local ch1l1={
progress=0,
bgsrc="Levels/ch1/l1/bg.png",
lvsrc="Levels/ch1/l1/level.png",
lvname="ch1l1",
tile_sources={grass="Levels.ch1.shared.Graphics.Tiles.grass",platform1="Levels.ch1.shared.Graphics.Tiles.platform1",sky3="Levels.ch1.shared.Graphics.Tiles.sky3"},
bgm_srcs={{"M/Audio/Music/test.wav",83.6,131.7},{"M/Audio/Music/8BitMain.ogg",48,77.35}},
tdone=true,
setup=function(self)
self.thread=love.thread.newThread([[
	require('C.tilesheets')
	require('C.map')
	require('love.image')
	local bgsrc,lvsrc,tsrcs,lvname=...
	local tilesheet=TSheet:new{srcs=tsrcs}
	local bgmap=Map:new{src=bgsrc,sheet=tilesheet}
	love.thread.getChannel('bgm_t_'..lvname):push(bgmap.tiles)

	local map=Map:new{src=lvsrc,sheet=tilesheet}
	love.thread.getChannel('mp_t_'..lvname):push(map.tiles)
	love.thread.getChannel('mp_p_'..lvname):push(map.platforms)

	]])
self.tilesheet=TSheet:new{srcs=tile_sources}
self.map=Map:new{src=self.lvsrc,initialize=false}
self.bgmap=Map:new{src=self.bgsrc,initialize=false}
self.thread:start(self.bgsrc,self.lvsrc,self.tile_sources,self.lvname)
end,
load=function(self)
		local channels={}
		channels.a=love.thread.getChannel('bgm_t_'..self.lvname):pop()
		channels.b=love.thread.getChannel('mp_t_'..self.lvname):pop()
		channels.c=love.thread.getChannel('mp_p_'..self.lvname):pop()
		if channels.a and channels.b and channels.c then
			self.bgmap.tiles=channels.a
			self.map.tiles=channels.b
			self.map.platforms=channels.c
			self.w=self.map.w*self.map.tilesize
			self.h=self.map.h*self.map.tilesize
			local cc=255
			for i,v in ipairs(self.map.platforms) do
				v.c={cc,255,255,150}
				table.insert(self.objects,Platform:new{x=v.x,y=v.y,w=v.w,h=v.h,c=v.c})
				cc=cc-10
			end
			for i,v in ipairs(self.bgm_srcs) do
				table.insert(self.soundlist,Song:new{src=v[1],loopstart=v[2],loopend=v[3],isloop=true})
			end
			self.shader=love.graphics.newShader(self.scode)
			self:msg_init()
			self.tmr=0
			self.soundlist[1]:play(.3)
			self.thread=nil
			self.loaded=true
		elseif channels.a and not channels.b then
			self.progress=30
		elseif channels.a and channels.b then
			self.progress=60
		end
end,
upd_func=function(self)
self.tmr=self.tmr+love.timer.getDelta()
self.shader:send("p_coords",{self.player.body.center.x,self.player.body.center.y,0})
self.shader:send("offset",{self.camera.x,self.camera.y,0})
self.shader:send("timer",self.tmr)
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
	},
	Platform:new{
		static=false,
		is_g_affected=true,
		y=700,
		x=500,
		w=50,
		h=50,
		c={255,255,255,255},
		type="crate"
	}
},
msgs={
	[1]=TextBox:new{
	x=0,y=love.graphics.getHeight(),w=love.graphics.getWidth(),
	string=Strings.ch1.l1[1],
	c={0,0,100,150},tc={255,255,255,255},
	delay=0.1
	},
	[2]=TextBox:new{
	x=0,y=love.graphics.getHeight(),w=love.graphics.getWidth(),
	string=Strings.ch1.l1[2],
	c={0,0,100,150},
	tc={255,255,255,255},
	delay=0.1
	}
},
camera=Camera:new{},
scode=[[
extern vec2 p_coords;
extern vec2 offset;
extern number timer;
float random (vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);
}
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 window_coords ){
vec4 pix=Texel(texture,texture_coords);
if(pix.r==0.0 && pix.g==1.0 && pix.b==1.0){
pix.a=0.0;
}
if((pix.r==1.0 && pix.g==1.0 && pix.b==1.0)){
	pix.rgb=vec3( abs( random(window_coords/timer)*(abs(sin(timer/2))<.5 ? .5 : abs(sin(timer/2))) ) );
	//pix.rgb=vec3( random(window_coords/timer) );
}else if (pix.r==1.0 && pix.g==0.0 && pix.b==0.0){
	pix.r=( abs(tan(timer/2))<.3 ? .3 : abs(tan(timer/2)) );
} else {
	pix.rgb=(pix.rgb/5)/clamp((distance(window_coords,p_coords-offset)/100),.3,10);
}
return pix;
}
  ]]
}

return ch1l1
