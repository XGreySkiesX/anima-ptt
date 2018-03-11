--Music Room--
local MusicRoom={}

function MusicRoom:enter()
  Sounds.stopSounds()
  Display.clear()
	sh1=TSheet:new{srcs={grass="Levels.ch1.shared.Graphics.Tiles.grass"}}
	map=Map:new{src="M/Graphics/test.png",sheet=sh1}
	txt=""
	color={}
	imgd=love.image.newImageData("M/Graphics/map_key.png")
	color.r,color.g,color.b,color.a=imgd:getPixel(0,0)
	for i,v in pairs(sh1.colors) do
		txt=txt..i.."\n"
	end
end

function MusicRoom:keypressed(k)

  if k=="escape" then
    Gamestate.switch(MS)
  end

end

function MusicRoom:update(dt)

end

function MusicRoom:draw()
	map:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.print(#map.platforms)
end

return MusicRoom
