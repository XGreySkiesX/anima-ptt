Txter={}

tstrings={}
tchars={}
ttext={}
tadv={}

function Txter.prep(cd,str,dd,tres,tsound,ssound,tf,size,colr,bcol,bwid,bhi)
  advnum=1
  Trem.prepSound("adv","Media/Audio/Sound/adv.wav")
  Trem.prepSound("adv2","Media/Audio/Sound/cancel.wav")
  Trem.prepSound(tsound,"Media/Audio/Sound/Text/"..tsound..".wav")
  Trem.prepSound(ssound,"Media/Audio/Sound/Text/"..ssound..".wav")
  tchars[cd]={}
  tstrings[cd]={}
  tstrings[cd].code=cd
  tstrings[cd].delay=dd
  ttext[cd]=""
  tstrings.timer=0
  tstrings[cd].timerr=tres
  tstrings[cd].ii=1
  tstrings[cd].index=1
  tstrings[cd].ts=tsound
  tstrings[cd].ss=ssound
  tstrings[cd].sh=tf
  tstrings[cd].fnt=love.graphics.newFont(size)
  tstrings[cd].color=colr
  tstrings[cd].boxc=bcol
  tstrings[cd].boxw=bwid
  tstrings[cd].boxh=bhi
  tstrings[cd].boxy=love.graphics.getHeight()-bhi
  tstrings[cd].x=5
  tstrings[cd].y=tstrings[cd].boxy+5
  tstrings[cd].boxy2=love.graphics.getHeight()
  tstrings[cd].boxd=false
  tstrings[cd].done=false
  for char in str:gmatch('.') do
    mm=tstrings[cd].index
    tchars[cd][mm]=char
    tstrings[cd].index=tstrings[cd].index+1
  end
end


function Txter.tUpd(cd,dt)
      tstrings.timer=tstrings.timer+dt
      if not tstrings[cd].boxd and tstrings[cd].sh then
        if tstrings[cd].boxy2>tstrings[cd].boxy then
          tstrings[cd].boxy2=tstrings[cd].boxy2-5
        else
          tstrings[cd].boxd=true
        end
      end
      if menuOpen then
        ttext[cd]=ttext[cd]
        tstrings[cd].ii=tstrings[cd].ii
        tstrings[cd].boxy2=tstrings[cd].boxy2
      elseif tstrings.timer>=tstrings[cd].delay and tstrings[cd].ii<=#tchars[cd] and tstrings[cd].sh and tstrings[cd].boxd then
        ttext[cd]=ttext[cd]..tostring(tchars[cd][tstrings[cd].ii])
        if tostring(tchars[cd][tstrings[cd].ii])==" " then
          Trem.playSound(tstrings[cd].ss)
        else
          Trem.playSound(tstrings[cd].ts)
        end
        tstrings[cd].ii=tstrings[cd].ii+1
        tstrings.timer=tstrings[cd].timerr
      elseif not tstrings[cd].sh then
        ttext[cd]=""
        tstrings[cd].ii=1
        tstrings[cd].index=1
        tstrings[cd].done=true
      elseif tstrings[cd].ii>=#tchars[cd] then
        tstrings[cd].done=true
  end
end

function Txter.printT(cd)
  if not tdone and tstrings[cd].sh then
    love.graphics.setColor(tstrings[cd].boxc)
    love.graphics.rectangle("fill",0,tstrings[cd].boxy2,tstrings[cd].boxw,tstrings[cd].boxh)
    love.graphics.setFont(tstrings[cd].fnt)
    love.graphics.setColor(tstrings[cd].color)
    love.graphics.printf(ttext[cd],tstrings[cd].x,tstrings[cd].y,love.graphics.getWidth())
  end
end

function Txter.settf(cd,val)
  tstrings[cd].sh=val
end

function Txter.advance(ke)
  if ke=="z" then
    if not tdone and tstrings[advnum].done then
      advnum=advnum+1
      if advnum>=1 and advnum<=#tadv+1 and not tdone then
        if advnum==#tadv+1 then
          Trem.playSound("adv2")
        else
          Trem.playSound("adv")
        end
      end
      if advnum<=#tadv and not tdone then
        if advnum<=#tadv then
          for e in ipairs(tadv) do
            tstrings[e].sh=false
          end
          tstrings[advnum].sh=true
        end
      else
        for e in ipairs(tadv) do
          tstrings[e].sh=false
          end
          tdone=true
          advnum=1
      end
    else
      tstrings[advnum].delay=tstrings[advnum].timerr
    end
  end
end

function Txter.printadv(cd)
  love.graphics.setColor({255,255,255,255})
  love.graphics.print(advnum,0,30)
  love.graphics.print(tstrings[cd].ii,0,50)
  love.graphics.print(#tchars[cd],0,70)
end

return Txter
