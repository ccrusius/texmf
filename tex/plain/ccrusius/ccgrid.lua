--------------------------------------------------------------------------------
--
-- Algorithm variables
--
-- haccum: When incrementally processing a vlist, we keep track of how
--     much vertical material was added so far in this variable.
-- lastprebox: LuaTeX, when breaking paragraphs into lines, signals that
--     new material will be added with a pre_box buildpage_filter call.
--     We save the value so we don't re-process things.
--
local haccum = 0
local lastprebox = nil

local function buildpage_glue(head,cur)
  local spec = cur.spec
  local width = spec.width
  haccum = haccum + width
  if spec.stretch == 0 and spec.shrink == 0 then return head, cur end

  local noglue = ccbase.mkglue(cur.spec.width,0,0,0,0)
  head, noglue = node.insert_after(head,cur,noglue)
  head, noglue = node.remove(head,cur)
  --
  -- I think we should free "cur" now, but that makes things crash.
  --
  -- if spec.writable then node.free(cur) end
  return head, noglue
end

local function buildpage_hlist(head,cur)
  haccum = haccum + cur.height
  --
  -- If necessary, insert enough glue to make the baseline of the hbox aling
  -- with the baseline grid.
  --
  local skip = baselineskip*math.ceil(haccum/baselineskip) - haccum
  if skip > 0 then
    typeout(3,string.format("  ( shifting %fpt )",skip/2^16))
    head = node.insert_before(head,cur,ccbase.mkglue(skip,0,0,0,0))
  else
    typeout(3,"  ( nop )")
  end
  haccum = haccum + skip
  haccum = haccum + cur.depth
  return head, cur
end

local buildpage_nodes = {
  [ccbase.GLUE_TYPE]  = buildpage_glue,
  [ccbase.HLIST_TYPE] = buildpage_hlist,
}

local function buildpage_after_output(head)
  haccum = 0
end

local function buildpage_box(head)
  if lastprebox then
    head = lastprebox.next
    prebox = nil
  end
  if loglevel>= 3 then ccshowbox.showheadlist(head,0,"  << .") end
  local cur = head
  while cur do
    local fn = buildpage_nodes[cur.id]
    if fn then head, cur = fn(head,cur) end
    cur = cur.next
  end
  if loglevel >= 3 then ccshowbox.showheadlist(head,0,"  >> .") end
end


local function buildpage_nop(head)
  if loglevel >= 3 then
    ccshowbox.showheadlist(head,0,"  == .")
  end
end

local buildpage_actions = {
  after_display  = buildpage_box,
  after_output   = buildpage_after_output,
  before_display = buildpage_nop,
  box            = buildpage_box,
  hmode_par      = buildpage_nop,
  new_graf       = buildpage_nop,
  --
  -- pre_box: Signals that contrib_head contains material that is already
  -- present and does not need to be re-processed.
  --
  pre_box        = function(head) lastprebox=node.slide(head) end,
  vmode_par      = buildpage_nop,
}

local function buildpage(info)
  local head = tex.lists.contrib_head
  typeout(3,string.format("BUILDPAGE("..info..") haccum=%fpt",haccum/2^16))

  local action = buildpage_actions[info]
  if action then action(head) end
end

local function output(head)
  --
  -- Insert a "raggedbottom-Xtreme" glue at the end of the page.
  --
  -- In the original definition, raggedbottom inserts a vfil at the end of the
  -- page. But a single vfil can't nullify other vfils that may be in the
  -- page, so we insert 10,000 of them. No stretch in our pages!
  --
  node.insert_after(head,node.slide(head),ccbase.mkglue(0,10000*2^16,3,0,0))
  --
  -- Log
  --
  typeout(2,"OUTPUT BOX:")
  if loglevel >= 2 then ccshowbox.showheadlist(head,0,".") end
  --
  -- Done
  --
  return true
end

callback.register("buildpage_filter",buildpage)
callback.register("pre_output_filter",output)
