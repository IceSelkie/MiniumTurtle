--## Minium Turtle ##--
--
-- Calcinator
--   * can be done with itemDucts/
--       ioBuses
--   * top/sides = input diamond and 
--       output minium
--   * bottom = only side to input 
--       charcoal
--
-- Aludel
--   * Now this one is the harder part,
--       and what this program aims to
--       solve.
--   * When a player shift clicks minium
--       dust and inert stone into an
--       aludel, or other similar items,
--       they automatically lock to the
--       correct slots.
--   * However, when non-player objects
--       interact with it and put items
--       in, they go to the first non-
--       fuel open slot. Therefor, one
--       needs to be careful in
--       inserting items in. They must
--       go in in the exact right order,
--       and not overflow, or else it
--       might get clogged and require
--       a player to clean it out, or
--       have the turtle break it and
--       place it back down. AE's ME
--       systems have nondeterministic
--       item output order when using
--       ME Interfaces, thus care must
--       be taken.
--
--
-- Solution
--   * My solution to this issue is to
--       use the ME system to output the
--       required items into chests in
--       specific spots, which a turtle
--       can then grab from and interact
--       with an aludel and ensure the
--       items enter in the correct
--       order, thus end up in the
--       correct slots without breaking
--       the aludel.
-- Setup
--   * Turtle will be facing forward,
--       with a chest in front,
--       containing minium dust. Above
--       that chest is another
--       containing inert stones. These
--       can easily be autocrafted.
--       The aludle's bottom half will
--       be aligned with the top chest,
--       and be rotationally to the left
--       of the chest, with a redstone
--       block, to the left of that 
--       (opposite of the chest). This
--       redstone block can be used as a
--       marker for the turtle to
--       recover, should the turtle be
--       restarted, or the chunk gets
--       unexpectedly unloaded. And
--       finally a chest or DSU (deep
--       storage unit) directly above
--       the turtle's upper location for
--       minium stone output. Directly
--       below the turtle's lower
--       location is another container
--       for storing charcoal or fuel.
--   * This setup could be condensed to
--       one location without needing to
--       move vertically, but I wanted
--       it to look nice and fit in a
--       wall, so I designed it as such.
--

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
  ClearSlot(2)
  turtle.select(1)
  while turtle.getItemCount(1)<64 do
    turtle.suck(64)
  end
  turtle.select(2)
  if turtle.getItemCount(2)>0 then
    print("Too many diamonds. Dropping "..(turtle.getItemCount(2)).." items.")
    turtle.drop(turtle.getItemCount(2))
  end
  turtle.select(1)
  if not turtle.compareTo(14) then
    print("Not diamonds. Dropping "..turtle.getItemCount(1).." items.")
    ClearSlot(1)
  end
end

function GetCoal()
  ClearSlot(2)
  ClearSlot(3)
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

  -- turtle.select(2)
  -- if not turtle.compareTo(15) then
  --   print("Not Ready - not coal")
  --   return false
  -- end
  -- if turtle.getItemCount(2)<1 then
  --   print("Not Ready - too few coal")
  --   return false
  -- end
  print("Ready")
  return true
end

function PushInput()
  print("PushInput")
  SetDown()
  turtle.select(1)
  turtle.dropDown(64)
  -- turtle.select(2)
  -- turtle.dropDown(1)
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
  turtle.select(1)
  turtle.suckDown(64)
  PushOutput()
end

print("main")
PushOutput()
--while true do
Refuel()
GetDiamonds() --diamond
-- GetCoal() --charcoal
if Ready() then
  PushInput()
  os.sleep(641)
  GetMinium() --minium
end
SetDown()
--end