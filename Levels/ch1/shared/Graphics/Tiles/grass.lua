local grass={
img="Levels/ch1/shared/Graphics/Tiles/grass.png",
color={r=0,g=1.0,b=0,a=1.0},
coords={
left={0,0,32,32},
middle={32,0,32,32},
right={64,0,32,32},
top={{0,32,32,32},{0,64,32,32},{64,64,32,32},{32,64,32,32},{64,64,32,32},{32,64,32,32},{0,64,32,32},{0,32,32,32}},
single={32,32,32,32},
dirt={64,32,32,32}
},
handle=function(self,c_tl,t_tl,b_tl,l_tl,r_tl)
	if t_tl.r==c_tl.r and t_tl.g==c_tl.g and t_tl.b==c_tl.b then
		return self.coords.dirt[3],self.coords.dirt[4],self.coords.dirt,false,true,self.shader
	elseif (l_tl.r==c_tl.r and l_tl.g==c_tl.g and l_tl.b==c_tl.b) and (r_tl.r==c_tl.r and r_tl.g==c_tl.g and r_tl.b==c_tl.b) then
			return self.coords.middle[3],self.coords.middle[4],self.coords.middle,true,true,self.shader
	elseif (l_tl.r==c_tl.r and l_tl.g==c_tl.g and l_tl.b==c_tl.b) then
			return self.coords.right[3],self.coords.right[4],self.coords.right,false,true,self.shader
	elseif (r_tl.r==c_tl.r and r_tl.g==c_tl.g and r_tl.b==c_tl.b) then
		return self.coords.left[3],self.coords.right[4],self.coords.left,false,true,self.shader
	else
		return self.coords.single[3],self.coords.single[4],self.coords.single,false,true,self.shader
	end
end,
shader=[[
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );
      if (pixel.r==0.0 && pixel.g==1.0 && pixel.b==1.0){
		pixel.a=0.0;
	  }
	return pixel;
}
 ]]
	
}

return grass