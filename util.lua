function splitStr( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end

function printTable(t)
    for k,v in pairs(t) do
        print(k,v)
    end
end
