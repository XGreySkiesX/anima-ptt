Sounds={} --The Function Jazz
soundlist={}

SFX={
	volume=.8,
	src="M/Audio/Sound/bump.wav",
	type="sfx",
	new=function(self,o)
		local o=o or {}
    setmetatable(o,self)
    self.__index=self
		o.sound=love.audio.newSource(o.src,"static")
		o.sound:setVolume(o.volume)
		table.insert(soundlist,o)
		return o
	end,
	play=function(self,volume)
		self.sound:setVolume(volume or 0.8)
		self.sound:play()
	end
}

Mus={
	isloop=true,
	loopstart=0,
	loopend=0,
	volume=.5,
	src="M/Audio/Music/8bitMain.mp3",
	new=function(self,o)
		local o=o or {}
    setmetatable(o,self)
    self.__index=self
		o.sound=love.audio.newSource(o.src,"stream")
		o.sound:setVolume(o.volume)
		o.sound:setLooping(o.isloop)
		table.insert(soundlist,o)
		return o
	end,
	loop=function(self)
		if self.sound:tell("seconds")>=self.loopend then
			o.sound:seek(o.sound:tell("seconds")-(self.loopend-self.loopstart) ,"seconds")
		end
	end,
	update=function(self)
		if self.isloop==true then
			self:loop()
		end
	end,
	play=function(self,vol)
		self.sound:setVolume(vol or 0.5)
		self.sound:play()
	end
}

Song=Mus:new{type="song"}
FanFare=Mus:new{type="fanfare"}

-- Set up everything, to play a song
function Sounds.updateSounds()
	for i,v in ipairs(soundlist) do
		if v.type=="song" then
			v:update()
		end
	end
end

-- Stop a selected sound, or stop all
function Sounds.stopSounds()
love.audio.stop()
end

return Sounds --this just returns all the functions, so we can use them in our other scripts
