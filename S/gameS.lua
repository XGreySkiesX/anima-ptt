-- Game State --

local Game={}
Game.lvsrc="ch1.l1.lv"

function Game:enter()
	Sounds.stopSounds()
	Display.clear()
	Game.L=Level:new{src="ch1.l1.lv"}
	Game.L:setup()
	Game.L2=Level:new{src="ch1.l1.lv"}
	Game.L2:setup()
	Game.L3=Level:new{src="ch1.l1.lv"}
	Game.L3:setup()

	orig=Vector:new(0,0)
	txt="."
	tmr=0
end

--make the game look for the escape key at all times
function Game:keypressed(key)
	if key=="escape" then
		love.event.quit()
	end
	if Game.loaded then
		Game.L3:keys(key)
	end
end

function Game:update(dt)
	if Game.loaded then
		Game.L3:update(dt)
	else

		tmr=tmr+dt
		if tmr>1 then
			if txt=="." then txt=".."
			elseif txt==".." then txt="..."
			else txt="." 
			end

			tmr=0
		end
		Game.L:load()
		Game.L2:load()
		Game.L3:load()
		Game.loaded=Game.L.loaded and Game.L2.loaded and Game.L3.loaded
	end
end

-- Draw all the diddly-darn things
function Game:draw()
	if Game.loaded then
		Game.L3:draw()
	else
		love.graphics.setColor(255,255,255)
		love.graphics.print("Loading"..txt.." "..tostring(Game.L3.thread:getError()))
	end
end


return Game
