-- Menu State --

--setup all the images and jazz
local MenuS={}
local centerx,centery=love.graphics.getWidth()/2,love.graphics.getHeight()/2
place=1
local BG=love.graphics.newImage("Media/Graphics/Menu/MenuScreenBG.png")
local QA= love.graphics.newImage("Media/Graphics/Menu/Quit_Active.png")
local QI= love.graphics.newImage("Media/Graphics/Menu/Quit_Inactive.png")
local SGA= love.graphics.newImage("Media/Graphics/Menu/Start_Game_Active.png")
local SGI= love.graphics.newImage("Media/Graphics/Menu/Start_Game_Inactive.png")
local SG
local Q

--stop all previous sounds; set background to menu theme
function MenuS:enter()
  Sounds.stopSounds()
  --menu_theme=Song:new{src="Media/Audio/Music/MenuTheme.mp3"}
  --menu_theme:play()
end

--check to see what option the player is on
function MenuS:update(dt)
if place == 1 then
SG=SGA
Q=QI
elseif place == 2 then
SG=SGI
Q=QA
else
place=1
end
end

--doodle all the jazz
function MenuS:draw()
love.graphics.setColor(255,255,255,255)
love.graphics.draw(BG,0,0)
love.graphics.draw(SG,centerx-238,centery-100)
love.graphics.draw(Q,centerx-238,centery+100)
end

--check for them keys
function MenuS:keypressed(nuk)
if nuk == "up" then
if place==1 then
place=2
elseif place==2 then
place=1
end
elseif nuk == "down" then
if place==1 then
place=2
elseif place==2 then
place=1
end
elseif nuk == "escape" then
love.event.quit()
elseif nuk == "p" then
Gamestate.switch(MR)
place=1
elseif nuk=="return" then
if place==1 then
Gamestate.switch(Game)
elseif place==2 then
love.event.quit()
end
else
return nil
end
end

return MenuS
