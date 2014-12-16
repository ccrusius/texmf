local luaunit = dofile "../submodules/luaunit/luaunit.lua"

local function startswith(str,start)
  return (string.find(str,start,1,true) == 1)
end

local function doluatex(filename)
    print("luatex "..filename)
    local status = os.execute("luatex -halt-on-error -interaction=nonstopmode "..filename)
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

function test_twopage()
  local name = "twopage"
  local file = io.open(name..".tex","w+")
  assert(file,"Could not open '"..name..".tex' for writing.")
  file:write([[
\input ccbase
\twosidetrue
\paperwidth=8.5in
\leftmargin=4in
\rightmargin=1in
Page 1: \the\hoffset, \the\hsize
\typeout{Page 1: \the\hoffset, \the\hsize}
\vfill\eject
Page 2: \the\hoffset, \the\hsize
\typeout{Page 2: \the\hoffset, \the\hsize}
\vfill\eject
Page 3: \the\hoffset, \the\hsize
\typeout{Page 3: \the\hoffset, \the\hsize}
\vfill\eject
Page 4: \the\hoffset, \the\hsize
\typeout{Page 4: \the\hoffset, \the\hsize}
\bye
]])
  file:close()
  assert(doluatex(name)==true)
  assert(haslines(name..".log",name..".ref"))
  os.remove(name..".tex")
  os.remove(name..".log")
  os.remove(name..".pdf")
end

function test_citargs()
  local name = "citeargs"
  --
  -- Write .bib file
  --
  local file = io.open(name..".bib","w+")
  assert(file,"Could not open '"..name..".bib' for writing.")
  file:write([[
  @article{small,
    author = {Freely, I.P.}, title = {A small paper}, journal = {The journal of small papers},
    year = 1997, volume = {-1}, note = {to appear},
  }

  @article{big,
    author = {Jass, Hugh}, title = {A big paper}, journal = {The journal of big papers},
    year = 7991, volume = {MCMXCVII},
  }
  ]])
  file:close()
  --
  -- Write .tex file
  --
  file = io.open(name..".tex","w+")
  assert(file,"Could not open '"..name..".tex' for writing.")
  file:write([[
\input ccbase
\input ccshowbox
\luacode
local function output(head)
  ccshowbox.showheadlist(head,2,".")
  return true
end
callback.register("pre_output_filter",output)
\endluacode
A few citations to test:
\cite{small}
\cite{small,big}
\cite{[p3]small}
\cite{[p3]small,big}
\cite{[p3]small,[p4]big}
\cite{small,[p4]big}\hfil\par
\bibliographystyle{plain}
\bibliography{./citeargs}
\bye
]])
  file:close()
  --
  -- Test
  --
  assert(doluatex(name)==true)
  assert(dobibtex(name)==true)
  assert(doluatex(name)==true)
  assert(doluatex(name)==true)
  assert(haslines(name..".aux",name..".auxref"))
  assert(haslines(name..".log",name..".logref"))
  os.remove(name..".tex")
  os.remove(name..".log")
  os.remove(name..".pdf")
  os.remove(name..".bib")
  os.remove(name..".blg")
  os.remove(name..".bbl")
  os.remove(name..".aux")
end

lu = LuaUnit.new()
os.exit(lu:runSuite())
