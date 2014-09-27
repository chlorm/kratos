local f = loadfile("/usr/share/awesome/themes/zenburn/theme.lua")
if not f then
	f = loadfile("/usr/local/share/awesome/themes/zenburn/theme.lua")
end
if not f then
	error("Failed to load zenburn theme")
end

theme = f()
theme.wallpaper = ".config/wallpaper/darkwood.jpg"

return theme
