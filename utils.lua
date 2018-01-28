vec2 = require "vector2d"

function normRand()
	return love.math.random() * 2 - 1
end

function clampVec2(vec, len)
	local len2 = len * len
	local veclen2 = vec2.len2(vec[1], vec[2])
	if veclen2 > len2 then
		local scaler = len2 / veclen2
		return {
			vec[1] * scaler,
			vec[2] * scaler
		}
	end
	return vec
end

-- clamps a value between 0 and 1
function clamp01(val)
	if val < 0 then
		return 0
	elseif val > 1 then
		return 1
	end
	return val
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

-- 1d noise normalized to [-1, 1]
function normNoise(x)
	return love.math.noise(x) * 2 - 1
end

-- 2d noise normalized to [-1, 1]
function normNoise(x, y)
	return love.math.noise(x, y) * 2 - 1
end