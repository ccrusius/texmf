local exports = {}
local loglevel = 0
local baselineskip = 0
local haccum = 0
local lastprebox = nil
local function setloglevel(x) loglevel = x end
exports["setloglevel"] = setloglevel
local function typeout(lvl,str)
  if loglevel >= lvl then texio.write_nl(str) end
end
local function setgrid(x) baselineskip=x end
exports["setgrid"] = setgrid
local function snapdown(x)
  return baselineskip*math.floor(x/baselineskip)
end
exports["snapdown"] = snapdown
local function freeze(x)
  return (ccbase.spstr(ccbase.tosp(x))).." plus 0pt minus 0pt"
end
exports["freeze"] = freeze
local function output(head)
  node.insert_after(head,node.slide(head),ccbase.mkglue(0,10000*2^16,3,0,0))
  typeout(2,"OUTPUT BOX:")
  if loglevel >= 2 then ccshowbox.showheadlist(head,0,".") end
  return true
end
callback.register("pre_output_filter",output)
local function freeze_glue(head,glue)
  local spec = glue.spec
  local width = spec.width
  haccum = haccum + width
  if spec.stretch == 0 and spec.shrink == 0 then return head, glue end

  local noglue = ccbase.mkglue(glue.spec.width,0,0,0,0)
  head, noglue = node.insert_after(head,glue,noglue)
  head, noglue = node.remove(head,glue)

  -- I think we should free "glue" now, but that makes things crash.
  -- if spec.writable then node.free(glue) end
  return head, noglue
end
local function align_hlist(head,hlist)
  haccum = haccum + hlist.height
  local skip = baselineskip*math.ceil(haccum/baselineskip) - haccum
  if skip > 0 then
    typeout(3,string.format("  ( shifting %fpt )",skip/2^16))
    head = node.insert_before(head,hlist,ccbase.mkglue(skip,0,0,0,0))
    haccum = haccum + skip
  else
    typeout(3,"  ( nop )")
  end
  haccum = haccum + hlist.depth
  return head, hlist
end
local function align_box(head)
  if lastprebox then
    head = lastprebox.next
    prebox = nil
  end
  if loglevel>= 3 then ccshowbox.showheadlist(head,0,"  << .") end
  local cur = head
  while cur do
    local fn = {
        [ccbase.GLUE_TYPE]  = freeze_glue,
        [ccbase.HLIST_TYPE] = align_hlist,
      }[cur.id]
    if fn then head, cur = fn(head,cur) end
    cur = cur.next
  end
  if loglevel >= 3 then ccshowbox.showheadlist(head,0,"  >> .") end
end
local buildpage_actions = {
  after_output = function(head) haccum=0 end,
  before_display = function(head)
                     if loglevel >= 3 then
                       ccshowbox.showheadlist(head,0,"  == .")
                     end
                   end,
  hmode_par      = function(head)
                     if loglevel >= 3 then
                       ccshowbox.showheadlist(head,0,"  == .")
                     end
                   end,
  new_graf       = function(head)
                     if loglevel >= 3 then
                       ccshowbox.showheadlist(head,0,"  == .")
                     end
                   end,
  vmode_par      = function(head)
                     if loglevel >= 3 then
                       ccshowbox.showheadlist(head,0,"  == .")
                     end
                   end,
  pre_box = function(head) lastprebox=node.slide(head) end,
  after_display  = align_box,
  box            = align_box,
  
  
}
local function buildpage(reason)
  local head = tex.lists.contrib_head
  typeout(3,string.format("BUILDPAGE("..reason..") haccum=%fpt",haccum/2^16))
  local action = buildpage_actions[reason]
  if action then action(head) end
end
callback.register("buildpage_filter",buildpage)
return exports