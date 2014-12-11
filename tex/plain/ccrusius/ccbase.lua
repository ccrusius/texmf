local exports = {}
local GLUE_TYPE    = node.id("glue")
local GLYPH_TYPE   = node.id("glyph")
local HLIST_TYPE   = node.id("hlist")
local KERN_TYPE    = node.id("kern")
local MATH_TYPE    = node.id("math")
local RULE_TYPE    = node.id("rule")
local VLIST_TYPE   = node.id("vlist")
local WHATSIT_TYPE = node.id("whatsit")
exports["GLUE_TYPE"]    = GLUE_TYPE
exports["GLYPH_TYPE"]   = GLYPH_TYPE
exports["HLIST_TYPE"]   = HLIST_TYPE
exports["KERN_TYPE"]    = KERN_TYPE
exports["MATH_TYPE"]    = MATH_TYPE
exports["RULE_TYPE"]    = RULE_TYPE
exports["VLIST_TYPE"]   = VLIST_TYPE
exports["WHATSIT_TYPE"] = WHATSIT_TYPE
local dims = {
  ["sp"] = 1,
  ["pt"] = 2^16,
  ["pc"] = 12*2^16,
  ["bp"] = 72*2^16,
  ["in"] = 72.27*2^16,
}
local function dim2str(value,from,to)
  return string.format("%f"..to,value*dims[from]/dims[to])
end
exports["dim2str"] = dim2str
local function str2dim(value,to)
  value = value:gsub("^[ \t]*","")
  value = value:gsub("[ \t].*$","")
  local from = value:gsub("[-0-9.]+","")
  value = value:gsub("[^-0-9.]+","")
  return tonumber(value)*dims[from]/dims[to]
end
exports["str2dim"] = str2dim
local function mkglue(w,st,sto,sh,sho)
  local glue = node.new(ccbase.GLUE_TYPE)
  glue.spec = node.new("glue_spec")
  glue.spec.width = w
  glue.spec.stretch = st
  glue.spec.stretch_order = sto
  glue.spec.shrink = sh
  glue.spec.shrink_order = sho
  return glue
end
exports["mkglue"] = mkglue
return exports