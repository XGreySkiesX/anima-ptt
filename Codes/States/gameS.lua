-- Game State --

local Game={}

function Game:enter()
	psource=1
	psrc="Media/Graphics/Sprites/sq.png"
	pny=0
	pnx=0
--stop previous music, start the game's theme
	Trem.stopBGM("MenuTheme")
	Trem.playMus("Main","Media/Audio/Music/8bitMain.mp3",48.0,77.6)
-- set coordinate variables for the player, and find where to make the player stop
	ex=love.graphics.getWidth()
	ey=love.graphics.getHeight()
	-- set player speed, of course
	speed=100
	height=love.graphics.getHeight()
	width=love.graphics.getWidth()

	Entities.prepObj("ground",0,ey-100,100,ex,{255,255,255,255},"ground")
	Entities.prepObj("plat1",.4*ex,.7*ey-20,20,200,{255,255,255,255},"platform")
	Entities.prepObj("plat2",.2*ex,.6*ey-20,20,200,{255,255,255,255},"platform")
	Entities.prepEntity("player",psrc,pnx,pny,{255,255,255,255},"player",200,-200,-200)

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
	M.MenuKeys(key)
	if key=="tab" then
		if deb then
			deb=false
		else
			deb=true
		end
	end

	Txter.advance(key)

	if key=="l" then
		if psource==1 then
			psource=2
			psrc="Media/Graphics/Sprites/sq2.png"
			img=love.graphics.newImage("Media/Graphics/Sprites/sq2.png")
			pny=objects["player"].y+(objects["player"].h-img:getHeight())
			pnx=objects["player"].x+(objects["player"].w-img:getWidth())
			Entities.prepEntity("player",psrc,pnx,pny,{255,255,255,255},"player",200,-200,-200)
		else
			psource=1
			psrc="Media/Graphics/Sprites/sq.png"
			img=love.graphics.newImage("Media/Graphics/Sprites/sq.png")
			pny=objects["player"].y-(img:getHeight()-objects["player"].h)
			pnx=objects["player"].x-(img:getWidth()-objects["player"].w)
			Entities.prepEntity("player",psrc,pnx,pny,{255,255,255,255},"player",200,-200,-200)
		end
	end
end

-- here we do some M a G i C
function Game:update(dt)
--loop teh moosic

txx=love.timer.getDelta()

	Trem.Loop("Main")


	Entities.movePlayer(dt)

	Entities.collideBlock("player","window")
	Entities.collideBlock("player","ground")
	Entities.collideBlock("player","plat1")
	Entities.collideBlock("player","plat2")

	Entities.boundUpdate("player")


	--Txter.tUpd(1,dt)
  --Txter.tUpd(2,dt)
  --Txter.tUpd(3,dt)
  --Txter.tUpd(4,dt)
	--Txter.tUpd(5,dt)
	--Txter.tUpd(6,dt)
end

-- Draw all the diddly-darn things
function Game:draw()
	Trem.printProp("Main",255,0,0)

	Entities.draw("player")
	Entities.draw("ground")
	Entities.draw("plat1")
	Entities.draw("plat2")
	Entities.debug()
	Entities.bound("plat1")
	Entities.bound("player")
	M.MenuDraw()

	love.graphics.setColor(0,0,0,255)
	love.graphics.print(txx,0,.9*ey)

	--Txter.printT(1,dt)
  --Txter.printT(2,dt)
  --Txter.printT(3,dt)
  --Txter.printT(4,dt)
	--Txter.printT(5,dt)
	--Txter.printT(6,dt)
end


return Game
