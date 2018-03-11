local sky3={
	color={r=163,g=73,b=164},
	img="Levels/ch1/shared/Graphics/Tiles/sky3.png",
	coords={
		{0,0,32,32},
		{32,0,32,32},
		{0,32,32,32},
		{32,32,32,32}
	},
	handle=function(self)
	local num=math.random(4)
	return self.coords[num][3],self.coords[num][4],self.coords[num],false,false
	end
}
return sky3
