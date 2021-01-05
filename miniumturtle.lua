--## Minium Turtle v1.2 ##--
--
-- (c) Stanley S. 2020-2021
--
-- Now on pastebin!
--  * https://pastebin.com/bZuGWZyR
--  * "pastebin get bZuGWZyR startup"
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
--       finally an item return directly
--       above the turtle's upper
--       location for returning
--       unexpected items and minium
--       stone output. Directly
--       below the turtle's lower
--       location is another container
--       for storing charcoal or fuel.
--   * This setup could be condensed to
--       one location without needing to
--       move vertically, but I wanted
--       it to look nice and fit in a
--       wall, so I designed it as such.
--   * Turtle can be disabled with a
--       redstone signal applied to its
--       right side.
--


-- Global Variables
local slot_fuel = 13
local slot_ingredient_top = 14  -- inert stone
local slot_ingredient_dust = 15 -- minium dust
local slot_product = 16         -- minium stone

local infuse_time = 10.5 -- 10 second smelt + .5 second delay to prevent EE3 weirdness.

local count_ingredient_top = 1  --   1 inert stone
local count_ingredient_dust = 8 -- + 8 minium dust
local count_product = 1         -- = 1 minium stone


-- Main
function Main()
  local completed = 0

  -- Reset, incase of unplanned restart
  Reset()

  while true do

  -- If wait need, wait
    while redstone.getInput("right") do
      os.sleep(1)
    end

  -- Get Materials
    getIngredient(1, count_ingredient_dust, slot_ingredient_dust)
    turtle.up()
    getIngredient(2, count_ingredient_top, slot_ingredient_top)

  -- Insert Ingredients
    turtle.turnLeft()
    turtle.select(2)
    turtle.drop(count_ingredient_top)
    turtle.select(1)
    turtle.drop(count_ingredient_dust)


  -- Collect Output
    os.sleep(infuse_time)
    turtle.select(3)
    turtle.suck(count_product)
    if not turtle.compareTo(slot_product) then
      print("Not expected product.")
    end
    turtle.dropUp(1)
    turtle.turnRight()
    turtle.down()
    completed = completed + 1
    print(completed.." completed.")
  end
end


-- Functions
function Reset()

  if redstone.getInput("left") then
    os.sleep(infuse_time) -- incase of restart during cook
    while turtle.suck() do end
    turtle.turnRight()
  end

  -- check if we have items to clear out
  local itemcount = 0
  for i=1,8 do
    itemcount = itemcount + turtle.getItemCount(i)
  end

  -- If we have items, return to top
  -- spot to drop of items in return.
  if itemcount>0 then
    if not redstone.getInput("back") then
      turtle.up()
    end

    for i=1,8 do
      if turtle.getItemCount(i)>0 then
        turtle.select(i)
        turtle.dropUp()
      end
    end
    turtle.down()

  -- Else there are no items to drop
  -- off, return to bottom instead.
  else
    if redstone.getInput("back") then
      turtle.down()
    end
  end

  Refuel()

  turtle.select(1)
end

function Refuel()
  if turtle.getFuelLevel()<15000 then
    turtle.select(5)
    turtle.suckDown(64)
    if not turtle.compareTo(slot_fuel) then
      if not turtle.refuel() then
        print("Unexpected non-fuel item in fuel input!")
        turtle.up()
        turtle.dropUp(turtle.getItemCount(5))
        turtle.down()
      end
    end
    turtle.refuel(turtle.getItemCount(5))
    print("Fuel Level Now: "..turtle.getFuelLevel())
  end
end

function getIngredient(slot, count, compare)
  turtle.select(slot)
  turtle.suck(count)
  while turtle.getItemCount(slot)<count do
    turtle.suck(count-turtle.getItemCount(slot))
  end
  if not turtle.compareTo(compare) then
    print("Not Expected Ingredients!")
    local wasDown = turtle.up()
    turtle.dropUp(turtle.getItemCount(slot))
    if wasDown then turtle.down() end
  end
  if turtle.getItemCount(slot)>count then
    turtle.drop(turtle.getItemCount(slot)-count)
  end
  turtle.select(slot+1)
  if turtle.getItemCount(slot+1)>0 then
    turtle.drop(turtle.getItemCount(slot+1))
  end
  turtle.select(slot)
end


-- Start running the actual code
Main()
