local luaunit = dofile "../submodules/luaunit/luaunit.lua"

local function startswith(str,start)
  return (string.find(str,start,1,true) == 1)
end

local function doluatex(filename)
    print("luatex "..filename)
    local status = os.execute("luatex -halt-on-error -interaction=batchmode "..filename)
    if status == 0 then status = true end -- Windows
    return status
end

local function dobibtex(filename)
    print("bibtex "..filename)
    local status = os.execute("bibtex -terse "..filename)
    if status == 0 then status = true end -- Windows
    return status
end

local function haslines(cmpfile,reffile)
    local reff,cmpf,msg
    reff,msg=io.open(reffile) assert(reff,msg)
    cmpf,msg=io.open(cmpfile) assert(cmpf,msg)

    local nextcmp=cmpf:lines()

    for need in reff:lines() do
        repeat
          local has = nextcmp()
          if not has then
            io.close(reff)
            print("MISSING LINE\n"..need)
            return false
          end
        until startswith(has,need)
    end
    io.close(cmpf)
    return true
end

local function logtest(filename)
    assert(doluatex(filename)==true)
    assert(haslines(filename..".log",filename..".ref")==true)
end

function test_ccbase01()    logtest("ccbase01") end
function test_ccshowbox01() logtest("ccshowbox01") end
function test_ccgrid01()    logtest("ccgrid01") end

lu = LuaUnit.new()
os.exit(lu:runSuite())
