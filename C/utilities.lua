local Util={}

function Util.alreadyInTable(table,value,spec1,spec2)
  local temp=false
  for i,v in ipairs(table) do
    if spec1~=nil and spec2~=nil then
      if v[spec1]==value[spec2] then
        temp=true
      end
    elseif spec1~=nil and spec2==nil then
      if v[spec1]==value then
        temp=true
      end
    else
      if v==value then
        temp=true
      end
    end
  end
  return temp
end

function Util.getIndex(table,val,spec1)
  for i,v in ipairs(table) do
    if spec1==nil then
      if v==val then
        return i
      end
    else
      if v[spec]==val then
        return i
      end
    end
  end
end

return Util
