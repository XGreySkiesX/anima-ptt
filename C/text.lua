local Text={}

TextBox={
  x=0,
  y=0,
  w=100,
  h=100,
  rad=10,
  string="default string",
  asrc="M/Audio/Sound/adv3.wav",
  csrc="M/Audio/Sound/cancel.wav",
  tsrc="M/Audio/Sound/Text/txt4.wav",
  ssrc="M/Audio/Sound/Text/spc4.wav",
  fetchcode="",
  vol=0.5,
  t=0,
  delay=0.2,
  active=false,
  c={255,255,255,255},
  tc={0,0,0,255},
  ts=16,
  y=500,
  h=100,
  td=false,
  bd=false,
  index=1,
  text="",
  paused=false,
  new=function(self,o)
    local o=o or {}
    setmetatable(o,self)
    self.__index=self
    o.chars={}
    o.tempdelay=o.delay
    if o.string~="" then
      for char in o.string:gmatch('.') do
        table.insert(o.chars,char)
      end
    end
    o.advance=SFX:new{src=o.asrc}
    o.cancel=SFX:new{src=o.csrc}
    o.ssound=SFX:new{src=o.ssrc}
    o.tsound=SFX:new{src=o.tsrc}
    return o
  end,
  update=function(self,dt)
    if self.active and not self.bd and not self.paused then
      if self.y>love.graphics.getHeight()-self.h then
        self.y=(self.y-(10))
      else
        self.bd=true
      end
    elseif self.active and self.bd and self.td~=true and self.paused~=true then
      self.t=self.t+dt
      if self.t>self.delay then
        if self.chars[self.index]==" " then
          self.ssound:play(self.vol)
        else
          self.tsound:play(self.vol)
        end
        self.text=self.text..self.chars[self.index]
        self.t=0
        if self.index==#self.chars then
          self.td=true
        else
          self.index=self.index+1
        end
      end
    end
  end,
  draw=function(self)
    if self.active then
      love.graphics.setColor(self.c)
      love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,self.rad)
      love.graphics.setColor(self.tc)
      love.graphics.setNewFont(self.ts)
      love.graphics.printf(self.text,self.x+5,self.y+5,self.w)
    end
  end,
  hide=function(self)
    self.active=false
    self.hidden=true
  end,
  show=function(self)
    self.active=true
    self.hidden=false
  end,
  reset=function(self)
    self.text=""
    self.index=1
    self.td=false
    self.bd=false
    self.y=self.y+self.h
    self.t=0
    self.delay=self.tempdelay
  end,
  pause=function(self)
    self.paused=true
  end,
  unpause=function(self)
    self.paused=false
  end,
  setpaused=function(self,val)
    self.paused=val
  end
}

CharacterBox=TextBox:new{
  imgsrc="M/Graphics/Sprites/TSs/default.png",
  charname="default",
  tsrc="M/Audio/Sound/Text/txt.wav",
  ssrc="M/Audio/Sound/Text/spc.wav",
  new=function(self,o)
    local o=o or {}
    setmetatable(o,self)
    self.__index=self
    o.chars={}
    o.tempdelay=o.delay
    if o.string~="" then
      for char in o.string:gmatch('.') do
        table.insert(o.chars,char)
      end
    end
    o.img=love.graphics.newImage(o.imgsrc)
    o.advance=SFX:new{src=o.asrc}
    o.cancel=SFX:new{src=o.csrc}
    o.ssound=SFX:new{src=o.ssrc}
    o.tsound=SFX:new{src=o.tsrc}
    return o
  end,
  draw=function(self)
    if self.active then
      love.graphics.setColor(self.c)
      love.graphics.rectangle("fill",0,self.y,love.graphics.getWidth(),self.h)
      love.graphics.rectangle("fill",love.graphics.getWidth()-200,self.y-20,200,20)
      love.graphics.setColor(self.tc)
      love.graphics.setNewFont(self.ts)
      love.graphics.printf(self.text,self.img:getWidth()+10,self.y+5,love.graphics.getWidth()-(self.img:getWidth()+10))
      love.graphics.print(self.charname,love.graphics.getWidth()-195,self.y-20)
      love.graphics.setColor({255,255,255,255})
      love.graphics.draw(self.img,5,self.y+((self.h/2)-(self.img:getHeight()/2)))
    end
  end
}

function Text.getCurrentBox(option)
  if advnum>0 then
    if option==nil then
      return MessageBoxes[advnum]
    else
      if MessageBoxes[advnum][option]~=nil then
        return MessageBoxes[advnum][option]
      else
        return MessageBoxes[advnum]
      end
    end
  else
    return "none"
  end
end

--finally, return everything
return Text
