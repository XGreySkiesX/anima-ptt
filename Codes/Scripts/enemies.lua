-- Enemy Script --

Enem={}
Enemies={}
-- instead of doing crappy array stuff that only MIGHT work, how about we figure out,
--oh I dunno
--just starting each enemy and stuff
function Enem.startEnemy(ename,enx,eny,ewi,ehi,ecol)
  te=0
  for bleh in ipairs(Enemies) do
    te=te+1
  end
  if te~=0 then
    local g=te+1
    eExist=false
    for eng in ipairs(Enemies) do
      if Enemies[eng]==ename then
        counter=eng
        eExist=true
      end
    end
    if eExist then
      Enemies[counter].x=enx
      Enemies[counter].y=eny
      Enemies[counter].w=ewi
      Enemies[counter].h=ehi
      Enemies[counter].c=ecol
    else
        Enemies[g]={}
        Enemies[g].name=ename
        Enemies[g].x=enx
        Enemies[g].y=eny
        Enemies[g].w=ewi
        Enemies[g].h=ehi
        Enemies[g].c=ecol
      end
  else
    local g=1
    Enemies[g]={}
    Enemies[g].name=ename
    Enemies[g].x=enx
    Enemies[g].y=eny
    Enemies[g].w=ewi
    Enemies[g].h=ehi
    Enemies[g].c=ecol
  end
end

function Enem.drawEnemy(etd)
  tr=0
  for ed in ipairs(Enemies) do
    tr=tr+1
  end
  if tr~=0 then
    num=0
    for e in ipairs(Enemies) do
      num=num+1
      if Enemies[num].name==etd then
        love.graphics.setColor(Enemies[e].c)
        love.graphics.rectangle("fill",Enemies[e].x,Enemies[e].y,Enemies[e].w,Enemies[e].h)
      end
    end
  else
     return nil
  end
end

return Enem
