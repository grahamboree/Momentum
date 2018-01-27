function love.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", 300, 300, 50, 100) -- Draw white circle with 100 segments.
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle("fill", 300, 300, 50, 5)   -- Draw red circle with five segments.
end