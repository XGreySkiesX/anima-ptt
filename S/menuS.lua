-- Menu State --
local MenuS={}

--stop all previous sounds; set background to menu theme
function MenuS:enter()
	collectgarbage()
	Display.clear()
  	Sounds.stopSounds()
	local centerx,centery=love.graphics.getWidth()/2,love.graphics.getHeight()/2
	place=1
	BG=love.graphics.newImage("M/Graphics/Interface/Menu/MenuScreenBG.png")
	QA= PicButton:new{src="M/Graphics/Interface/Menu/Quit_Active.png",x=centerx-238,y=centery+100,fetchcode="quit",onclick=function()
	love.event.quit()
	end}
	--local QI= love.graphics.newImage("M/Graphics/Menu/Quit_Inactive.png")
	SGA= PicButton:new{src="M/Graphics/Interface/Menu/Start_Game_Active.png",x=centerx-238,y=centery-100,fetchcode="start",onclick=function()
	Gamestate.switch(Game)
	end}
	--local SGI= love.graphics.newImage("M/Graphics/Menu/Start_Game_Inactive.png")
	local SG
	local Q
end

function MenuS:keypressed(key)
	if key=="p" then
		Gamestate.switch(MR)
	end
end

--check to see what option the player is on
function MenuS:update(dt)
Display.update(dt)
end

--doodle all the jazz
function MenuS:draw()
love.graphics.setColor(255,255,255,255)
love.graphics.draw(BG,0,0)
Display.all()
end

function MenuS:mousereleased(x,y,btn)
	if btn==1 then
		Display.clicks(x,y)
	end
end
return MenuS
