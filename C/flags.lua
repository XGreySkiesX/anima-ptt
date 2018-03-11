Flag={
  val=false,
  name="flag1",	
  set=function(self,val)
    self.val=val
  end,
  get=function(self)
    return self.val
  end,
  new=function(self,o)
    local o=o or {}
    setmetatable(o,self)
    self.__index=self
    return o
  end
}
