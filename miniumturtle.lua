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
  print("PushOutput")
  SetUp()
  turtle.select(1)
  turtle.dropUp()
  turtle.select(2)
  turtle.dropUp()
  turtle.select(3)
  turtle.dropUp()
  turtle.select(4)
  turtle.dropUp()
  turtle.select(5)
  turtle.dropUp()
end

function ClearSlot(slot)
  --print("ClearSlot("..slot..")")
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
  if turtle.getItemCount(1)>8 then
    print("Too many diamonds. Dropping "..(turtle.getItemCount(1)-8).." items.")
    turtle.drop(turtle.getItemCount(1)-8)
  end
  if not turtle.compareTo(14) then
    print("Not diamonds. Dropping "..turtle.getItemCount(1).." items.")
    ClearSlot(1)
  end
end

function GetCoal()
  ClearSlot(2)
  turtle.select(2)
  SetDown()
  turtle.suck(1)
  if turtle.getItemCount(2)>1 then
    print("Too many coal. Dropping "..(turtle.getItemCount(2)-1).." items.")
    turtle.drop(turtle.getItemCount(2)-1)
  end
  if not turtle.compareTo(15) then
    print("Not coal. Dropping "..turtle.getItemCount(2).." items.")
    ClearSlot(2)
  end
end

function Ready()
  turtle.select(1)
  if not turtle.compareTo(14) then
    print("Not Ready - not diamond")
    return false
  end
  if turtle.getItemCount(1)<8 then
    print("Not Ready - too few diamond")
    return false
  end

  turtle.select(2)
  if not turtle.compareTo(15) then
    print("Not Ready - not coal")
    return false
  end
  if turtle.getItemCount(2)<1 then
    print("Not Ready - too few coal")
    return false
  end
  print("Ready")
  return true
end

function PushInput()
  print("PushInput")
  SetDown()
  turtle.select(1)
  turtle.dropDown(8)
  turtle.select(2)
  turtle.dropDown(1)
end

function Refuel()
  if turtle.getFuelLevel()<1000 then
    SetDown()
    turtle.select(5)
    turtle.suck(64)
    turtle.refuel(64)
    print("Fuel Level Now: "..turtle.getFuelLevel())
  else
    print("Fuel Level Okay ("..turtle.getFuelLevel().."). Continuing...")
  end
end

function GetMinium()
  turtle.suckDown(8)
  PushOutput()
end

print("main")
PushOutput()
--while true do
Refuel()
GetDiamonds() --diamond
GetCoal() --charcoal
if Ready() then
  PushInput()
  os.sleep(81)
  GetMinium() --minium
end
MoveDown()
--end