
sounds = {
	music = {},
	sfx = {}
}

local function load()
	-- load music loops
	sounds.music["level1"] = love.audio.newSource("MUSIC/momentum_level1_loop.wav")
	sounds.music["level2"] = love.audio.newSource("MUSIC/momentum_level2_loop.wav")
	sounds.music["level3"] = love.audio.newSource("MUSIC/momentum_level3_loop.wav")

	-- set looping
	sounds.music.level1:isLooping(true)
	sounds.music.level2:isLooping(true)
	sounds.music.level3:isLooping(true)

	-- load sfx
	sounds.sfx["negativeinteract"] = love.audio.newSource("SFX/negativeinteract.wav", "static")
	sounds.sfx["positiveinteract"] = love.audio.newSource("SFX/positiveinteract.wav", "static")
	sounds.sfx["selectionclick1"] = love.audio.newSource("SFX/selectionclick1.wav", "static")
	sounds.sfx["selectionclick2"] = love.audio.newSource("SFX/selectionclick2.wav", "static")
  sounds.sfx["win"] = love.audio.newSource("SFX/levelwinstinger.wav", "static")

	sounds.sfx["objectsound1"] = "SFX/objectsound1_loop.wav"
	sounds.sfx["objectsound2"] = "SFX/objectsound2_loop.wav"
	sounds.sfx["objectsound3"] = "SFX/objectsound3_loop.wav"
	sounds.sfx["objectsound4"] = "SFX/objectsound4_loop.wav"
	sounds.sfx["objectsound5"] = "SFX/objectsound5_loop.wav"
	sounds.sfx["objectsound6"] = "SFX/objectsound6_loop.wav"
end

function loop(r)
	if r == 1 then return sounds.sfx["objectsound1"] end
	if r == 2 then return sounds.sfx["objectsound2"] end
	if r == 2 then return sounds.sfx["objectsound3"] end
	if r == 2 then return sounds.sfx["objectsound4"] end
	if r == 2 then return sounds.sfx["objectsound5"] end
	return sounds.sfx["objectsound6"]
end

return {
	load = load
}