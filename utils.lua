function normRand()
	return love.math.random() * 2 - 1
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
