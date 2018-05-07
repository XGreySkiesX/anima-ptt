local sky3={
	color={r=163/255,g=73/255,b=164/255},
	img="Levels/ch1/shared/Graphics/Tiles/sky3.png",
	coords={
		left={
		{0,0,64,64},
		{64,0,64,64},
		{0,64,64,64},
		{0,192,64,64}
		},
		right={
		{128,0,64,64},
		{192,0,64,64},
		{192,64,64,64},
		{192,192,64,64}
		},
		center={
		{64,64,64,64},
		{128,64,64,64},
		{64,128,64,64},
		{128,128,64,64}
		}
	},
	handle=function(self,c_tl,t_tl,b_tl,l_tl,r_tl)
	-- if t_tl.r==c_tl.r and t_tl.g==c_tl.g and t_tl.b==c_tl.b then
	-- 	return self.coords.dirt[3],self.coords.dirt[4],self.coords.dirt,false,true,self.shader
	-- elseif (l_tl.r==c_tl.r and l_tl.g==c_tl.g and l_tl.b==c_tl.b) and (r_tl.r==c_tl.r and r_tl.g==c_tl.g and r_tl.b==c_tl.b) then
	-- 		return self.coords.middle[3],self.coords.middle[4],self.coords.middle,true,true,self.shader
	-- elseif (l_tl.r==c_tl.r and l_tl.g==c_tl.g and l_tl.b==c_tl.b) then
	-- 		return self.coords.right[3],self.coords.right[4],self.coords.right,false,true,self.shader
	-- elseif (r_tl.r==c_tl.r and r_tl.g==c_tl.g and r_tl.b==c_tl.b) then
	-- 	return self.coords.left[3],self.coords.right[4],self.coords.left,false,true,self.shader
	-- else
	-- 	return self.coords.single[3],self.coords.single[4],self.coords.single,false,true,self.shader
	-- end
	local num=math.random(1,#self.coords)
	-- return self.coords[num][3],self.coords[num][4],self.coords[num],false,false
	return self.coords.center[num][3],self.coords.center[num][4],self.coords.center[num],false,false
	end
}
return sky3
