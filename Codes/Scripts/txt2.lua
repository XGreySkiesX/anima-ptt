Text={}

Tboxes={}
tdone=true
advnum=1

Textbox={
  string="default string",
  advance=Sounds.prepSound("Media/Audio/Sound/adv.wav"),
  cancel=Sounds.prepSound("Media/Audio/Sound/adv2.wav"),
  tsound=Sounds.prepSound("Media/Audio/Sound/Text/txt1.wav"),
  tsound=Sounds.prepSound("Media/Audio/Sound/Text/spc1.wav"),
  fetchcode="",
  t=0,
  delay=0.1,
  active=false,
  c={255,255,255,255},
  tc={0,0,0,255},
  ts=16,
  y=0,
  h=0,
  td=false,
  bd=false,
  index=1,
  text="",
  new=function(self,o)
    tdone=false
    local o=o or {}
    setmetatable(o,self)
    self.__index=self
    o.chars={}
    if o.string~="" then
      for char in str:gmatch('.') do
        table.insert(o.chars,char)
      end
    end
    if o.ssound~="" then
      o.ssound=Sounds.prepSound("Media/Audio/Sound/Text"..o.ssound..".wav")
    end
    if o.tsound=="" then
      o.tsound=Sounds.prepSound("Media/Audio/Sound/Text"..o.tsound..".wav")
    end
    if o.fetchcode~="" then
      table.insert(Tboxes,o)
    end
    return o
  end,
  update=function(self,dt)
    if self.active and self.bd and not self.td and not tdone then
      self.t=self.t+dt
      if self.t>self.delay then
        if self.chars[self.index]==" " then
          self.ssound:play()
        else
          self.tsound:play()
        end
        self.text=self.text..self.chars[self.index]
        self.t=0
        if self.index==#self.chars then
          self.td=true
        else
          self.index=self.index+1
        end
      end
    elseif self.active and not self.bd then
      if self.y>love.graphics.getHeight()-self.h then
        self.y=self.y-(love.graphics.getHeight()-self.h)/dt
      else
        self.bd=true
      end
    end
  end,
  draw=function(self)
    if self.active then
      love.graphics.setColor(self.c)
      love.graphics.rectangle("fill",0,self.y,love.graphics.getWidth(),self.h)
      love.graphics.setColor(self.tc)
      love.graphics.setFont(self.ts)
      love.graphics.printf(self.text,5,self.y+5,love.graphics.getWidth())
    end
  end
}

--updates the text so it knows what to type and what not to
function Text.tUpd(cd,dt)
  if not tdone then
    tstrings.timer=tstrings.timer+dt --update the timer
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
--print the shite
function Text.printT(cd)
  if not tdone and tstrings[cd].sh then --if all the text isn't done and the text is meant to be shown
    love.graphics.setColor(tstrings[cd].boxc)--set the color to the box
    love.graphics.rectangle("fill",0,tstrings[cd].boxy2,tstrings[cd].boxw,tstrings[cd].boxh) --draw the box
    love.graphics.setFont(tstrings[cd].fnt) --set the font
    love.graphics.setColor(tstrings[cd].color) --set the font color
    love.graphics.printf(ttext[cd],tstrings[cd].x,tstrings[cd].y,love.graphics.getWidth())--draw the text
  end
end

--set the text to be shown
function Text.settf(cd,val)
  tstrings[cd].sh=val
end

--advance the text
function Text.advance(ke)
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

--set the text to start going
function Text.initiate()
    tdone=false
    advnum=0
end

function Text.draw()
  while not tdone do
    Tboxes[advnum]:draw()
    Tboxes[advnum]:update()
  end
end

function Text.advance(k)
  if k=="a" then
    if Tboxes[advnum].done then
      Tboxes[advnum]:hide()
      advnum=advnum+1
    else
      Tboxes[advnum].delay=0.1
    end
  end
end

function Text.clear()
  Tboxes={}
end

--finally, return everything
return Text
