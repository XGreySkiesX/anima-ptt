-- Menu State --

--setup all the images and jazz
local Menu={}
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
function Menu:enter()
--Sounds.stopBGM("all")
--Sounds.playMus("MenuTheme","Media/Audio/Music/MenuTheme.mp3",0,25)
end

--check to see what option the player is on
function Menu:update(dt)
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
function Menu:draw()
love.graphics.setColor(255,255,255,255)
love.graphics.draw(BG,0,0)
love.graphics.draw(SG,centerx-238,centery-100)
love.graphics.draw(Q,centerx-238,centery+100)
end

--check for them keys
function Menu:keypressed(nuk)
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

return Menu
