local sky3={
	color={r=163/255,g=73/255,b=164/255},
	img="Levels/ch1/shared/Graphics/Tiles/sky3.png",
	coords={
		{0,0,32,32},
		{32,0,32,32},
		{64,0,32,32},
		{96,0,32,32},
		{0,32,32,32},
		{32,32,32,32},
		{64,32,32,32},
		{96,32,32,32},
		{0,64,32,32},
		{32,64,32,32},
		{64,64,32,32},
		{96,64,32,32},
		{0,96,32,32},
		{32,96,32,32},
		{64,96,32,32},
		{96,96,32,32}
	},
	handle=function(self)
	local num=math.random(1,#self.coords)
	return self.coords[num][3],self.coords[num][4],self.coords[num],false,false
	end
}
return sky3
