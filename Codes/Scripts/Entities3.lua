Entities={}
objects={}
entext="Not colliding."

oby=nil
keys={}
m=1

deb=false

--===============================P R E P  S T A R T===========================================--

--**********************************S T A N D A R D   B L O C K S*****************************************--

function Entities.prepObj(name,x,y,height,width,color,cls)
  objects[name]={}
  objects[name].x=x
  objects[name].y=y
  objects[name].h=height
  objects[name].w=width
  if type(color)=="string" then
    objects[name].color=love.graphics.newImage(color)
  else
    objects[name].color=color
  end
  objects[name].class=cls
  objects[name].ground=objects[name].y

  objects[name].left={objects[name].x-1,objects[name].y+1,objects[name].x-1,objects[name].y+objects[name].h-1}
  objects[name].right={objects[name].x+objects[name].w+1,objects[name].y+1,objects[name].x+objects[name].w+1,objects[name].y+objects[name].h-1}
  objects[name].top={objects[name].x+1,objects[name].y-1,objects[name].x+objects[name].w-1,objects[name].y-1}
  objects[name].bottom={objects[name].x+1,objects[name].y+objects[name].h+1,objects[name].x+objects[name].w-1,objects[name].y+objects[name].h+1}
end

--***********************************E N T I T I E S*****************************************--

function Entities.prepEntity(ename,src,x,y,cl,cls,spd,grv,jh)
  Trem.prepSound("bump","Media/Audio/Sound/bump.wav")
  objects[ename]={}
  objects[ename].x=x
  objects[ename].y=y
  objects[ename].source=love.graphics.newImage(src)
  objects[ename].h=objects[ename].source:getHeight()
  objects[ename].w=objects[ename].source:getWidth()
  objects[ename].color=cl
  objects[ename].class=cls
  objects[ename].speed=spd
  objects[ename].y_velocity=0
  objects[ename].gravity=grv
  objects[ename].ground=love.graphics.getHeight()-objects[ename].h
  objects[ename].jump_height=jh
  objects[ename].jump=false

  objects[ename].left={objects[ename].x,objects[ename].y,objects[ename].x,objects[ename].y+objects[ename].h}
  objects[ename].right={objects[ename].x+objects[ename].w,objects[ename].y,objects[ename].x+objects[ename].w,objects[ename].y+objects[ename].h}
  objects[ename].top={objects[ename].x,objects[ename].y,objects[ename].x+objects[ename].w,objects[ename].y}
  objects[ename].bottom={objects[ename].x,objects[ename].y+objects[ename].h,objects[ename].x+objects[ename].w,objects[ename].y+objects[ename].h}
end

--===============================P R E P  E N D===========================================--



--===============================C O L L I D E  S T A R T===========================================--


--*******************************C O L L I S I O N S*****************************************--

function Entities.collideBlock(entity,block)

-----------------------------------WINDOW--------------------------------------------

  if block=="window" then

    local ey=love.graphics.getHeight()
    local ex=love.graphics.getWidth()
    if objects[entity].x<=0 then
      if love.keyboard.isDown("left") and objects[entity].class=="player" and not menuOpen then
        Trem.playSound("bump")
      end
      objects[entity].x=0
    end
    if objects[entity].x>=ex-objects[entity].w then
      if love.keyboard.isDown("right") and objects[entity].class=="player" and not menuOpen then
        Trem.playSound("bump")
      end
      objects[entity].x=ex-objects[entity].w
    end
    if objects[entity].y<0 then
      if love.keyboard.isDown("up") and objects[entity].class=="player" and not menuOpen then
        Trem.playSound("bump")
      end
      objects[entity].y=0
    end
    if objects[entity].y>=ey-objects[entity].h then
      if love.keyboard.isDown("down") and objects[entity].class=="player" and not menuOpen then
        Trem.playSound("bump")
      end
      objects[entity].y=ey-objects[entity].h
    end

------------------------------PLATFORMS------------------------------------------------

  elseif objects[block].class=="platform" or objects[block].class=="ground" then

-------------------------------------Test--------------------------------------------------

    if Entities.touchOut(entity,block) then
      objects[entity].y=objects[entity].y
      objects[entity].x=objects[entity].x
    end

  else
    error(block.." is not a valid platform or object! Entities are handled by collideEntity.")
  end
end

--************************************T O U C H I N G- O U T E R*****************************************--

function Entities.touchOut(ent1,ent2)
    return (objects[ent1].x+objects[ent1].w)>=objects[ent2].x and
    objects[ent1].x<=objects[ent2].x+objects[ent2].w and
    (objects[ent1].y+objects[ent1].h)>=objects[ent2].y and
    objects[ent1].y<=objects[ent2].y+objects[ent2].h
end

--************************************T O U C H I N G- I N N E R*****************************************--

