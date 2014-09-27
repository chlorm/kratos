local io = io
local pcall = pcall
local math = math
require("lfs")
local lfs = lfs
local string = string
local root_dir = "/sys/class/power_supply"

module("battery")
function read_file(file)
   local handle = io.open(file, "r")
   if handle == nil then
      error("Failed to Read Battery File", 2)
   end
   local txt = handle:read()
   handle:close()
   return txt
end

function get_state ()
   local bat_file = nil
   for file in lfs.dir(root_dir) do
      if string.find(file, "BAT") ~= nil then
         bat_file = root_dir.."/"..file
         break
      end
   end
   if bat_file == nil then
      error("No Battery Detected", 1)
   end

   local charge_max = read_file(bat_file.."/charge_full")
   local charge = read_file(bat_file.."/charge_now")
   local status = read_file(bat_file.."/status")

   local percent = math.floor(charge * 100 / charge_max)

   if status:match("Charging") then
      stat = "↑"
   elseif status:match("Discharging") then
      stat = "↓"
   else
      stat = "⚡"
   end
   return percent, stat
end

function get_text ()
   local success, percent, stat = pcall(get_state)
   if success == false then
      return ""
   end
   return " "..stat..percent.."%"
end
