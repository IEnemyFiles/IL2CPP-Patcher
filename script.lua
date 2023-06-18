local Patcher = require("Patcher")

local il2cpp    = Patcher.getBaseAddr("libil2cpp.so")
local libunity  = Patcher.getBaseAddr("libunity.so")

local p = Patcher.new({
  title = "Enemy Saga By : -E-#4990",
})

p:add({
  name    = "Debug Overlay",
  address = il2cpp + 0xC8389C,
  patch   = "01 00 A0 E3 1E FF 2F E1r",
})

p:add({
  name    = "Diamond",
  address = il2cpp + 0x2185994,
  patch   = "12 07 80 E3 1E FF 2F E1r"
})

p:add({
  name    = "Level",
  address = il2cpp + 0x2185974,
  patch   = "01 08 A0 E3 1E FF 2F E1r"
})

p:add({
  name    = "VIP",
  address = il2cpp + 0x21859A4,
  patch   = "10 00 A0 E3 1E FF 2F E1r"
})

p:add({
  name    = "Currency",
  address = il2cpp + 0x2185984,
  patch   = "12 07 80 E3 1E FF 2F E1r"
})

p:run()
