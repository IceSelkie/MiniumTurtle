--Minium Program:
--
--get diamond & charcoal
--push diamond, push charcoal
--wait
--pull minium
--
--
--needs: 
--  input: coal, diamonds, redstone
--  output: return
--  machine: calcinator
--
--.D.   diam
--BTC   coal & redstone block marker
--RTR   redstone input & return
--.C.   calcinator

PushOutput()
while true do
  if redstone.getInput("back") then
    GetDiamonds() --diamond
    GetCoal() --charcoal
    if Ready() then
      PushInput()
      os.sleep(81)
      GetMinium() --minium
    end
    PushOutput()
  end
end

function SetUp()
  if not redstone.getInput("left") then
    turtle.up()
  end
end

function SetDown()
  if redstone.getInput("left") then
    turtle.down()
  end
end

function PushOutput()
  ClearSlot(1)
  ClearSlot(2)
  ClearSlot(3)
  ClearSlot(4)
end

function ClearSlot(slot)
  if turtle.getItemCount(slot)>0 then
    SetUp()
    turtle.select(slot)
    turtle.dropUp()
  end
end

function GetDiamonds()
  SetUp()
  ClearSlot(1)
  turtle.select(1)
  turtle.suck(8)
  if turtle.getItemCount()>8 then
    turtle.drop(turtle.getItemCount()-8)
  end
  if not turtle.compareTo(14) then
    ClearSlot(1)
  end
end

function GetCoal()
  ClearSlot(2)
  turtle.select(2)
  SetDown()
  turtle.suck(1)
  if turtle.getItemCount()>1 then
    turtle.drop(turtle.getItemCount()-1)
  end
  if not turtle.compareTo(15) then
    ClearSlot(2)
  end
end

function Ready()
  turtle.select(1)
  if not turtle.compareTo(14) then
    return false
  end
  if turtle.getItemCount()<8 then
    return false
  end

  turtle.select(2)
  if not turtle.compareTo(15) then
    return false
  end
  if turtle.getItemCount()<1 then
    return false
  end

  return true
end

function PushInput()
  SetDown()
  turtle.select(1)
  turtle.dropDown(8)
  turtle.select(2)
  turtle.dropDown(1)
end