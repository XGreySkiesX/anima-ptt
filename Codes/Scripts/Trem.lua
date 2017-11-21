-- ROUND TWO
-- FIGHT
proplist={} --stores all the song's properties for the moment
sourcelist={} --soon to not be needed, just stores the sources for when I need them
Trem={} --The Function Jazz
soundlist={}
mustext=""

--setup sfx
function Trem.prepSound(name,sr)
	soundlist[name]=love.audio.newSource(sr,"static") --add to the sound list
	soundlist[name]:setVolume(.9)--set the volume so it plays over music
end

--Play sfx
function Trem.playSound(name)
	soundlist[name]:play()--play from the soundlist
end

--stop sfx
function Trem.stopSound(name)
	soundlist[name]:stop()--stop whatever is being played
end

-- Set up everything, to play a song
function Trem.playMus(name,source,lS,lE)
	proplist[name]={} --set the current array index as an array as well
	sourcelist[name]= love.audio.newSource(source, "stream") --inject source
	if lS and lE ~= nil and lE~=nil then --as long as these two aren't empty and LE isn't a string saying "end"...
		sourcelist[name]:setLooping(true)
		sourcelist[name]:setVolume(0.5)--also, set the default volume (this will be changed later, but for now it's like this until I get an option menu going)
		proplist[name].loopStart = lS --the start of the looped part
		proplist[name].loopLength = lE - lS --get the length of the loop, of course
		proplist[name].loopEnd = lE --the end of the loop part
		sourcelist[name]:play() --start the song!
	else
		sourcelist[name]:setVolume(0.5)
		sourcelist[name]:play() --just play it if there isn't looping stuff
	end
end

-- Stop a selected sound, or stop all
function Trem.stopBGM(noro)
local bgm --aka background music.
if proplist[noro] ~= nil then
sourcelist[noro]:stop()
end
if noro == "all" then
love.audio.stop()
end
end

--Next function- checking for a specific song
function Trem.checkMus(tocheck)
		if proplist[tocheck] ~= nil then
			return true --return true if it's in there
		else return false --return false if it's not! Simple
		end --NAME CHECK STOP
end

--Here's where the fun is- making things run over and over again!
function Trem.Loop(sng)
if proplist[sng] ~= nil then
mustext=tostring(sourcelist[sng]:tell("seconds"))
if (sourcelist[sng]:tell("seconds") >= proplist[sng].loopEnd) then --check to see if we're nearing the end of the loop
    sourcelist[sng]:seek(sourcelist[sng]:tell("seconds")-proplist[sng].loopLength ,"seconds") --set us back in the song to "loopStart"
end
end
end

--Next, why not print everything? Still need to edit this some, though
function Trem.printProp(theme,r,g,b)
		if proplist[theme] then --check for the specific index of the name, because it's shared by the source, also NAME CHECK END p much
			local tname=theme --put the name in a string for me, gal
			local llength=tostring(proplist[theme].loopLength) --Why not put the length in there, too?
			local lstart=tostring(proplist[theme].loopStart)
			local lend=tostring(proplist[theme].loopEnd)
			local that=tostring(sourcelist[theme]) --and sources are always nice, yeah?
			if r~=nil and g~=nil and b~=nil then --check to see if you gave a color
				love.graphics.setColor(r,g,b,255) --make the text THAT color
			else love.graphics.setColor(255,255,255) --hate to be that guy, but you're getting white text, buddy
			end
			love.graphics.print(tname.." "..that.." " ..llength.." "..lstart.." "..lend.." "..mustext,0,0) --Print the jazz
		end
end

return Trem --this just returns all the functions, so we can use them in our other scripts
