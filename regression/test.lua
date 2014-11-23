local luaunit = dofile "./luaunit/luaunit.lua"

-- doluatex
--
-- Call luatex on the given file
--
function doluatex(filename)
    return os.execute("luatex -halt-on-error -interaction=batchmode "..filename)
end

function haslines(cmpfile,reffile)
    print("Reference file: "..reffile)
    print("Comparisoin file: "..cmpfile)

    local reff=io.open(reffile)
    local cmpf=io.open(cmpfile)
    local cmpl=cmpf:lines()

    for need in reff:lines() do
        local found = false
        repeat
            local has = cmpl()
            if has == need then found = true end
        until has == nil or found == true
        if found == false then
            reff.close()
            print("MISSING LINE\n"..need)
            return false
        end
    end
    cmpf.close()
    return true
end

function logtest(filename)
    assert(doluatex(filename)==true)
    assert(haslines(filename..".log",filename..".ref")==true)
end

function test_ccbase01()
    logtest("ccbase01")
end

lu = LuaUnit.new()
os.exit(lu:runSuite())
