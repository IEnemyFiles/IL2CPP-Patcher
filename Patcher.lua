local a,b,c,d=(function(e)local f={[{}]=true}local g;local h={}local require;local i={}g=function(j,k)if not h[j]then h[j]=k end end;require=function(j)local l=i[j]if l then if l==f then return nil end else if not h[j]then if not e then local m=type(j)=='string'and'\"'..j..'\"'or tostring(j)error('Tried to require '..m..', but no such module has been registered')else return e(j)end end;i[j]=f;l=h[j](require,i,g,h)i[j]=l end;return l end;return require,i,g,h end)(require)c("__root",function(require,n,c,d)local gg=require("lib.gg")local table=require("lib.table")local o=require("configs.config")local p=require("utils.util")local q={}q.__index=q;local r=241;local s="2.4.1"function q.new(t)local self=setmetatable({},q)self.values=table.new()self.config=setmetatable(t,{__index=o})return self end;function q.getVersions()return r,s end;function q.require(u)if not u then p.error("No version was provided")end;if u>r then p.error(string.format("The version of the Patcher is not compatible with the script. Script version: %s, Patcher version: %s",u,r))end end;function q.getHex(v,w)return gg.getHex(v,w)end;function q.patch(v,x,y,z)if z then gg.processPause()end;if not v then p.error("No address was provided")end;if not x then p.error("No hex was provided")end;gg.setHex(v,x:gsub(" ",""),y)if gg.isProcessPaused()then gg.processResume()end end;function q.getBaseAddr(A)if not A then p.error("No filter for the executable memory was provided")end;local B=gg.getRangesList(A)if#B==0 then goto C end;for D,E in ipairs(B)do if E.state=="Xa"then return E.start end end::C::p.error(string.format("Could not find executable memory for: %s",A))end;function q:add(F)local G=gg.getValue(F.address,gg.TYPE_QWORD)if not G then p.error(string.format("Could not find address: %s for value: %s",F.address,F.name))end;F=setmetatable(F,{__index=G})F.state=F.state or false;F.patch=F.patch:gsub(" ","")F.original=gg.getHex(F.address,#F.patch:sub(1,-2)/2)..gg.BIG_ENDIAN;table.insert(self.values,F)end;function q:run()if#self.values==0 then gg.alert("No values to run")return end;self.values:forEach(function(E)if E.patchOnStart then gg.toggleValue(E)end end)local function H()local I=self.values:map(function(E)return self.config.menuBuilder and self.config.menuBuilder(E,self.config)or p.concat(E.state and self.config.on or self.config.off," ",E.name)end)table.insert(I,"Actions Menu")local J=gg.choice(I,0,self.config.title)if not J then return end;if J==#I then return p.actionMenu(self.values)end;local F=self.values[J]gg.toggleValue(F)gg.toast(p.concat(F.state and self.config.on or self.config.off," ",F.name))end;if self.config.showUiButton then gg.keepAliveUiButton(H)end;gg.keepAlive(H)end;return q end)c("utils.util",function(require,n,c,d)local p={}p.actionMenu=function(K)gg.setVisible(true)local J=gg.choice({"Toggle All","Patch All","Restore All","Return to Main Menu","Exit Script"},0,"Actions Menu")if not J then return end;if J==1 then K:forEach(function(E)gg.toggleValue(E)end)return gg.toast("All values toggled")end;if J==2 then K:forEach(function(E)if not E.state then gg.toggleValue(E)end end)return gg.toast("All values patched")end;if J==3 then K:forEach(function(E)if E.state then gg.toggleValue(E)end end)return gg.toast("All values restored")end;if J==5 then local L=gg.alert("Are you sure you want to exit?","Yes","No")if L==1 then p.cleanExit()end end end;p.error=function(M)gg.alert(M,"Exit")error(M,0)end;p.toHex=function(N,O)return string.format("%s%X",O and"0x"or"",N)end;p.isHex=function(P)return string.match(P:gsub(" ",""),"^%x+$")~=nil end;p.concat=function(...)local P=""for D,E in ipairs({...})do P=P..E end;return P end;p.cleanExit=function()gg.setVisible(false)gg.clearList()gg.toast("Exiting...")os.exit()end;return p end)c("configs.config",function(require,n,c,d)local Q={}Q.on="[✓]"Q.off="[✗]"Q.title="Patcher"Q.showUiButton=false;return Q end)c("lib.table",function(require,n,c,d)table.new=function()return setmetatable({},{__index=table})end;table.map=function(R,S)local L=table.new()for T,E in pairs(R)do L[T]=S(E,T)end;return L end;table.forEach=function(R,S)for T,E in pairs(R)do S(E,T)end end;return table end)c("lib.gg",function(require,n,c,d)gg.BIG_ENDIAN="r"gg.LITTLE_ENDIAN="h"gg.getValue=function(v,U)local V,K=pcall(gg.getValues,{{address=v,flags=U}})if not V then return nil end;return K[1]end;gg.getHex=function(v,w)local F=gg.getValue(v,gg.TYPE_BYTE)if not F then return nil end;w=w or 8;local x=""for W=1,w do local E=F.value%256;if E<0 then E=E+256 end;x=x..string.format("%02X",E)F=gg.getValue(F.address+1,gg.TYPE_BYTE)end;return x end;gg.setHex=function(v,x,y)gg.sleep(100)local K={}for W=1,#x-1,2 do table.insert(K,{address=v,flags=gg.TYPE_BYTE,value=string.sub(x,W,W+1)..x:sub(-1)})v=v+1 end;if y then for W=1,#K do K[W].freeze=true end;gg.addListItems(K)return end;gg.setValues(K)end;gg.keepAlive=function(S)while true do if gg.isVisible()then gg.setVisible(false)S()end;gg.sleep(100)end end;gg.keepAliveUiButton=function(S)gg.showUiButton()while true do if gg.isClickedUiButton()then S()end;gg.sleep(100)end end;gg.toggleValue=function(F)if F.processPause then gg.processPause()end;if F.state then gg.setHex(F.address,F.original,F.freeze)else gg.setHex(F.address,F.patch,F.freeze)end;if gg.isProcessPaused()then gg.processResume()end;F.state=not F.state end;return gg end)return a("__root")
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
