local TS={}
td=0
STSp={
	w=16,
	h=16,
	q={},
	props={},
	new=function(self,o)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
		return o
	end
}

ATSp=STSp:new{}

TSheet={
	static_tiles={},
	animated_tiles={},
	srcs={},
	colors={},
	new=function(self,o)
		local o=o or {}
		setmetatable(o,self)
		self.__index=self
		for i,v in pairs(o.srcs) do
			local ti=require(v)
			o.colors[i]=ti.color
			o[i]=ti
		end
		return o
	end
}

return TS
