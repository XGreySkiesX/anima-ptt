-- Game State --

local Game={}

function Game:enter()
	Sounds.stopSounds()

	g=Ground:new{y=love.graphics.getHeight()-20,w=love.graphics.getWidth(),h=20,name="ground"}
	p1=Platform:new{x=300,y=400,w=200,h=10,name="p1"}
	p2=Platform:new{x=200,y=500,w=50,h=10,name="p2"}
	player=Player:new{name="player",x=10,y=300,w=32,h=64,ground=420,jump_height=250}
	L=Level:new{w=600}
	L:insert({player,g,p1,p2})
	--src="M/Graphics/Sprites/sq.png",
end

--make the game look for the escape key at all times
function Game:keypressed(key)
	if key=="escape" then
		love.event.quit()
	end
end

-- here we do some M a G i C
function Game:update(dt)
	L:update(dt)
end

-- Draw all the diddly-darn things
function Game:draw()
	L:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.print(player.text.." "..player.x.." "..player.y)
end


return Game
