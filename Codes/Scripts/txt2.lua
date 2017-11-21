Txter={}

tdone=true
-- sets up the function's data storage
tstrings={} -- for properties
tchars={} -- for individual characters
ttext={} -- for the text to be written on the screen

--prepares a string and its properties
function Txter.prep(cd,str,dd,tres,tsound,ssound,size,colr,bcol,bwid,bhi)
  tdone=false
  tstrings.advnum=0 -- sets up an advancement system that will be used later
  Trem.prepSound("adv","Media/Audio/Sound/adv.wav")-- prepare the sound of advancement
  Trem.prepSound("cancel","Media/Audio/Sound/adv2.wav")-- prepare the sound for the end of the text block
  Trem.prepSound(tsound,"Media/Audio/Sound/Text/"..tsound..".wav")-- text sound for the text
  Trem.prepSound(ssound,"Media/Audio/Sound/Text/"..ssound..".wav")-- space sound for the text
  tchars[cd]={} -- set up the index of the characters
  tstrings[cd]={} -- set up the index for the properties
  tstrings[cd].delay=dd --the delay for the letters
  ttext[cd]="" --setup the text at the index
  tstrings.timer=0 --setup the timerr
  tstrings[cd].timerr=tres --the number that the timer will fall back to
  tstrings[cd].ii=1 --the index for the letters when cycling later
  tstrings[cd].index=1 --the index for putting the characters into tchars
  tstrings[cd].ts=tsound --sets the name of the sound for callback purposes
  tstrings[cd].ss=ssound --need the space sound too
  tstrings[cd].sh=false --short for "show"
  tstrings[cd].fnt=love.graphics.newFont(size) --sets the size of the text
  tstrings[cd].color=colr --Sets the color of the text
  tstrings[cd].boxc=bcol --the box color
  tstrings[cd].boxw=bwid --the box width
  tstrings[cd].boxh=bhi --the box height
  tstrings[cd].boxy=love.graphics.getHeight()-bhi --the starting y coordinate
  tstrings[cd].x=5 --the x of the text
  tstrings[cd].y=tstrings[cd].boxy+5 --the y of the text. Set 5 pixels below the top of the box
  tstrings[cd].boxy2=love.graphics.getHeight() --sets where the box will start from before being dragged up
  tstrings[cd].boxd=false --tells if the box is done animating
  tstrings[cd].done=false --sets if the text is finished
  -- inserts all the characters individually
  for char in str:gmatch('.') do
    mm=tstrings[cd].index
    tchars[cd][mm]=char
    tstrings[cd].index=tstrings[cd].index+1
  end
end

--updates the text so it knows what to type and what not to
function Txter.tUpd(cd,dt)
  if not tdone then
    tstrings.timer=tstrings.timer+dt --update the timer
    if tstrings.advnum~=0 then --make sure that it's been initiated
      if not tstrings[cd].boxd and tstrings[cd].sh then --if the box isn't done and the text is ready to be shown...
        if tstrings[cd].boxy2>tstrings[cd].boxy then --if the box isn't where it should be
          tstrings[cd].boxy2=tstrings[cd].boxy2-5 --make it where it should be
        else --or
          tstrings[cd].boxd=true --set the box as done
        end
      end
      if menuOpen then --make sure the menu isn't open- if it is....
        ttext[cd]=ttext[cd] -- don't change the text
        tstrings[cd].ii=tstrings[cd].ii --don't change this either
        tstrings[cd].boxy2=tstrings[cd].boxy2 -- don't change anything at all
      elseif tstrings.timer>=tstrings[cd].delay and tstrings[cd].ii<=#tchars[cd] and tstrings[cd].sh and tstrings[cd].boxd then --if the box is done, and the text can be shown,
        -- and the text isn't done yet, and the timer has reached the delay
        if tostring(tchars[cd][tstrings[cd].ii])==" " then --if the character being placed is a space...
          Trem.playSound(tstrings[cd].ss) --play space sound
        else --or
          Trem.playSound(tstrings[cd].ts) --play normal sound
        end
        ttext[cd]=ttext[cd]..tostring(tchars[cd][tstrings[cd].ii]) --add to the text being shown
        tstrings[cd].ii=tstrings[cd].ii+1 --increase the counter
        tstrings.timer=tstrings[cd].timerr --reset the timer
      elseif not tstrings[cd].sh then -- if the text isn't being shown..
        ttext[cd]="" --empty the text
        tstrings[cd].ii=1 --set the index to one again
        tstrings[cd].index=1 --and this index
      elseif tstrings[cd].ii>#tchars[cd] then --or if the text is done showing
        tstrings[cd].done=true --make sure we know it is
      end
    end
  end
end
--print the shite
function Txter.printT(cd)
  if not tdone and tstrings[cd].sh then --if all the text isn't done and the text is meant to be shown
    love.graphics.setColor(tstrings[cd].boxc)--set the color to the box
    love.graphics.rectangle("fill",0,tstrings[cd].boxy2,tstrings[cd].boxw,tstrings[cd].boxh) --draw the box
    love.graphics.setFont(tstrings[cd].fnt) --set the font
    love.graphics.setColor(tstrings[cd].color) --set the font color
    love.graphics.printf(ttext[cd],tstrings[cd].x,tstrings[cd].y,love.graphics.getWidth())--draw the text
  end
end

--set the text to be shown
function Txter.settf(cd,val)
  tstrings[cd].sh=val
end

--advance the text
function Txter.advance(ke)
  if ke=="a" then --if the right key is being pressed
    if tstrings.advnum~=0 and not tdone then --if the text isn't done yet
      if tstrings.advnum==#tstrings and tstrings[tstrings.advnum].done then --if the advancer is
        -- at the end
        Trem.playSound("cancel") --play the sound so they know it's the last of the text
      elseif tstrings.advnum<#tstrings and tstrings[tstrings.advnum].done then --else play the normal advance sound
        -- if the text is done
        Trem.playSound("adv")
      end
      if not tstrings[tstrings.advnum].done then --if the text isn't done yet
        tstrings[tstrings.advnum].delay=tstrings[tstrings.advnum].timerr --make the text go faster
      else
        if tstrings.advnum+1<=#tstrings then --if the next one won't go over the max level, then
          tstrings.advnum=tstrings.advnum+1 --advance
          for e in ipairs(tstrings) do --set all as false
            tstrings[e].sh=false
          end
            tstrings[tstrings.advnum].sh=true --except the one
          else
            tstrings[tstrings.advnum].sh=false --or set this as false
            tdone=true --and make sure everything is over
            tstrings={}
            tchars={}
            ttext={}
        end
      end
    end
  end
end

--for printing stats
function Txter.printadv(cd)
  if not tdone then
    love.graphics.setColor({255,255,255,255}) --set the color to white bc wynaut
    love.graphics.print(tstrings.advnum,0,30) --print the advance number
    love.graphics.print(tstrings[cd].ii,0,50) --print the index for the chosen text
    love.graphics.print(#tchars[cd],0,70) --print how many chars are in the chosen text
  end
end

--set the text to start going
function Txter.initiate()
    tstrings.advnum=1 --set the advance number
    tstrings[1].sh=true --show the first one
end

--finally, return everything
return Txter
