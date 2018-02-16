-- Game State --

local Game={}

function Game:enter()
	Sounds.stopSounds()
	--love.graphics.setBackgroundColor({100,100,100})
	orig=Vector:new(0,0)

	C=Camera:new{}

	g= Ground:new		{
							x=0,
							y=love.graphics.getHeight()-20,
							w=love.graphics.getWidth()+100,
							h=40,
							name="ground"
						}

	p1= Platform:new	{
							x=300,
							y=400,
							w=200,
							h=20,
							name="p1",
							mode="line"
						}

	p2= Item:new	{
							x=200,
							y=500,
							w=50,
							h=75,
							name="p2",
							static=false,
							is_g_affected=true
						}

p3=Platform:new{
	x=200,
	y=300,
	w=100,
	h=20,
	name="p3",
	mode="line"
}

p4=Platform:new{
	x=300,
	y=200,
	w=10,
	h=20,
	name="p4",
	mode="line"
}

	player= Player:new	{
							x=10,
							y=300,
							w=32,
							h=64,
							name="player",
							ground=420,
							src="M/Graphics/Sprites/sq2.png",
							jump_height=210,
							max_y=225
						}

	L= Level:new		{
							w=700,
							h=700,
							gravity=200,
						}

	L:insert			({
							player,
							g,
							p2,
							p1,
							p3,
							p4
						},C)

end

--make the game look for the escape key at all times
function Game:keypressed(key)
	if key=="escape" then
		love.event.quit()
	end
end

function Game:update(dt)
	L:update(dt,player)
end

-- Draw all the diddly-darn things
function Game:draw()
	L:draw()
end


return Game
