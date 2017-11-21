-- Menu Script --
-- Note: Should probably make a new one that works with more options, custom colors, etc. Would be more practical than creating a new menu script
-- for each thing


--define the whole functiony thing
local M={}

--get height and width of the window
local mx=love.graphics.getWidth()
local my=love.graphics.getHeight()
--make sure that menu isn't open by default!
menuOpen=false
--set starting points for menu
local px=mx*.75
local py=my*.10
--set the active choice to one, seeing as that makes the most sense
menuActive=1
local col={}
--colors, for differentiating between active and inactive
col[1]={255,0,255,255}
col[2]={0,0,0,255}

--set up how the keys will work
function M.MenuKeys(key)
  if tdone and key=="escape" then
    if menuOpen then
      menuOpen=false
    else menuOpen=true
    end
    end
    if menuOpen and (key=="up" or key=="down") then
      if menuActive==1 then
        menuActive=2
      else menuActive=1
      end
    elseif key=="return" then
      if menuActive==1 then
        menuOpen=false
      else
        menuOpen=false;
        Gamestate.switch(Menu)
        menuActive=1
      end
    end
end

--get that menu drawn!
function M.MenuDraw()
if menuOpen then
  menuF=love.graphics.newFont(14)
  love.graphics.setFont(menuF)
love.graphics.setColor(100,255,255,255)
love.graphics.rectangle("fill", mx*.75, my*.10, mx*.25, my*.30)
if menuActive==1 then
col[3]=col[1]
col[4]=col[2]
else
col[3]=col[2]
col[4]=col[1]
end
love.graphics.setColor(col[3])
love.graphics.print("Resume",px+5,py+10,0,2)
love.graphics.setColor(col[4])
love.graphics.print("Exit",px+5,py+50,0,2)
else
love.graphics.setColor(0,0,0,0)
love.graphics.rectangle("fill", mx, my, 50, 100)
end
end

--finally, let the interpreter have the functions
return M
