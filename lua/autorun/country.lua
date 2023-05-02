local xMin, xMax = 0, 32768
local yMin, yMax = 0, 16384


-- IDK HOW TO MAKE THIS WORK!

function convertToXY(lat, long)
    local x = (long + 180) / 360
    local y = (lat + 90) / 180

    local xPos = xMin + (xMax - xMin) * x
    local yPos = yMax - (yMax - yMin) * y

    xPos = math.Round( xPos - 8192, 2 )
    yPos = math.Round( yPos - 8192, 2 )

    return xPos, yPos
end



function Country()
    local csv = file.Open("countries.csv", "r", "DATA")
    
    local countries = "local COUNTRIES = {\n"

    while not csv:EndOfFile() do
        local line = csv:ReadLine()
        local code, lat, long, name = line:match("([^,]+),([^,]+),([^,]+),([^,]+)")

        local x, y = convertToXY( tonumber(lat), tonumber(long) )
        print(code, string.format("%s %s -13200", x, y))

        countries = countries .. string.format("    [%s] = Vector(%s, %s, -13244),", code, x, y) .. "\n"
    end

    csv:Close()

    countries = countries .. "}"

    file.Write("country.txt", countries)
end

concommand.Add("getcountries", Country)
