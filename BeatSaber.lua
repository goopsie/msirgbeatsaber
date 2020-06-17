local bluenote = {["r"] = 0x0, ["g"] = 0x0, ["b"] = 0xf}
local rednote  = {["r"] = 0xf, ["g"] = 0x0, ["b"] = 0x0}
local bomb     = {["r"] = 0x4, ["g"] = 0x4, ["b"] = 0x4} -- don't know if this ever actually shows, don't care, fuck you

local pulseTime = 14 -- This isn't milliseconds, Change it to whatever looks good to you
local tempFilePath  = "C:/Users/Goopsie/Desktop/Py-Lua.txt" -- change this to a good directory

Lighting.SetAllEnabled(true)
Lighting.SetFlashingSpeed(0)
Lighting.SetBreathingModeEnabled(false)

function getSlashedBlock() -- Uli wrote practically all of this, Thank you!
  while true do
    local file = assert(io.open(tempFilePath, "r"))
    local contents = file:read "*a"
    file:close()

    local i = string.gmatch(contents, "%S+")
    color = i()
    n = i()
    if color ~= nil and n ~= nil then
      return color, assert(tonumber(n), "Failed to convert " .. tostring(n) .. " to a number")
    end
  end
end

local fade = false
local lastid = 0

local function loop() -- thank you for helping me, uli
  local _, noteid = getSlashedBlock()
  if fade and noteid == lastid then
    print("Fading colors")

    local color, noteid = getSlashedBlock()
    if noteid ~= lastid then print('Oh, '..color.." note hit while fading") return end
    local r, g, b = Lighting.getColour(1)

    if r == 0 and g == 0 and b == 0 then -- stop if rgb is off
      fade = false
      print('Finished fading colors')
      return
    end

    -- Decrease the RGB lighting values
    if r > 0 then r = r -1 end
    if g > 0 then g = g -1 end
    if b > 0 then b = b -1 end
    print(r,g,b)
    Lighting.BatchBegin() -- Waits until BatchEnd() before sending data to rgb controller
    for i=1,8 do -- Set every possible color
      Lighting.setColour(i, r, g, b)
    end
    Lighting.BatchEnd()

    os.sleep(pulseTime) -- i don't know if this is good or not, feel free to replace with waituntilblockslashed()

    return

  end

  if noteid == lastid then
    if fade == false then os.sleep(15) return else return end
  end -- Do nothing if the note hasn't changed

  if color == "Blue" then
    print("Blue Note hit")
    r, g, b = Lighting.getColour(1)
    Lighting.BatchBegin()
    for i=1,8 do
      Lighting.SetColour(i, r, g, bluenote.b)
    end
    Lighting.BatchEnd()
    fade = true -- Make sure we fade the note
    lastid = noteid

  elseif color == "Red" then
    print("Red Note hit")
    r, g, b = Lighting.getColour(1)
    Lighting.BatchBegin()
    for i=1,8 do
      Lighting.setColour(i, rednote.r, g, b)
    end
    Lighting.BatchEnd()
    fade = true
    lastid = noteid

  elseif color == "Bomb" then
    print("Bomb hit")
    Lighting.BatchBegin()
    for i=1,8 do
      Lighting.setColour(i, bomb.r, bomb.g, bomb.b)
    end
    Lighting.BatchEnd()
    fade = true
    lastid = noteid
  end

end

while true do loop() end
