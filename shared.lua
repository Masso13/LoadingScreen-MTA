local preLoad = {
    [2] = "/",
    [5] = "/",
    ["default"] = md5("00/00/0000")
}

function table_length(t)
    local z = 0
    for i,v in pairs(t) do z = z + 1 end
    return z
end

function mapRange(value, low1, high1, low2, high2)
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

function processData(data)
    if string.len(data) > 0 and md5(data) == preLoad["default"] then
        data = ""
    else
        local carac = preLoad[string.len(data)] or ""
        data = data..""..carac
    end
    return data
end

function IfElse(condition, trueReturn, falseReturn)
    if (condition) then return trueReturn
    else return falseReturn end
end

function createCooldown(last)
    if (getTickCount() - last) / 1000  >= 2 then return true end
end