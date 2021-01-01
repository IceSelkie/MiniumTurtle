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
    print("Moving Up")
    turtle.up()
  else
    print("Not Moving Up")
  end
end

function SetDown()
  if redstone.getInput("left") then
    print("Moving Down")
    turtle.down()
  else
    print("Not Moving Down")
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
  print("GetDiamonds")
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
  print("GetCoal")
  ClearSlot(2)
  turtle.select(2)
  SetDown()
  turtle.suck(1)
  if turtle.getItemCount(2)>1 then
    print("Too many coal. Dropping "..(turtle.getItemCount(1)-8).." items.")
    turtle.drop(turtle.getItemCount(2)-1)
  end
  if not turtle.compareTo(15) then
    print("Not coal. Dropping "..turtle.getItemCount(1).." items.")
    ClearSlot(2)
  end
end

function Ready()
  print("Ready")
  turtle.select(1)
  if not turtle.compareTo(14) then
    return false
  end
  if turtle.getItemCount(1)<8 then
    return false
  end

  turtle.select(2)
  if not turtle.compareTo(15) then
    return false
  end
  if turtle.getItemCount(2)<1 then
    return false
  end

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

print("main")
PushOutput()
--while true do
GetDiamonds() --diamond
GetCoal() --charcoal
--if Ready() then
--  PushInput()
--  os.sleep(81)
--  GetMinium() --minium
--end
--PushOutput()
--end