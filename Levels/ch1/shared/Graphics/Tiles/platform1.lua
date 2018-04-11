local platform1={
	img="Levels/ch1/shared/Graphics/Tiles/platform1.png",
	color={r=1.0,g=242/255,b=0},
	coords={
	left={0,0,32,16},
	middle={32,0,32,16},
	right={64,0,32,16},
	single={0,16,32,16}
	},
	handle=function(self,c_tl,t_tl,b_tl,l_tl,r_tl)
	if (l_tl.r==c_tl.r and l_tl.g==c_tl.g and l_tl.b==c_tl.b) and (r_tl.r==c_tl.r and r_tl.g==c_tl.g and r_tl.b==c_tl.b) then
			return self.coords.middle[3],self.coords.middle[4],self.coords.middle,false,true
	elseif (l_tl.r==c_tl.r and l_tl.g==c_tl.g and l_tl.b==c_tl.b) then
			return self.coords.right[3],self.coords.right[4],self.coords.right,false,true
	elseif (r_tl.r==c_tl.r and r_tl.g==c_tl.g and r_tl.b==c_tl.b) then
		return self.coords.left[3],self.coords.left[4],self.coords.left,false,true
	else
		return self.coords.single[3],self.coords.single[4],self.coords.single,false,true
	end
end
}

return platform1