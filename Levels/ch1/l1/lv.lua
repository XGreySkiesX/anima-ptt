local ch1l2={
bgsrc="Levels/ch1/l1/bg.png",
lvsrc="Levels/ch1/l1/level.png",
tile_sources={grass="Levels.ch1.shared.Graphics.Tiles.grass",platform1="Levels.ch1.shared.Graphics.Tiles.platform1",sky3="Levels.ch1.shared.Graphics.Tiles.sky3"},
tdone=true,
setup=function(self)
self.thread=love.thread.newThread([[
	require('C.tilesheets')
	require('C.map')
	require('love.image')
	local bgsrc,lvsrc,tsrcs=...
	local tilesheet=TSheet:new{srcs=tsrcs}
	local bgmap=Map:new{src=bgsrc,sheet=tilesheet}
	local map=Map:new{src=lvsrc,sheet=tilesheet}

	love.thread.getChannel('mp_t'..lvsrc):push(map.tiles)
	love.thread.getChannel('mp_p'..lvsrc):push(map.platforms)
	love.thread.getChannel('bgm_t'..lvsrc):push(bgmap.tiles)
	]])
self.map=Map:new{src=self.lvsrc,initialize=false}
self.bgmap=Map:new{src=self.bgsrc,initialize=false}
self.thread:start(self.bgsrc,self.lvsrc,self.tile_sources)
end,
load=function(self)
	if not self.loaded then
		local bgm_t=love.thread.getChannel('bgm_t'..self.lvsrc):pop()
		local mp_t=love.thread.getChannel('mp_t'..self.lvsrc):pop()
		local mp_p=love.thread.getChannel('mp_p'..self.lvsrc):pop()
		if bgm_t and mp_t and mp_p then
			self.bgmap.tiles=bgm_t
			self.map.tiles=mp_t
			self.map.platforms=mp_p
			self.w=self.map.w*self.map.tilesize
			self.h=self.map.h*self.map.tilesize
			local cc=255
			for i,v in ipairs(self.map.platforms) do
				table.insert(self.objects,Platform:new{x=v.x,y=v.y,w=v.w,h=v.h,c={cc,cc*.5,cc*.75,255}})
				cc=cc-10
			end
			-- self.shader=love.graphics.newShader(self.scode)
			self:msg_init()
			self.tmr=0
			self.loaded=true
		end
	end
end,
upd_func=function(self)
self.tmr=self.tmr+love.timer.getDelta()
-- self.shader:send("p_coords",{self.player.body.center.x,self.player.body.center.y,0})
-- self.shader:send("offset",{self.camera.x,self.camera.y,0})
-- self.shader:send("timer",self.tmr)
end,
objects={
	Player:new{
	x=100,
	y=900,
	w=32,
	h=64,
	y_velocity=0,
	max_y=200,
	speed=200,
	name="player",
	ground=0,
	src="Levels/ch1/shared/Graphics/Sprites/player.png",
	jump_height=210
	}
},
msgs={
	TextBox:new{
	x=0,y=love.graphics.getHeight(),w=love.graphics.getWidth(),
	string=Strings.ch1l1[1],
	c={0,0,100,150},tc={255,255,255,255},
	delay=0.1
	},
	TextBox:new{
	x=0,y=love.graphics.getHeight(),w=love.graphics.getWidth(),
	string=Strings.ch1l1[2],
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
if(pix.r==1.0 && pix.g==1.0 && pix.b==1.0){
	pix=vec4(abs(random(window_coords)/sin(timer)));
	return pix;
}
pix.rgb=(pix.rgb/5)/clamp((distance(window_coords,p_coords-offset)/100),.3,10);

return pix;
}
  ]]
}

return ch1l2
