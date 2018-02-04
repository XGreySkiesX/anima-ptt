local Flags={}
flaglist={}

Flag={
  val=false,
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
    if fetchcode~="" then
      table.insert(flaglist,o)
    end
    return o
  end
}

return Flags
