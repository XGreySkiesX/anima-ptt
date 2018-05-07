local jungle={
img="Levels/ch1/shared/Graphics/Backgrounds/jungle.png",
color={r=0.0,g=150/255,b=0.0,a=1.0},
coords={
{0,0,256,256}
},
handle=function(self)
		return self.coords[1][3],self.coords[1][4],self.coords[1],false,false,self.shader
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

return jungle
