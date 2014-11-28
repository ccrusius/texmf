local loglevel = 0
local baselineskip = 0
local function setloglevel(x) loglevel = x end
local function typeout(lvl,str)
  if loglevel >= lvl then texio.write_nl(str) end
end
local function setgrid(x) baselineskip=x end
local function snapdown(x)
  return baselineskip*math.floor(x/baselineskip)
end
local function freeze(x)
  return (ccbase.spstr(ccbase.tosp(x))).." plus 0pt minus 0pt"
end
return { setloglevel = setloglevel,
         setgrid = setgrid,
         snapdown = snapdown,
         freeze = freeze, }