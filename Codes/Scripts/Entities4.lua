Entities={}
objects={}
text="Not colliding."

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

  objects[name].left={objects[name].x-1,objects[name].y,objects[name].x-1,objects[name].y+objects[name].h}
  objects[name].right={objects[name].x+objects[name].w+1,objects[name].y,objects[name].x+objects[name].w+1,objects[name].y+objects[name].h}
  objects[name].top={objects[name].x,objects[name].y-1,objects[name].x+objects[name].w,objects[name].y-1}
  objects[name].bottom={objects[name].x,objects[name].y+objects[name].h+1,objects[name].x+objects[name].w,objects[name].y+objects[name].h+1}
end

--***********************************E N T I T I E S*****************************************--

function Entities.prepEntity(ename,src,px,py,cl,cls,spd,grv,jh)
  Trem.prepSound("bump","Media/Audio/Sound/bump.wav")
  objects[ename]={}
  objects[ename].x=px
  objects[ename].y=py
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

  objects[ename].isLeftCol=false
  objects[ename].isRightCol=false
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

-------------------------------------LEFT--------------------------------------------------

    if Entities.touchOut(entity,block,"left") then
      if objects[entity].class=="player" then
        if love.keyboard.isDown("right") and not menuOpen then
          Trem.playSound("bump")
        end
        objects["player"].isLeftCol=true
      end
      objects[entity].x=objects[block].x-objects[entity].w
      text="Colliding with "..block.."'s left side."

-------------------------------------RIGHT--------------------------------------------

    elseif Entities.touchOut(entity,block,"right") then
      if love.keyboard.isDown("left") and objects[entity].class=="player" and not menuOpen then
        Trem.playSound("bump")
      end
      objects[entity].x=objects[block].x+objects[block].w
      text="Colliding with "..block.."'s right side."

---------------------------------------TOP---------------------------------------------

    elseif Entities.touchOut(entity,block,"top") then
      if love.keyboard.isDown("down") and objects[entity].class=="player" and not menuOpen then
        Trem.playSound("bump")
      end
      objects[entity].y=objects[block].y-objects[entity].h
      text="Colliding with "..block.."'s top."
      objects[entity].ground=objects[block].y-objects[entity].h
      objects[entity].jump=false
      objects[entity].y_velocity=0

----------------------------------------BOTTOM-----------------------------------------------------------------

    elseif Entities.touchOut(entity,block,"bottom") then
      if love.keyboard.isDown("up") and objects[entity].class=="player" and not menuOpen then
        Trem.playSound("bump")
      end
      objects[entity].y=objects[block].y+objects[block].h
      text="Colliding with "..block.."'s bottom."



    end

-----------------------------------------------------------------------------------------------------------------

  else
    error(block.." is not a valid platform or object! Entities are handled by collideEntity.")
  end
end

--************************************T O U C H I N G- O U T E R*****************************************--

function Entities.touchOut(ent1,ent2,side)
  objects[ent2][side].tp1=objects[ent2][side][1]
  objects[ent2][side].tp2=objects[ent2][side][2]
  objects[ent2][side].tp3=objects[ent2][side][3]
  objects[ent2][side].tp4=objects[ent2][side][4]

  objects[ent1].x1,objects[ent1].x2,objects[ent1].y1,objects[ent1].y2=objects[ent1].x,objects[ent1].x+objects[ent1].w,objects[ent1].y,objects[ent1].y+objects[ent1].h

  if side=="left" then
    objects[ent2][side].tx1=objects[ent2][side].tp1
    objects[ent2][side].tx2=objects[ent2][side].tp3
    objects[ent2][side].ty1=objects[ent2][side].tp2
    objects[ent2][side].ty2=objects[ent2][side].tp4
  elseif side=="right" then
    objects[ent2][side].tx1=objects[ent2][side].tp1
    objects[ent2][side].tx2=objects[ent2][side].tp3
    objects[ent2][side].ty1=objects[ent2][side].tp2
    objects[ent2][side].ty2=objects[ent2][side].tp4
  elseif side=="top" then
    objects[ent2][side].tx1=objects[ent2][side].tp1
    objects[ent2][side].tx2=objects[ent2][side].tp3
    objects[ent2][side].ty1=objects[ent2][side].tp2
    objects[ent2][side].ty2=objects[ent2][side].tp4
  elseif side=="bottom" then
    objects[ent2][side].tx1=objects[ent2][side].tp1
    objects[ent2][side].tx2=objects[ent2][side].tp3
    objects[ent2][side].ty1=objects[ent2][side].tp2
    objects[ent2][side].ty2=objects[ent2][side].tp4
  end

  if objects[ent1].x2>objects[ent2][side].tx1 and objects[ent1].x1<objects[ent2][side].tx2 and objects[ent1].y2>objects[ent2][side].ty1 and objects[ent1].y1<objects[ent2][side].ty2 then
    return true
  end
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
      objects["player"].x=objects["player"].x+math.floor(objects["player"].speed*dt)
    end
    if love.keyboard.isDown("left") then
      objects["player"].x=objects["player"].x-math.floor(objects["player"].speed*dt)
    end

----------------------------------JUMPING----------------------------------------

    if love.keyboard.isDown("up") then
      if not objects["player"].jump then
        objects["player"].y_velocity=objects["player"].jump_height
        objects["player"].jump=true
      end
    end


  if objects["player"].jump or objects["player"].y>objects["player"].ground then
    objects["player"].y=objects["player"].y+math.floor(objects["player"].y_velocity*(dt*3))
    objects["player"].y_velocity= objects["player"].y_velocity-math.floor(objects["player"].gravity*(dt*3))
  end

  if not objects["player"].jump then
    objects["player"].y=objects["player"].y+math.floor(objects["player"].y_velocity*(dt*3))
    objects["player"].y_velocity= objects["player"].y_velocity-math.floor(objects["player"].gravity*(dt*3))
  end


---------------------------------END JUMPING--------------------------------------------
  end
end

--************************************F L O A T************************************--

--figure out something here??c

--===============================B O U N D I N G  S T A R T===========================================--

--******************************D R A W I N G   B O U N D S*****************************************--

function Entities.bound(tobound)
  love.graphics.setColor({0,255,0,255})
  love.graphics.line(objects[tobound].left)
  love.graphics.line(objects[tobound].right)
  love.graphics.line(objects[tobound].top)
  love.graphics.line(objects[tobound].bottom)
end

--***************************U P D A T E   B O U N D S*****************************************--

function Entities.boundUpdate(entity)
  objects[entity].x=objects[entity].x
  objects[entity].y=objects[entity].y

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
    love.graphics.print("Ground level: "..objects["player"].ground,0,20)
    love.graphics.print(text,0,40)
    love.graphics.print("Jumping: "..tostring(objects["player"].jump),0,60)
    love.graphics.print("Upper plat's right side:"..objects["plat2"]["right"].tx1.." "..objects["plat2"]["right"].tx2.." "..objects["plat2"]["right"].ty1.." "..objects["plat2"]["right"].ty2,0,80)
    love.graphics.print("Player:"..objects["player"].x1.." "..objects["player"].x2.." "..objects["player"].y1.." "..objects["player"].y2,0,100)

  end
end

return Entities
