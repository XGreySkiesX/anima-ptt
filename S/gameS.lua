-- Game State --

local Game={}

function Game:enter()
	Sounds.stopSounds()

	--[[
	Entities.prepObj("ground",0,ey-100,100,ex,{255,255,255,255},"ground")
	Entities.prepObj("plat1",.4*ex,.7*ey-20,20,200,{255,255,255,255},"platform")
	Entities.prepObj("plat2",.2*ex,.6*ey-20,20,200,{255,255,255,255},"platform")
	Entities.prepEntity("player",psrc,pnx,pny,{255,255,255,255},"player",200,-200,-200)
	]]
	g=Platform:new{y=420,w=love.graphics.getWidth(),h=love.graphics.getHeight()-420,name="ground"}
	p1=Platform:new{x=300,y=360,w=200,h=10,name="p1"}
	player=Player:new{name="player",isrc="Media/Graphics/Sprites/sq.png",x=0,y=300,ground=420,jump_height=200}

	--Txter.prep(1,"Welcome! Use the A key to move this along.",.2,0,"txt1","spc1",14,{255,255,255,255},{100,100,100,255},love.graphics.getWidth(),100)
	--Txter.prep(2,"This is just a small minigame, really.",.2,0,"txt1","spc1",14,{255,255,255,255},{100,100,100,255},love.graphics.getWidth(),100)
	--Txter.prep(3,"Use the arrow keys to move left and right. The up key jumps!",.2,0,"txt1","spc1",14,{255,255,255,255},{100,100,100,255},love.graphics.getWidth(),100)
	--Txter.prep(4,"To make your character small, and then big again, press L.",.2,0,"txt1","spc1",14,{255,255,255,255},{100,100,100,255},love.graphics.getWidth(),100)
	--Txter.prep(5,"To exit the game, press the escape key. Press down to go to exit, and then press enter.",.2,0,"txt1","spc1",14,{255,255,255,255},{100,100,100,255},love.graphics.getWidth(),100)
	--Txter.prep(6,"Have fun!",.2,0,"txt1","spc1",14,{255,255,255,255},{100,100,100,255},love.graphics.getWidth(),100)

	--Txter.initiate()
end

--make the game look for the escape key at all times
function Game:keypressed(key)
	if key=="escape" then
		love.event.quit()
	end
end

-- here we do some M a G i C
function Game:update(dt)
	Entities.update(dt)
end

-- Draw all the diddly-darn things
function Game:draw()
	Entities.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.print(player.y+player.h)
	love.graphics.print(player.ground,0,20)
	love.graphics.print(tostring(player.collisions[1]),0,40)
end


return Game
