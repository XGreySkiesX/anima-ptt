--Note: Out of order.

local Sprite={}
local sourcea
local sack
local quadwa
local quadha
local xa=love.graphics.getWidth()*.10
local ya=love.graphics.getHeight()*.80

function Sprite.spriteLoad(character,sack,quadw,quadh)
character={}
character.s = love.graphics.newImage(sack)
character.sh=character.s:getHeight()
character.sw=character.s:getWidth()
character.frames={}
character.frames[1]=love.graphics.newQuad(0,0,quadw,quadh,character.sw,character.sh)
character.frames[2]=love.graphics.newQuad(quadw,0,quadw*2,quadh,character.sw,character.sh)
character.frames[3]=love.graphics.newQuad(quadw*2,0,quadw*3,quadh,character.sw,character.sh)
timer=0
num=1
sourcea=sack
quadwa=quadw
quadha=quadh
return character
end

function Sprite.drawFace(character,sourcea,quadwa,quadha,xb,yb)
chara=Sprite.spriteLoad(character,sourcea,quadwa,quadha)
love.graphics.draw(chara.s,chara.frames[1],xb,yb)
end

function Sprite.updateFace(character,source,quadw,qhadh,xa,ya)
timer=0+love.timer.getDelta()
num=1*(timer*10)
chara=Sprite.spriteLoad(character,source,quadw,qhadh)
face=chara.frames[num]
if timer>.02 then
timer=0
num=1
end
love.graphics.draw(chara.s,face,xa,ya)
end

return Sprite