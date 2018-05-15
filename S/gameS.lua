-- Game State --

local Game={}


function Game:enter()
	collectgarbage()
		Sounds.stopSounds()
		Display.clear()

		q_btn=Button:new{x=love.graphics.getWidth()/2-50,y=love.graphics.getHeight()/2+50,w=100,h=30,ts=20,text="QUIT",
		onclick=function(self)
		Game.loaded=false
		Gamestate.switch(MS)
		end, fetchcode="qbtn",hidden=true}

		rs_btn=Button:new{
			w=20,h=20,
			text="x",
			onclick=function(self)
				Game.loaded=false
				Game:enter()
			end, fetchcode="rs_btn"
		}
		px,py=0,1

		Game.L=Level:new{src="ch1/l1/lv"}
		Game.L:setup()

		font=love.graphics.newFont(24)
		orig=Vector:new(0,0)
		txt="."
		tmr=0
		m_pause=false
end

--make the game look for the escape key at all times
function Game:keypressed(key)
	if Game.loaded then
		if key=="escape" and Game.loaded then
			if Game.L.paused then
				Game.L:unpause()
				q_btn:hide()
				m_pause=false
			else
				Game.L:pause()
				q_btn:show()
				m_pause=true
			end
		end
		Game.L:keys(key)
	end
end

function Game:mousereleased(x,y,btn)
	if btn==1 then
		Display.clicks(x,y)
	end
end

function Game:update(dt)
		if Game.loaded then
			td=td+dt
			Sprites.update(dt)
			Game.L:update(dt)
			Display.update()
		else
			if coroutine.status(Game.L.core)~="dead" then
				_,px,py=coroutine.resume(Game.L.core)
			end
			tmr=tmr+dt
			if tmr>1 then
				if txt=="." then txt=".."
				elseif txt==".." then txt="..."
				else txt="."
				end

				tmr=0
			end
				Game.L:load()
				Game.loaded=Game.L.loaded
		end
end

-- Draw all the diddly-darn things
function Game:draw()
		if Game.loaded then
			Game.L:draw()
			if Game.L.paused then
				love.graphics.setColor(0,0,0,150/255)
				love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
				love.graphics.setColor(1,1,1,1)
				love.graphics.setFont(font)
				love.graphics.print("PAUSED",love.graphics.getWidth()/2-font:getWidth("PAUSED")/2,love.graphics.getHeight()/2-font:getHeight()/2)
			end
			love.graphics.setColor(1,1,1)
			love.graphics.setFont(font)
			love.graphics.print(Game.L.objects[2].body.tl.y,0,50)
			Display.all()
		else
			love.graphics.setColor(1,1,1)
			love.graphics.setFont(font)
			love.graphics.print("Loading"..txt,love.graphics.getWidth()/2-font:getWidth("Loading"..txt)/2,love.graphics.getHeight()/2-font:getHeight()/2)
			if px~=nil and py~=nil then
				love.graphics.rectangle("line",0,0,love.graphics.getWidth(),20)
				love.graphics.rectangle("fill",0,0,math.floor((px/py)*love.graphics.getWidth()),20)
			end
		end
end

function Game:focus(f)
	if f then
		if Game.L.paused then
			if not m_pause then
				Game.L:unpause()
			end
		end
	else
		if not m_pause then
			Game.L:pause()
		end
	end
end


return Game
