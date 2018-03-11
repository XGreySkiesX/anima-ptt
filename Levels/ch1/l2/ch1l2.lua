local ch1l2={
bgsrc="Levels/ch1/l2/bg.png",
lvsrc="Levels/ch1/l2/level.png",
tdone=true,
setup=function(self)
self.tilesheet=TSheet:new{srcs={grass="Levels.ch1.shared.Graphics.Tiles.grass",platform1="Levels.ch1.shared.Graphics.Tiles.platform1"}}
self.bgsheet=TSheet:new{srcs={sky3="Levels.ch1.shared.Graphics.Tiles.sky3"}}
self.bgmap=Map:new{src=self.bgsrc,sheet=self.bgsheet}
self.map=Map:new{src=self.lvsrc,sheet=self.tilesheet}
self.w=self.map.w*self.map.tilesize
self.h=self.map.h*self.map.tilesize
for i,v in ipairs(self.map.platforms) do
	table.insert(self.objects,Platform:new{x=v.x,y=v.y,w=v.w,h=v.h})
end
--self.shader=love.graphics.newShader(self.scode)
--self.shader:send("screenWidth",self.w)
self:msg_init()
end,
upd_func=function(self)
--self.shader:send("p_coords",{self.player.body.center.x,self.player.body.center.y,0})
--self.shader:send("offset",{self.camera.x,self.camera.y,0})
return
end,
objects={
	Player:new{
	x=100,
	y=0,
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
	x=0,y=600,w=love.graphics.getWidth(),
	string=Strings.ch1l1[1],
	c={0,0,100,150},tc={255,255,255,255},
	delay=0.1
	},
	TextBox:new{
	x=0,y=600,w=love.graphics.getWidth(),
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
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
vec4 pix=Texel(texture,texture_coords);
if(pix.r==0.0 && pix.g==1.0 && pix.b==1.0){
pix.a=0.0;
}
pix=(pix/2)/(distance(screen_coords,p_coords-offset)/75)-(pix/10);

return pix;
}
  ]]
}

return ch1l2
