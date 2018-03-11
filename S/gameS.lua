-- Game State --

local Game={}
local lvsrc="ch1.l2.ch1l2"

function Game:enter()
	Sounds.stopSounds()
	Display.clear()

	orig=Vector:new(0,0)

	L=Level:new{src=lvsrc}

	L:setup()
end

--make the game look for the escape key at all times
function Game:keypressed(key)
	if key=="escape" then
		love.event.quit()
	end
	L:keys(key)
end

function Game:update(dt)
	mx,my=love.mouse.getPosition()
	--L.player.body:translate(Vector:new(mx*2,my*2))
	L:update(dt)
end

-- Draw all the diddly-darn things
function Game:draw()
	L:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.print(L.player.body.center.x..", "..L.player.body.center.y)
end


return Game
