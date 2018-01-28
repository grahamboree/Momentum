
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
end

return {
	load = load
}