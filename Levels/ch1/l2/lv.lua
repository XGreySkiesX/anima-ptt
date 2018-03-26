local ch1l2={
bgsrc="Levels/ch1/l2/bg.png",
ts_source="Levels/ch1/shared/Graphics/Tiles/ch1.png",

setup=function(self)
self.tilesheet=TSheet:new{src=self.ts_source}
self.map=Map:new{src=self.bgsrc}
self:msg_init()
self.shader=love.graphics.newShader(self.scode)
self.shader:send("screenWidth",self.w)
for i,v in ipairs(self.map.platforms) do
	table.insert(self.objects,Platform:new{x=v.x,y=v.y,w=v.w,h=v.h})
end
end,

upd_func=function(self)
self.shader:send("offset",self.camera.x)
end,

objects={
	Player:new{
	x=10,
	y=928,
	w=32,
	h=64,
	c={255,255,255,255},
	cc={255,255,255,255},
	name="player",
	ground=420,
	src="Levels/ch1/shared/Graphics/Sprites/player.png",
	jump_height=210,
	max_y=225
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
	string=Strings.ch1l1[1],
	c={0,0,100,150},tc={255,255,255,255},
	delay=0.1
	},
	[2]=TextBox:new{
	x=0,y=600,w=love.graphics.getWidth(),
	string=Strings.ch1l1[2],
	c={0,0,100,150},
	tc={255,255,255,255},
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