function Entities.touchElse(ent1,ent2,side)
  tp1=objects[ent2][side][1]
  tp2=objects[ent2][side][2]
  tp3=objects[ent2][side][3]
  tp4=objects[ent2][side][4]

  tdistance=math.sqrt((tp3-tp1)^2 + (tp4-tp2)^2)

  x1,x2,y1,y2=objects[ent1].x,objects[ent1].x+objects[ent1].w,objects[ent1].y,objects[ent1].y+objects[ent1].h

  if side=="left" then
    tx1=tp1
    tx2=tp1+1
    ty1=tp2
    ty2=tp2+tdistance
  elseif side=="right" then
    tx1=tp1+1
    tx2=tp1
    ty1=tp2
    ty2=tp2+tdistance
  elseif side=="top" then
    tx1=tp1
    tx2=tp1+tdistance
    ty1=tp2
    ty2=tp2+1
  elseif side=="bottom" then
    tx1=tp1
    tx2=tp1+tdistance
    ty1=tp2+1
    ty2=tp2
  end

  if x2<tx1 and x1>tx2 and y2<ty1 and y1>ty2 then
    return true
  end
end

--===============================C O L L I D E  E N D===========================================--



--************************************D R A W I N G*****************************************--

function Entities.draw(entity)
  love.graphics.setColor(objects[entity].color)
  if objects[entity].class==("player" or "monster") then
    love.graphics.draw(objects[entity].source,objects[entity].x,objects[entity].y)
  else
    love.graphics.rectangle("fill",objects[entity].x,objects[entity].y,objects[entity].w,objects[entity].h)
  end
end

--==================================M O V E M E N T==================================--

--************************************P L A Y E R************************************--

function Entities.movePlayer(dt)
  if not menuOpen and tdone then
    if love.keyboard.isDown("right") then
      objects["player"].x=objects["player"].x+(objects["player"].speed*dt)
    end
    if love.keyboard.isDown("left") then
      objects["player"].x=objects["player"].x-(objects["player"].speed*dt)
    end

----------------------------------JUMPING----------------------------------------

    if love.keyboard.isDown("up") then
      if not objects["player"].jump then
        objects["player"].y_velocity=objects["player"].jump_height
        objects["player"].jump=true
      end
    end


  if objects["player"].jump or objects["player"].y>objects["player"].ground then
    objects["player"].y=objects["player"].y+objects["player"].y_velocity*(dt*3)
    objects["player"].y_velocity= objects["player"].y_velocity-objects["player"].gravity*(dt*3)
  end

  if not objects["player"].jump then
    objects["player"].y=objects["player"].y+objects["player"].y_velocity*(dt*3)
    objects["player"].y_velocity= objects["player"].y_velocity-objects["player"].gravity*(dt*3)
  end


---------------------------------END JUMPING--------------------------------------------
  end
end

--************************************F L O A T************************************--

--figure out something here??c

--===============================B O U N D I N G  S T A R T===========================================--

--******************************D R A W I N G   B O U N D S*****************************************--

function Entities.bound(tobound)
  love.graphics.setColor({255,0,0,255})
  love.graphics.line(objects[tobound].left)
  love.graphics.line(objects[tobound].right)
  love.graphics.line(objects[tobound].top)
  love.graphics.line(objects[tobound].bottom)
end

--***************************U P D A T E   B O U N D S*****************************************--

function Entities.boundUpdate(entity)

  objects[entity].left={objects[entity].x,objects[entity].y,objects[entity].x,objects[entity].y+objects[entity].h}
  objects[entity].right={objects[entity].x+objects[entity].w,objects[entity].y,objects[entity].x+objects[entity].w,objects[entity].y+objects[entity].h}
  objects[entity].top={objects[entity].x,objects[entity].y,objects[entity].x+objects[entity].w,objects[entity].y}
  objects[entity].bottom={objects[entity].x,objects[entity].y+objects[entity].h,objects[entity].x+objects[entity].w,objects[entity].y+objects[entity].h}
end

--===============================B O U N D I N G  E N D===========================================--

--***************************D E B U G G I N G*****************************************--

function Entities.debug()
  if deb then
    love.graphics.setColor({255,255,255,255})
    love.graphics.print("Ground level: "..objects["player"].ground,0,0)
    love.graphics.print(text,0,15)
    love.graphics.print("Jumping: "..tostring(objects["player"].jump),0,30)
    love.graphics.print(objects["plat1"]["top"].tx1,0,40)
    love.graphics.print(objects["plat1"]["top"].tx2,0,50)
    love.graphics.print(objects["plat1"]["top"].ty1,0,60)
    love.graphics.print(objects["plat1"]["top"].ty2,0,70)
    love.graphics.print(objects["player"].x1,0,90)
    love.graphics.print(objects["player"].x2,0,100)
    love.graphics.print(objects["player"].y1,0,110)
    love.graphics.print(objects["player"].y2,0,120)
  end
end

return Entities
