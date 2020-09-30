local sky3={
	color={r=163/255,g=73/255,b=164/255},
	img="Levels/ch1/shared/Graphics/Tiles/sky3.png",
	coords={
		left={
		{0,0,64,64},
		{64,0,64,64},
		{0,64,64,64},
		{0,192,64,64},
		{64,192,64,64}
		},
		right={
		{128,0,64,64},
		{192,0,64,64},
		{192,64,64,64},
		{192,192,64,64},
		{128,192,64,64}
		},
		center={
		{64,64,64,64},
		{128,64,64,64},
		{64,128,64,64},
		{128,128,64,64}
		}
	},
	handle=function(self,c_tl,t_tl,b_tl,l_tl,r_tl)
	if not (l_tl.r==c_tl.r and l_tl.g==c_tl.g and l_tl.b==c_tl.b) then
		if (t_tl.r==c_tl.r and t_tl.g==c_tl.g and t_tl.b==c_tl.b) and (b_tl.r==c_tl.r and b_tl.g==c_tl.g and b_tl.b==c_tl.b) then
			return self.coords.left[3][3],self.coords.left[3][4],self.coords.left[3],false,false,self.shader
		elseif (t_tl.r==c_tl.r and t_tl.g==c_tl.g and t_tl.b==c_tl.b) then
			return self.coords.left[4][3],self.coords.left[4][4],self.coords.left[4],false,false,self.shader
		elseif (b_tl.r==c_tl.r and b_tl.g==c_tl.g and b_tl.b==c_tl.b) then
			return self.coords.left[1][3],self.coords.left[1][4],self.coords.left[1],false,false,self.shader
		end
	elseif not (r_tl.r==c_tl.r and r_tl.g==c_tl.g and r_tl.b==c_tl.b) then
		if (t_tl.r==c_tl.r and t_tl.g==c_tl.g and t_tl.b==c_tl.b) and (b_tl.r==c_tl.r and b_tl.g==c_tl.g and b_tl.b==c_tl.b) then
			return self.coords.right[3][3],self.coords.right[3][4],self.coords.right[3],false,false,self.shader
		elseif (t_tl.r==c_tl.r and t_tl.g==c_tl.g and t_tl.b==c_tl.b) then
			return self.coords.right[4][3],self.coords.right[4][4],self.coords.right[4],false,false,self.shader
		elseif (b_tl.r==c_tl.r and b_tl.g==c_tl.g and b_tl.b==c_tl.b) then
			return self.coords.right[2][3],self.coords.right[2][4],self.coords.right[2],false,false,self.shader
		end
	elseif not (t_tl.r==c_tl.r and t_tl.g==c_tl.g and t_tl.b==c_tl.b) then
		return self.coords.left[2][3],self.coords.left[2][4],self.coords.left[2],false,false,self.shader
	elseif not (b_tl.r==c_tl.r and b_tl.g==c_tl.g and b_tl.b==c_tl.b) then
			return self.coords.right[5][3],self.coords.right[5][4],self.coords.right[5],false,false,self.shader
	end
		return self.coords.center[1][3],self.coords.center[1][4],self.coords.center[1],false,false,self.shader
	end
}
return sky3
