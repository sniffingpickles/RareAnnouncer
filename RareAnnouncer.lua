-- Big value keeper
RAREAN = {}
-- Main refreshing and utility frame
local mainFrame  = CreateFrame("Frame", nil, UIParent)

-- Last Done:
-- Added code to find the General chat chanID
--

-- ToDo:
-- Interface options menu with options for: (Interface option menu done, need to add the rest of the options)
--   1) Respond to raretime / raretimer requests (Implemented)
--   2) Report rare finds when targeting a rare or when its killed closeby (Implemented)
--   3) Hide window when in combat (Implemented)
--   4) Choose method of rare tracking: (Implemented)
--      a) All
--      b) Selected
--      c) Next to spawn (with max, where 0 == all that are ready)
--   4.1) Show all rares on mouse-over
--   5) Set TomTom waypoint on rare detection from other people (only for the rares selected in option 3)
--   6) Order rare list by:
--      a) Name
--      b) Last kill time
-- TomTom waypoints when a rare is found, but you are not targetting it
-- 


-- The global options stored cross sessions
RAREAN.Options = {
  RespondToRequests,
  ReportFindsToGeneral,
  HideInCombat,
  ShowAllOnMouseOver,
  SetTomTomWaypoints,
  RareOrderType,
  TrackingType,
  TrackingRares = {}
}

-- The default options
local OptionsDefault = {
  RespondToRequests = true,
  ReportFindsToGeneral = true,
  HideInCombat = true,
  ShowAllOnMouseOver = true,
  SetTomTomWaypoints = true,
  RareOrderType = 1, -- 1 = Name, 2 = Time
  TrackingType = 1, -- 1 = All, 2 = Selected, 3 = Next to spawn
  TrackingRares = {}
}
local L = RareAnnouncerLocalization

local mobIDs = {  
  153205,
154701,
151684,
152007,
151933,
151124,
151672,
153000,
151627,
151702,
150575,
152182,
150937,
153226,
152113,
154225,
151623,
151625,
151940,
150342,
151308,
155583,
151934,
150394,
153200,
152001,
154739,
149847,
152569,
152570,
151569,
154153,
151202,
151884,
153228,  --- Testing
151660,
152960, -- Foreboding Flame
}

local mobs = {
  -- npc_id = {message sent, died time, name, min spawn time, max spawn time, coordsX, coordsY, lastRequest}
  -- Timeless Isle (map 951)
  -- Many of the spawn timers are guesses, will need to refine when data is available
  -- [73174] = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["73174"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0,    coordsY = 0,    lastRequest = 0 }, -- Archiereus of Flame
[153205]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["153205"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[154701]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["154701"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151684]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151684"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[152007]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["152007"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151933]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151933"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151124]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151124"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151672]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151672"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[153000]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["153000"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151627]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151627"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151702]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151702"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[150575]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["150575"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[152182]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["152182"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[150937]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["150937"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[153226]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["153226"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[152113]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["152113"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[154225]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["154225"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151623]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151623"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151625]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151625"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151940]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151940"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[150342]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["150342"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151308]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151308"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[155583]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["155583"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151934]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151934"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[150394]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["150394"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[153200]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["153200"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[152001]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["152001"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[154739]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["154739"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[149847]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["149847"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[152569]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["152569"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[152570]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["152570"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151569]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151569"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[154153]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["154153"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151202]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151202"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[151884]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["151884"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour       
[153228]   = { lastAnnounce = 0, killTime = -1, killAnnounced = 0, npcName = (L["153228"]), minSpawn = 1800, maxSpawn = 3600, coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Zhu-Gon the Sour   
--[151660] = { lastAnnounce = 0, killTime = -1, npcName = "Scrapbown Trashtosser"            , minSpawn = 2,    maxSpawn = 5,    coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Foreboding Flame
--[152960] = { lastAnnounce = 0, killTime = -1, npcName = "Scrapbone Grunter"            , minSpawn = 2,    maxSpawn = 5,    coordsX = 0, coordsY = 0, lastRequest = 0 }, -- Foreboding Flame
}

-- local text_timer, text_throttle = 0, 10
local textRefreshThrottle = 5 -- Refreshing every 5 secs
local textRefreshCurrent  = 0
local textCanRefresh = true
local channelJoinDelay = 5 -- Delay joining and syncing 5s after load, prevents our channel to become one of the first
local channelJoinCurrent = 0
local needSync = false
local needRCSync = false
local syncChanNamePrefix = "RAREAN"
local syncRCChanNamePrefix = "RCELVA"
local addonSettingsLoaded = false
local i

-- Main Frame Design:
-- |-------- MainFrame -------------------------------------------|
-- ||------- NPC Name -------------------------|----  Killed ----||
-- || Some NPC Name                            |       1min      ||
-- || Some NPC Name                            |      15min      ||
-- || Some NPC Name                            |       1min      ||
-- || Some NPC Name                            |       1min      ||
-- || Some NPC Name                            |       1min      ||
-- || Some NPC Name                            |       1min      ||
-- || Some NPC Name                            |       1min      ||
-- ||------------------------------------------------------------||
-- |--------------------------------------------------------------|

local rareFrame = CreateFrame("Frame", "rareFrame", UIParent)
  rareFrame:SetWidth(261)
  rareFrame:SetHeight(34)
  rareFrame:SetPoint("LEFT", 300, 100)
  rareFrame.texture = rareFrame:CreateTexture(nil, "BACKGROUND")
  rareFrame.texture:SetTexture(0,0,0,0.4)
  rareFrame.texture:SetAllPoints(rareFrame)

  rareFrame.npcFrame = CreateFrame("Frame", "rareFrame.npcFrame", rareFrame)
  rareFrame.npcFrame:SetWidth(180)
  rareFrame.npcFrame:SetHeight(rareFrame:GetHeight()-10)
  rareFrame.npcFrame:SetPoint("TOPLEFT", rareFrame, 5, -5)
  rareFrame.npcFrame.texture = rareFrame.npcFrame:CreateTexture(nil, "BACKGROUND")
  rareFrame.npcFrame.texture:SetTexture(0,0,0,0.5)
  rareFrame.npcFrame.texture:SetAllPoints(rareFrame.npcFrame)

  rareFrame.timeFrame = CreateFrame("Frame", "rareFrame.timeFrame", rareFrame)
  rareFrame.timeFrame:SetWidth(70)
  rareFrame.timeFrame:SetHeight(rareFrame:GetHeight()-10)
  rareFrame.timeFrame:SetPoint("TOPLEFT", rareFrame.npcFrame, "TOPRIGHT", 1, 0)
  rareFrame.timeFrame.texture = rareFrame.timeFrame:CreateTexture(nil, "BACKGROUND")
  rareFrame.timeFrame.texture:SetTexture(0,0,0,0.5)
  rareFrame.timeFrame.texture:SetAllPoints(rareFrame.timeFrame)

  rareFrame.npcFrame.text = {}
  -- Header
  rareFrame.npcFrame.text[0] = rareFrame.npcFrame:CreateFontString("rareFrame.npcFrame.text[0]", nil, "GameFontNormal")
  rareFrame.npcFrame.text[0]:SetPoint("TOP", "rareFrame.npcFrame", 2, -2)
  rareFrame.npcFrame.text[0]:SetFont("Fonts\\ARIALN.TTF", 12)
  rareFrame.npcFrame.text[0]:SetTextColor(1, 0.7, 0, 1)
  rareFrame.npcFrame.text[0]:SetText(L["Name"])
  rareFrame.npcFrame.text[0]:SetFont("Fonts\\ARIALN.TTF", 12,"OUTLINE")

  rareFrame.timeFrame.text = {}
  -- Header
  rareFrame.timeFrame.text[0] = rareFrame.timeFrame:CreateFontString("rareFrame.timeFrame.text[0]", nil, "GameFontNormal")
  rareFrame.timeFrame.text[0]:SetPoint("TOP", "rareFrame.timeFrame", 2, -2)
  rareFrame.timeFrame.text[0]:SetFont("Fonts\\ARIALN.TTF", 12)
  rareFrame.timeFrame.text[0]:SetTextColor(1, 0.7, 0, 1)
  rareFrame.timeFrame.text[0]:SetText(L["Killed"])
  rareFrame.timeFrame.text[0]:SetFont("Fonts\\ARIALN.TTF", 12,"OUTLINE")

local syncRareIte
local responseFormater = CreateFrame("Button")
responseFormater:Hide()

local function DragStart()
  textCanRefresh = false
  mainFrame.updateFrame:SetScript("OnUpdate", nil)
  rareFrame:StartMoving()
end

local function DragStop()
  rareFrame:StopMovingOrSizing()
  mainFrame.updateFrame:SetScript("OnUpdate", OverallUpdater)
  textCanRefresh = true
end

-- Converts the mobs index into a string value
local function GetRareIdString(rareID)
  local i
  for i = 1, #mobIDs do
    if (mobIDs[i] == rareID) then
      return tostring(mobIDs[i])
    end
  end
end

-- Gets the channel id of a named custom channel
local function GetChannelID(channelName)
  local channelCount = GetNumDisplayChannels()
  
  for i = 1, channelCount do
    SetSelectedDisplayChannel(i)
    local ciName, _, _, _, _, _, _, _, _ = GetChannelDisplayInfo(i)
    if (ciName == channelName) then
      return i
    end
  end
end

-- Gets the owner of a given channel
local function GetChannelOwner(chanID)
  local _, _, _, _, memberCount, _, _, _, _ = GetChannelDisplayInfo(chanID)
  
  for i = 1, memberCount do
    local name, owner, _, _, _, _ = C_ChatInfo.GetChannelRosterInfo(chanID, i)
    if (owner) then
      return name
    end
  end
end

-- Joins the different syncing channels (Currently ours and RareCoordinators)
local function JoinSyncChannels(self, elapsed)
  channelJoinCurrent = channelJoinCurrent + elapsed
  if (channelJoinCurrent > channelJoinDelay) then
    -- RareAnnouncer sync channel
    if (C_ChatInfo.IsAddonMessagePrefixRegistered(syncChanNamePrefix) == false) then
      C_ChatInfo.RegisterAddonMessagePrefix(syncChanNamePrefix)
    end
    
    -- Now find our syncing channel
    local syncChanID = GetChannelID(syncChanNamePrefix)
    if (syncChanID == nil) then
      JoinChannelByName(syncChanNamePrefix)
    end
    needSync = true
    
    -- RareCoordinator sync channel
    if (C_ChatInfo.IsAddonMessagePrefixRegistered(syncRCChanNamePrefix) == false) then
      C_ChatInfo.RegisterAddonMessagePrefix(syncRCChanNamePrefix)
    end
    
    -- Now find RC syncing channel
    local syncRCChanID = GetChannelID(syncRCChanNamePrefix)
    if (syncRCChanID == nil) then
      JoinChannelByName(syncRCChanNamePrefix)
    end
    needRCSync = true
    
    channelJoinCurrent = 0
  end
end

-- Leaves the syncing channels when you leave the zone
local function LeaveSyncChannels()
  if (GetChannelID(syncChanNamePrefix) ~= nil) then
    LeaveChannelByName(syncChanNamePrefix)
  end
  
  if (GetChannelID(syncRCChanNamePrefix) ~= nil) then
    LeaveChannelByName(syncRCChanNamePrefix)
  end
end

-- Determines if a rare should be displayed
local function ShouldTrackRare(rareID)
  local shouldTrack = false
  if (RAREAN.Options.TrackingType == 2) then
    for i = 1, #RAREAN.Options.TrackingRares do
      if (RAREAN.Options.TrackingRares[i] == rareID) then
        shouldTrack = true
        break
      end
    end
  elseif (RAREAN.Options.TrackingType == 3) then
    if (mobs[rareID].killTime ~= nil) then
      local timeSinceKill = (time() - mobs[rareID].killTime)
      if ((timeSinceKill < mobs[rareID].maxSpawn) and
          (timeSinceKill > mobs[rareID].minSpawn)) then
        shouldTrack = true
      end
    end
  else
    shouldTrack = true
  end
  
  return shouldTrack
end

-- Determines what colour the time portion should be
local function DetermineTimeColour(rareID, timeText)
  if (mobs[mobIDs[rareID]].killTime ~= nil) then
    local timeSinceKill = (time() - mobs[mobIDs[rareID]].killTime)
    local mediumSpawn = (mobs[mobIDs[rareID]].minSpawn + mobs[mobIDs[rareID]].maxSpawn) / 2
    
    if (mobs[mobIDs[rareID]].killTime == -1) then
      timeText:SetTextColor(1, 0.8, 0, 1) -- Normal
    elseif (timeSinceKill < 60) then
      timeText:SetTextColor(1, 0.8, 0, 1) -- Normal
    else
      -- Set the text colour
      -- KillTime < Minimum Spawn time
      if (timeSinceKill < mobs[mobIDs[rareID]].minSpawn) then
        timeText:SetTextColor(1, 0.8, 0, 1) -- Normal
      -- KillTime > Minimum Spawn time, but < Maximum Spawn time
      -- and < 1/2 of the Average between Min and Max
      elseif ((timeSinceKill > mobs[mobIDs[rareID]].minSpawn) and
               (timeSinceKill < mediumSpawn)) then
        timeText:SetTextColor(0, 1, 0, 1)  -- Green
      -- KillTime > Minimum Spawn time, but < Maximum Spawn time
      -- and > 1/2 of the Average between Min and Max
      elseif ((timeSinceKill >= mediumSpawn) and
              (timeSinceKill < mobs[mobIDs[rareID]].maxSpawn)) then
        timeText:SetTextColor(0, 0.7, 0, 1) -- Light Green
      -- KillTime > Maximum Spawn time. Either kill missed or no announcement
      else
        timeText:SetTextColor(1, 0, 0, 0.9) -- Red
      end
    end
  else
    timeText:SetTextColor(0, 0.8, 1, 1) -- Green
  end
end

-- Refreshes the main text window
local function RefreshText()
  if (addonSettingsLoaded == true) then
    if (rareFrame.npcFrame ~= nil) then
      if (rareFrame.npcFrame.text ~= nil) then
        -- First clear the frame
        for textIndex = 1, #rareFrame.npcFrame.text do
          rareFrame.npcFrame.text[textIndex]:SetText("")
          rareFrame.timeFrame.text[textIndex]:SetText("")
        end
        rareFrame.npcFrame.text = {}
        rareFrame.timeFrame.text = {}
        
        -- Redo the headers
        rareFrame.npcFrame.text[0] = rareFrame.npcFrame:CreateFontString("rareFrame.npcFrame.text[0]", nil, "GameFontNormal")
        rareFrame.npcFrame.text[0]:SetPoint("TOP", "rareFrame.npcFrame", 2, -2)
        rareFrame.npcFrame.text[0]:SetFont("Fonts\\ARIALN.TTF", 12)
        rareFrame.npcFrame.text[0]:SetTextColor(1, 0.7, 0, 1)
        rareFrame.npcFrame.text[0]:SetText(L["Name"])
        rareFrame.npcFrame.text[0]:SetFont("Fonts\\ARIALN.TTF", 12,"OUTLINE")

        rareFrame.timeFrame.text[0] = rareFrame.timeFrame:CreateFontString("rareFrame.timeFrame.text[0]", nil, "GameFontNormal")
        rareFrame.timeFrame.text[0]:SetPoint("TOP", "rareFrame.timeFrame", 2, -2)
        rareFrame.timeFrame.text[0]:SetFont("Fonts\\ARIALN.TTF", 12)
        rareFrame.timeFrame.text[0]:SetTextColor(1, 0.7, 0, 1)
        rareFrame.timeFrame.text[0]:SetText(L["Killed"])
        rareFrame.timeFrame.text[0]:SetFont("Fonts\\ARIALN.TTF", 12,"OUTLINE")
        
        -- Then repopulate them
        -- Loop through our rare mobs, check if we have a name and kill time, then search for it in npcFrame
        -- if it is there, update the time, otherwise add it
        local textIndex = 0
        local rareIndex = 0
        local textFound = false
        for rareIndex = 0, #mobIDs do
          if (mobs[mobIDs[rareIndex]] ~= nil) then
            if (mobs[mobIDs[rareIndex]].npcName ~= nil) then
              if (ShouldTrackRare(mobIDs[rareIndex])) then
                local newIndex = #rareFrame.npcFrame.text + 1
                rareFrame.npcFrame.text[newIndex] = rareFrame.npcFrame:CreateFontString("rareFrame.npcFrame.text["..newIndex.."]", nil, "GameFontNormal")
                rareFrame.npcFrame.text[newIndex]:SetPoint("TOP", "rareFrame.npcFrame", 2, -0 + -14.* newIndex)
                rareFrame.npcFrame.text[newIndex]:SetFont("Fonts\\ARIALN.TTF", 12)
                rareFrame.npcFrame.text[newIndex]:SetTextColor(1, 0.8, 0, 1)
                rareFrame.npcFrame.text[newIndex]:SetText(mobs[mobIDs[rareIndex]].npcName)
                rareFrame.npcFrame.text[newIndex]:SetJustifyH("LEFT")

                rareFrame.timeFrame.text[newIndex] = rareFrame.timeFrame:CreateFontString("rareFrame.timeFrame.text["..newIndex.."]", nil, "GameFontNormal")
                rareFrame.timeFrame.text[newIndex]:SetPoint("TOP", "rareFrame.timeFrame", 3, 0 + -14.* newIndex)
                rareFrame.timeFrame.text[newIndex]:SetFont("Fonts\\ARIALN.TTF", 12)
                if (mobs[mobIDs[rareIndex]].killTime ~= nil) then
                  if (mobs[mobIDs[rareIndex]].killTime == -1) then
                    rareFrame.timeFrame.text[newIndex]:SetText("---")
                  elseif ((time() - mobs[mobIDs[rareIndex]].killTime) <= 60 ) then
                    rareFrame.timeFrame.text[newIndex]:SetText(L["Dead"])
                  else
                    rareFrame.timeFrame.text[newIndex]:SetText(SecondsToTime(time() - mobs[mobIDs[rareIndex]].killTime, true))
                  end
                else
                  rareFrame.timeFrame.text[newIndex]:SetText(L["Alive"])
                end
                DetermineTimeColour(rareIndex, rareFrame.timeFrame.text[newIndex])
              end
            end
          end
        end
        rareFrame.npcFrame:SetHeight(25 +  #rareFrame.npcFrame.text *14)
        rareFrame.timeFrame:SetHeight(25 +  #rareFrame.npcFrame.text *14)
        rareFrame:SetHeight(35 +  #rareFrame.npcFrame.text *14)
      end
    end
  end
end

-- Cleans out any last kill times that are more than 2 hours ago
local function CleanupLastKillTimes()
  if (mobs ~= nil) then
    for i = 1, #mobIDs do
      if (mobs[mobIDs[i]] ~= nil) then
        if (mobs[mobIDs[i]].killTime ~= nil) then
          if (time() - mobs[mobIDs[i]].killTime > 7200) then
            mobs[mobIDs[i]].killTime = -1 -- Reset the kill time if last kill is more than 2 hours ago
          end
        end
      end
    end
  end
end

-- General OnEvent handler (Refresher)
local function OverallUpdater(self,elapsed)
  textRefreshCurrent = textRefreshCurrent + elapsed
  if textRefreshCurrent >= textRefreshThrottle then
    if (textCanRefresh == true) then
      -- Cleanup the times
      CleanupLastKillTimes()
      -- Refresh the text frames
      RefreshText()
    end
      
    textRefreshCurrent = 0
  end
end

-- Sends a message to either /1 or our syncing channel
local function SendGeneralMessage(msg, isSync)
local index = GetChannelName("test") -- Find General Channel for user
  if (msg ~= nil) then
    if (isSync == false) then
      -- For some reason the SendChatMessage does not like the output from SecondsToTime
      -- this is a work around
      msg = responseFormater:GetText(responseFormater:SetText(msg))
      if (index~=nil) then
	     SendChatMessage(msg , "CHANNEL", nil, index)
      -- SendChatMessage(msg , "CHANNEL", nil, 4) -- Testing
	     end
    else
      local syncChanID = GetChannelName(syncChanNamePrefix)
      if (syncChanID ~= nil) then
        SendChatMessage(msg, "CHANNEL", nil, syncChanID)
      end
    end
  end
end

-- Creates and sends the death message and sync
local function SendDeathMessage(rareID)
  if (mobs[rareID] ~= nil) then
    -- First the chat deathMsg
    local deathMsg
    -- First the kill message
    deathMsg = "[".. syncChanNamePrefix .. "]" .. GetRareIdString(rareID) .. "_kill_" .. tostring(mobs[rareID].killTime)
    SendGeneralMessage(deathMsg, true)
    
    if (RAREAN.Options.ReportFindsToGeneral) then
      -- Kill announcement throttle
      if ((time() - mobs[rareID].killAnnounced) > 120) then
        mobs[rareID].killAnnounced = time()
        -- Send the kill announce sync
        deathMsg = "[".. syncChanNamePrefix .. "]" .. GetRareIdString(rareID) .. "_killannounced_" .. tostring(mobs[rareID].killAnnounced)
        SendGeneralMessage(deathMsg, true)
        
        deathMsg = "RareAnnouncer: ".. mobs[rareID].npcName ..(L["has died"])
        SendGeneralMessage(deathMsg, false)
      end
    end
  end
end

-- Creates and sends the target messages and sync
local function SendTargetMessage(rareID)
  if (RAREAN.Options.ReportFindsToGeneral == true) then
    if (mobs[rareID] ~= nil) then
      -- Only announce once every 10 seconds
      if (mobs[rareID].lastAnnounce + 10 < time()) then
        local name = strtrim(UnitName("target"))
        local map = C_Map.GetBestMapForUnit("player")
        local x, y = C_Map.GetPlayerMapPosition(map,"player"):GetXY()
        local health = math.floor(UnitHealth("target")*100/UnitHealthMax("target"))
        
        local targetMessage = "RareAnnouncer: ".. mobs[rareID].npcName .." (".. health .."%)"..(L["Coordinates"])..math.floor(x*100)..", "..math.floor(y*100)
        SendGeneralMessage(targetMessage, false)
        mobs[rareID].lastAnnounce = time()
        targetMessage = "[".. syncChanNamePrefix .. "]" ..GetRareIdString(rareID) .. "_target_" .. mobs[rareID].lastAnnounce
      end
    end
  end
end

-- Creates and sends the request response message and sync
local function SendRequestMessage(rareID)
  if (RAREAN.Options.RespondToRequests == true) then
    if (mobs[rareID] ~= nil) then
      -- We throttle the number of requests per mob to once every 1 minute
      if ((time() - mobs[rareID].lastRequest) > 60) and
          (mobs[rareID].npcName ~= nil) and
          (mobs[rareID].killTime ~= nil) and
          (mobs[rareID].killTime ~= -1) then
        
        local responseString
        
        -- Sync message first
        mobs[rareID].lastRequest = time()
        responseString = "[".. syncChanNamePrefix .. "]" ..GetRareIdString(rareID) .. "_request_" .. mobs[rareID].lastRequest
        SendGeneralMessage(responseString, true)
        
        -- Response in General
        if ((time() - mobs[rareID].killTime) > 60) then
          responseString = "RareAnnouncer: " .. mobs[rareID].npcName .. (L["last killed"]) .. tostring(SecondsToTime(time() - mobs[rareID].killTime, true)) .. (L["ago"])
        else
          responseString = "RareAnnouncer: " .. mobs[rareID].npcName .. (L["recentkill"])
        end
        SendGeneralMessage(responseString, false)
      end
    end
  end
end

-- Request handler
local function ProcessRequest(message)
  if (RAREAN.Options.RespondToRequests == true) then
    -- Expected format = raretime <npcname / id>
    if (message ~= nil) then
      local searchingString
      
      if (strlower(string.sub(message,1,9)) == "raretime ") then
        searchingString = string.sub(message, 10, string.len(message))
      elseif (strlower(string.sub(message,1,10)) == "raretimer ") then
        searchingString = string.sub(message, 11, string.len(message))
      else
        return
      end
    
      if (string.len(searchingString) > 3) then
        local responseString
    
        -- First check for ID
        local searchID = tonumber(searchingString)
        if (searchID ~= nil) then
          if (mobs[searchID] ~= nil) then
            SendRequestMessage(searchID)
          end
        -- Now search on name or part of name
        else
          searchingString = strlower(searchingString)
          local i
          for i= 1, #mobIDs do
            if (mobs[mobIDs[i]] ~= nil) then
              if (strlower(mobs[mobIDs[i]].npcName) == searchingString) or
                 (string.find(strlower(mobs[mobIDs[i]].npcName), searchingString) ~= nil) then
                SendRequestMessage(mobIDs[i])
                break
              end
            end
          end
        end
      end
    end
  end
end

-- Deathlog handler
local function ProcessDeathLog(name, guid)
  name = strtrim(name)
  local id = tonumber(guid:sub(6, 10), 16)
  
  if (mobs[id] ~= nil) then
    mobs[id].killTime = time()
    mobs[id].npcName = name
    SendDeathMessage(id)
  end
end

-- Our Sync channel message handler
local function ProcessSyncChatMsg(message)
  local prefix = "[" .. syncChanNamePrefix .. "]"
  local dataStr = string.sub(message, string.len(prefix)+1, string.len(message))
  
  local rareIDStr, syncType, syncTimeStr = strsplit("_", dataStr)
  if ((rareIDStr ~= nil) and
      (syncTimeStr ~= nil)) then
    local rareID = tonumber(strtrim(rareIDStr))
    local syncTime = tonumber(strtrim(syncTimeStr))

    if ((rareID       ~= nil) and
        (syncType     ~= nil) and
        (syncTime ~= nil)) then
      if (mobs[rareID] ~= nil) then

        if (syncType == "request") then
          mobs[rareID].lastRequest = syncTime
        elseif (syncType == "kill") or
               (syncType == "death") then
          mobs[rareID].killTime = syncTime
        elseif (syncType == "target") then
          mobs[rareID].lastAnnounce = syncTime
        elseif (syncType == "killannounced") then
          mobs[rareID].killAnnounced = syncTime
        end
      end
    end
  end
end

-- RareCoordinator sync channel message handler
local function ProcessRCSyncChatMsg(message)
  local prefix = "[" .. syncChanNamePrefix .. "]"
  local dataStr
  if string.find(message, prefix) then
    dataStr = string.sub(message, string.len(prefix)+1, string.len(message))
  else
    dataStr = message
  end
  
  local rcVersion, rcRareIDStr, rcType, rcTimeStr = strsplit("_", dataStr)
  if ((rcRareIDStr ~= nil) and
      (rcTimeStr   ~= nil)) then
    local rcRareID = tonumber(rcRareIDStr)
    local rcTime   = tonumber(rcTimeStr)
    
    if ((rcVersion ~= nil) and
        (rcRareID  ~= nil) and
        (rcType    ~= nil) and
        (rcTime    ~= nil)) then
      if (rcType == "killed") then
        if (mobs[rcRareID] ~= nil) then
          -- Only update if the kill time is less than ours
          if (mobs[rcRareID].killTime ~= nil) then
            if (mobs[rcRareID].killTime > rcTime) and
              (rcTime > 0) then
              mobs[rcRareID].killTime = rcTime
            elseif (mobs[rcRareID].killTime == -1) then
              mobs[rcRareID].killTime = rcTime
            end
          else
            mobs[rcRareID].killTime = rcTime
          end
        end
      elseif (rcType == "alive") then
        if (mobs[rcRareID] ~= nil) then
          mobs[rcRareID].killTime = nil
        end
      end
    end
  end
end

-- The hidden addon channel message handler
local function ProcessAddonMsg(prefix, message, channel, sender)
  if (prefix == syncChanNamePrefix)then
    if (channel == "WHISPER") then
      -- Sync request
      if (message == "Sync") then
        for syncRareIte = 1, #mobIDs do
          if ((mobs[mobIDs[syncRareIte]].killTime ~= nil) and
              (mobs[mobIDs[syncRareIte]].killTime  > 0))then
            C_ChatInfo.SendAddonMessage(syncChanNamePrefix, "[".. syncChanNamePrefix .. "]" .. GetRareIdString(mobIDs[syncRareIte]) .. "_death_" .. tostring(mobs[mobIDs[syncRareIte]].killTime), "WHISPER", sender)
            --print("addon message sent")
            --print(syncChanNamePrefix, "[".. syncChanNamePrefix .. "]" .. GetRareIdString(mobIDs[syncRareIte]) .. "_death_" .. tostring(mobs[mobIDs[syncRareIte]].killTime))

          end
        end
      -- Sync response
      else
        ProcessSyncChatMsg(message)
        -- RefreshText(self, 100)
      end
    end
  elseif (strtrim(prefix) == syncRCChanNamePrefix) then
    if (channel == "WHISPER") then
      ProcessRCSyncChatMsg(message)
    end
  end
end

-- Channel roster update handler (used for requesting syncs)
local function ProcessChanRosterUpdate(chanID)
  local name, _, _, _, _, _, _, _, _ = GetChannelDisplayInfo(chanID)
  
  if (name == syncChanNamePrefix) then
    -- Check if we need to sync
    if (needSync) then
      mainFrame:SetScript("OnUpdate", nil)
      needSync = false
      
      local chanOwner = GetChannelOwner(chanID)
      if (chanOwner ~= nil) then
        C_ChatInfo.SendAddonMessage(syncChanNamePrefix, "Sync", "WHISPER", chanOwner)
        --print("addon message sent")
      end
    end
  elseif (name == syncRCChanNamePrefix) then
    -- Check if we need to sync with RC
    if (needRCSync) then
      mainFrame:SetScript("OnUpdate", nil)
      needRCSync = false
      
      local chanOwner = GetChannelOwner(chanID)
      if (chanOwner ~= nil) then
        C_ChatInfo.SendAddonMessage(syncRCChanNamePrefix, "GetStatus", "WHISPER", chanOwner)
        --print("addon message sent")
      end
    end
  end
  
  if ((needSync   == false) or
      (needRCSync == false)) then
    mainFrame:SetScript("OnUpdate", nil)
  else
    mainFrame:SetScript("OnUpdate", JoinSyncChannels)
  end
end

-- Chat message handler for /1 and the sync channels
local function ProcessChatMsg(message, sender, language, channelString, target, flags, unknown, channelID, channelName, unknown, counter, guid)
  -- Handle request messages
  --if (channelID == 1) or (channelID == 4) then
  if (channelID == 1) then
    -- Request string
    if (strlower(string.sub(message,1,9)) == "raretime ") or
       (strlower(string.sub(message,1,10)) == "raretimer ") then
      -- Expected format =  ratime <npc name/id>
      ProcessRequest(message)
    end
  -- Addon Channel message
  elseif (channelName == syncChanNamePrefix) then
    if string.find(message, "%["..syncChanNamePrefix.."%]") then
      ProcessSyncChatMsg(message)
    end
  elseif (channelName == syncRCChanNamePrefix) then
    if string.find(message, "%[" .. syncRCChanNamePrefix .. "%]") then
      ProcessRCSyncChatMsg(message)
    end
  end
end

-- Zone changing event handler
local function EnableOrDisable()
  -- MapAreaID 951 = Timeless Isles
  local GetCurrentMapAreaID = C_Map.GetBestMapForUnit("player");
  if (GetCurrentMapAreaID == 1462) then
    mainFrame:RegisterEvent("CHAT_MSG_CHANNEL")
    mainFrame:RegisterEvent("CHAT_MSG_ADDON")
    mainFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    mainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    mainFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    mainFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    
    mainFrame:SetScript("OnUpdate", JoinSyncChannels)
    
    rareFrame:Show()
  else
    mainFrame:UnregisterEvent("CHAT_MSG_CHANNEL")
    mainFrame:UnregisterEvent("CHAT_MSG_ADDON")
    mainFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
    mainFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    mainFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
    mainFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
    
    mainFrame:SetScript("OnUpdate", nil)
    LeaveSyncChannels()
    
    rareFrame:Hide()
    needSync = true
    needRCSync = true
  end
end

-- Player into combat event handler
local function HideFrameInCombat()
  if (RAREAN.Options.HideInCombat == true) then
    rareFrame:Hide()
  end
end

-- Player out of combat event handler
local function ShowFrameAfterCombat()
  if (RAREAN.Options.HideInCombat == true) then
    rareFrame:Show()
  end
end

-- Loads the saved variables when login and sets the defauls as needed
local function LoadSavedVariables()
  if (RAREAN.Options == nil) then
    RAREAN.Options = CopyTable(OptionsDefault)
  end
  
  if (RAREAN.Options.RespondToRequests == nil) then
    RAREAN.Options.RespondToRequests = OptionsDefault.RespondToRequests
  end

  if (RAREAN.Options.ReportFindsToGeneral == nil) then
    RAREAN.Options.ReportFindsToGeneral = OptionsDefault.ReportFindsToGeneral
  end

  if (RAREAN.Options.HideInCombat == nil) then
    RAREAN.Options.HideInCombat = OptionsDefault.HideInCombat
  end

  if (RAREAN.Options.ShowAllOnMouseOver == nil) then
    RAREAN.Options.ShowAllOnMouseOver = OptionsDefault.ShowAllOnMouseOver
  end

  if (RAREAN.Options.SetTomTomWaypoints == nil) then
    RAREAN.Options.SetTomTomWaypoints = OptionsDefault.SetTomTomWaypoints
  end

  if (RAREAN.Options.RareOrderType == nil) then
    RAREAN.Options.RareOrderType = OptionsDefault.RareOrderType
  end

  if (RAREAN.Options.TrackingType == nil) then
    RAREAN.Options.TrackingType = OptionsDefault.TrackingType
  end
  
  addonSettingsLoaded = true
end

-- Main event handler
local function MainEvents(mainFrame, event, ...)
  if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
    local _,event_type,_,_,_,_,_,guid,name = select(1, CombatLogGetCurrentEventInfo())

    if event_type == "UNIT_DIED" then
      ProcessDeathLog(name, guid)
    end
  elseif (event == "PLAYER_TARGET_CHANGED") and UnitGUID("target") then
    --print("target changed");
    local guid = UnitGUID("target")

    local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-",guid);
    --print(npc_id)
    if guid and mobs[tonumber(npc_id)] and not UnitIsDead("target") then
      local id = tonumber(npc_id)
      --print(id)
      local name = UnitName("target")
      --print(name)
      mobs[id].killTime = nil -- Reset the kill time to Alive
      mobs[id].npcName = name
      SendTargetMessage(id)
    end
  elseif (event == "CHAT_MSG_CHANNEL") then
    ProcessChatMsg(...)
  elseif (event == "CHAT_MSG_ADDON") then
    ProcessAddonMsg(...)
  elseif (event == "PLAYER_REGEN_DISABLED") then
    HideFrameInCombat()
  elseif (event == "PLAYER_REGEN_ENABLED") then
    ShowFrameAfterCombat()
  elseif (event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA") then
    EnableOrDisable()
  elseif (event == "CHANNEL_ROSTER_UPDATE") then
    ProcessChanRosterUpdate(...)
  elseif (event == "ADDON_LOADED") then
    LoadSavedVariables()
  end
end
-- === OPTION PANELS START === --

-- Generic CheckBox maker
local function CreateCheckButton(parent, checkBoxName, posX, posY, displayText)
	local checkButton = CreateFrame("CheckButton", checkBoxName, parent, "UICheckButtonTemplate");
	checkButton:SetPoint("TOPLEFT", posX, posY);
  checkButton:SetWidth(25)
  checkButton:SetHeight(25)
	getglobal(checkButton:GetName() .. 'Text'):SetText(displayText);

	return checkButton;
end

-- Generic RadionButton maker
local function CreateRadioButton(parent, radioButtonName, posX, posY, displayText)
  local radioButton = CreateFrame("CheckButton", radioButtonName, parent, "UIRadioButtonTemplate");
  radioButton:SetPoint("TOPLEFT", posX, posY);
  radioButton:SetHeight(20)
  radioButton:SetWidth(20)
  getglobal(radioButton:GetName() .. 'Text'):SetText(displayText);
  return radioButton
end

-- === OPTION PANELS START === --
  function OptionsFrameRefreshText()
    if ((rareFrame.npcFrame.text ~= nill) and
        (rareFrame.timeFrame.text ~= nil)) then
      for textIndex = 1, #rareFrame.npcFrame.text do
        rareFrame.npcFrame.text[textIndex]:SetText("")
        rareFrame.timeFrame.text[textIndex]:SetText("")
      end
    end
    rareFrame.npcFrame.text = {}
    rareFrame.timeFrame.text = {}
    OverallUpdater(mainFrame, 10)
  end

  -- Set the options when showing the interface options menu
  function OptionsFrameSettingsLoad()
    mainFrame.optionsFrame.chkRespondToRequest:SetChecked(RAREAN.Options.RespondToRequests)
    mainFrame.optionsFrame.chkReportFindsToGeneral:SetChecked(RAREAN.Options.ReportFindsToGeneral)
    mainFrame.optionsFrame.chkHideInCombat:SetChecked(RAREAN.Options.HideInCombat)
    mainFrame.optionsFrame.chkSetTomTom:SetChecked(RAREAN.Options.SetTomTomWaypoints)
    -- Tracking type
    if (RAREAN.Options.TrackingType == 1) then
      mainFrame.trackOptionFrame.rbnTrackAll:SetChecked(true)
      mainFrame.trackOptionFrame.rbnTrackSelected:SetChecked(false)
      mainFrame.trackOptionFrame.rbnTrackNext:SetChecked(false)
    elseif (RAREAN.Options.TrackingType == 2) then
      mainFrame.trackOptionFrame.rbnTrackAll:SetChecked(false)
      mainFrame.trackOptionFrame.rbnTrackSelected:SetChecked(true)
      mainFrame.trackOptionFrame.rbnTrackNext:SetChecked(false)
    elseif (RAREAN.Options.TrackingType == 3) then
      mainFrame.trackOptionFrame.rbnTrackAll:SetChecked(false)
      mainFrame.trackOptionFrame.rbnTrackSelected:SetChecked(false)
      mainFrame.trackOptionFrame.rbnTrackNext:SetChecked(true)
    end
    -- Always set the checkboxes
    for i = 1, #RAREAN.Options.TrackingRares do
      for j = 1, #mobIDs do
        if (mobIDs[j] == RAREAN.Options.TrackingRares[i]) then
          mainFrame.trackOptionFrame.chkTrack[j]:SetChecked(true)
        end
      end
    end
  end

  -- Event handler for the tracking type radio buttons
  function SetTrackingType(sender, sourceButton, down)
    -- 1 = All, 2 = Selected, 3 = Next to spawn
    if (sender:GetName() == "rbnTrackAll") then
      RAREAN.Options.TrackingType = 1
      rbnTrackSelected:SetChecked(false)
      rbnTrackNext:SetChecked(false)
    elseif (sender:GetName() == "rbnTrackSelected") then
      RAREAN.Options.TrackingType = 2
      rbnTrackAll:SetChecked(false)
      rbnTrackNext:SetChecked(false)
    elseif (sender:GetName() == "rbnTrackNext") then
      RAREAN.Options.TrackingType = 3
      rbnTrackAll:SetChecked(false)
      rbnTrackSelected:SetChecked(false)
    end
  end
  
  function UpdateTrackingList(sender, sourceButton, down)
    -- If the tracking type is "Selected" then do the below, otherwise se the check back to its previous state
    if (RAREAN.Options.TrackingType == 2) then
      -- get the index number
      local bracketStart, _ = string.find(sender:GetName(), "%[")
      local _, bracketEnd = string.find(sender:GetName(), "%]")
      local indexStr
      if ((bracketStart ~= nil) and
          (bracketEnd ~= nil)) then
        indexStr = string.sub(sender:GetName(), bracketStart+1, bracketEnd-1)
      end
      
      local rareIndex = tonumber(indexStr)
      
      local found = false
      if (rareIndex ~= nil) then
        for i = 1, #RAREAN.Options.TrackingRares do
          if (RAREAN.Options.TrackingRares[i] == mobIDs[rareIndex]) then
            found = true
            -- If the rare is in the list, remove it if it is now unchecked
            if (sender:GetChecked() == nil) then
              table.remove(RAREAN.Options.TrackingRares, i)
            end
          end
        end
        
        if (found == false) then
          if (sender:GetChecked()) then
            tinsert(RAREAN.Options.TrackingRares, mobIDs[rareIndex])
          end
        end
      end
    else
      sender:SetChecked(not sender:GetChecked())
    end
  end
  
  -- Main Panel
  mainFrame.optionsFrame = CreateFrame("ScrollFrame", "mainFrame.optionFrame", UIParent , "UIPanelScrollFrameTemplate");
  mainFrame.optionsFrame.name = L["optionsConfig"]
  mainFrame.optionsFrame.parent = "RareAnnouncer"
  mainFrame.optionsFrame.refresh = OptionsFrameSettingsLoad
  mainFrame.optionsFrame.okay = OptionsFrameRefreshText

    -- Respond to Request option
    mainFrame.optionsFrame.chkRespondToRequest = CreateCheckButton(mainFrame.optionsFrame, "chkRespondToRequest", 20, -20, (L["respond"]))
    mainFrame.optionsFrame.chkRespondToRequest.tooltip = (L["respondRT"])
    mainFrame.optionsFrame.chkRespondToRequest:SetScript("OnClick", 
      function()
       if (mainFrame.optionsFrame.chkRespondToRequest:GetChecked() == 1) then
         RAREAN.Options.RespondToRequests = true
       else
         RAREAN.Options.RespondToRequests = false
       end
      end
    );
    -- Report finds/death to General
    mainFrame.optionsFrame.chkReportFindsToGeneral = CreateCheckButton(mainFrame.optionsFrame, "chkReportFindsToGeneral", 20, -42, L["announce"])
    mainFrame.optionsFrame.chkReportFindsToGeneral.tooltip = (L["announce"])
    mainFrame.optionsFrame.chkReportFindsToGeneral:SetScript("OnClick", 
      function()
       if (mainFrame.optionsFrame.chkReportFindsToGeneral:GetChecked() == 1) then
         RAREAN.Options.ReportFindsToGeneral = true
       else
         RAREAN.Options.ReportFindsToGeneral = false
       end
      end
    );
    -- Hide in combat
    mainFrame.optionsFrame.chkHideInCombat = CreateCheckButton(mainFrame.optionsFrame, "chkHideInCombat", 20, -64, (L["hidetracking"]))
    mainFrame.optionsFrame.chkHideInCombat.tooltip = (L["hidetracking"])
    mainFrame.optionsFrame.chkHideInCombat:SetScript("OnClick", 
      function()
       if (mainFrame.optionsFrame.chkHideInCombat:GetChecked() == 1) then
         RAREAN.Options.HideInCombat = true
       else
         RAREAN.Options.HideInCombat = false
       end
      end
    );
    -- Set TomTom Waypoints
    --mainFrame.optionsFrame.chkSetTomTom = CreateCheckButton(mainFrame.optionsFrame, "chkSetTomTom", 20, -86, L["setTomTom"])
    --mainFrame.optionsFrame.chkSetTomTom.tooltip = (L["setTomTom"])
    --mainFrame.optionsFrame.chkSetTomTom:SetScript("OnClick", 
    --  function()
    --   if (mainFrame.optionsFrame.chkSetTomTom:GetChecked() == 1) then
    --     RAREAN.Options.SetTomTomWaypoints = true
    --   else
    --     RAREAN.Options.SetTomTomWaypoints = false
    --   end
    --  end
    --);

  -- Tracking Options Panel
  mainFrame.trackOptionFrame = CreateFrame("ScrollFrame", "mainFrame.trackOptionFrame", UIParent , "UIPanelScrollFrameTemplate");
  mainFrame.trackOptionFrame.name = L["optionsTracking"]
  mainFrame.trackOptionFrame.parent = "RareAnnouncer"

    -- Tracking Type text
    mainFrame.trackOptionFrame.txtTrackOption = mainFrame.trackOptionFrame:CreateFontString("mainFrame.trackOptionFrame.txtTrackOption", "OVERLAY ", "GameFontNormal")
    mainFrame.trackOptionFrame.txtTrackOption:SetPoint("TOPLEFT", 24, -20)
    mainFrame.trackOptionFrame.txtTrackOption:SetText(L["trackTypeHead"])

    -- Tracking Type option All
    mainFrame.trackOptionFrame.rbnTrackAll = CreateRadioButton(mainFrame.trackOptionFrame, "rbnTrackAll", 30, -40, L["trackTypeAll"])
    mainFrame.trackOptionFrame.rbnTrackAll.tooltip = (L["trackTypeAllTooltip"])
    mainFrame.trackOptionFrame.rbnTrackAll:SetScript("OnClick", SetTrackingType)
    -- Tracking Type option Selected
    mainFrame.trackOptionFrame.rbnTrackSelected = CreateRadioButton(mainFrame.trackOptionFrame, "rbnTrackSelected", 150, -40, L["trackTypeSelected"])
    mainFrame.trackOptionFrame.rbnTrackSelected.tooltip = (L["trackTypeSelectedTooltip"])
    mainFrame.trackOptionFrame.rbnTrackSelected:SetScript("OnClick", SetTrackingType)
    -- Tracking Type option Next to spawn
    mainFrame.trackOptionFrame.rbnTrackNext = CreateRadioButton(mainFrame.trackOptionFrame, "rbnTrackNext", 270, -40, L["trackTypeNext"])
    mainFrame.trackOptionFrame.rbnTrackNext.tooltip = (L["trackTypeNextTooltip"])
    mainFrame.trackOptionFrame.rbnTrackNext:SetScript("OnClick", SetTrackingType)
    
    -- Tracking Notice
    mainFrame.trackOptionFrame.txtTrackNotice = mainFrame.trackOptionFrame:CreateFontString("mainFrame.trackOptionFrame.txtTrackNotice", "OVERLAY ", "GameFontNormal")
    mainFrame.trackOptionFrame.txtTrackNotice:SetPoint("TOPLEFT", 30, -65)
    mainFrame.trackOptionFrame.txtTrackNotice:SetText(L["trackNotice"])
    
    mainFrame.trackOptionFrame.chkSelectAll = CreateFrame("Button", "chkSelectAll", mainFrame.trackOptionFrame, "UIPanelButtonTemplate")
    mainFrame.trackOptionFrame.chkSelectAll:SetText(L["trackSelectAll"])
    mainFrame.trackOptionFrame.chkSelectAll:SetPoint("TOPLEFT", 30, -85)
    mainFrame.trackOptionFrame.chkSelectAll:SetWidth(150)
    mainFrame.trackOptionFrame.chkSelectAll:SetScript("OnClick",
      function()
        for i = 1, #mainFrame.trackOptionFrame.chkTrack do
          mainFrame.trackOptionFrame.chkTrack[i]:SetChecked(true)
          RAREAN.Options.TrackingRares = {}
          for j = 1, #mobIDs do
            tinsert(RAREAN.Options.TrackingRares, mobIDs[j])
          end
        end
      end
    );
    
    mainFrame.trackOptionFrame.chkSelectNone = CreateFrame("Button", "chkSelectNone", mainFrame.trackOptionFrame, "UIPanelButtonTemplate")
    mainFrame.trackOptionFrame.chkSelectNone:SetText(L["trackSelectNone"])
    mainFrame.trackOptionFrame.chkSelectNone:SetPoint("TOPLEFT", 200, -85)
    mainFrame.trackOptionFrame.chkSelectNone:SetWidth(150)
      mainFrame.trackOptionFrame.chkSelectNone:SetScript("OnClick",
      function()
        for i = 1, #mainFrame.trackOptionFrame.chkTrack do
          mainFrame.trackOptionFrame.chkTrack[i]:SetChecked(false)
          RAREAN.Options.TrackingRares = {}
        end
      end
    );
    
    -- Tracking rares check boxes
    mainFrame.trackOptionFrame.chkTrack = {}
    local leftCol, rightCol = 0, 0
    -- We create two columns of checkboxes
    for i = 1, #mobIDs do
      if ( mod(i, 2) ~= 0) then
        mainFrame.trackOptionFrame.chkTrack[i] = CreateCheckButton(mainFrame.trackOptionFrame, "mainFrame.trackOptionFrame.chkTrack["..i.."]", 30, -115 - (leftCol*20), (L[GetRareIdString(mobIDs[i])]))
        leftCol = leftCol + 1
      else
        mainFrame.trackOptionFrame.chkTrack[i] = CreateCheckButton(mainFrame.trackOptionFrame, "mainFrame.trackOptionFrame.chkTrack["..i.."]", 270, -115 - (rightCol*20), (L[GetRareIdString(mobIDs[i])]))
        rightCol = rightCol + 1
      end
      mainFrame.trackOptionFrame.chkTrack[i]:SetScript("OnClick", UpdateTrackingList)
    end
    
    -- RAREAN.Options
    -- DONE RespondToRequests,
    -- DONE ReportFindsToGeneral,
    -- DONE HideInCombat,
    -- ShowAllOnMouseOver,
    -- DONE SetTomTomWaypoints,
    -- RareOrderType,
    -- DONE TrackingType, -- 1 = All, 2 = Selected, 3 = Next to spawn
    -- DONE TrackingRares = {}
  InterfaceOptions_AddCategory(mainFrame.optionsFrame);
  InterfaceOptions_AddCategory(mainFrame.trackOptionFrame);
-- === OPTION PANELS END === --

rareFrame:SetMovable(true)
rareFrame:EnableMouse(true)
rareFrame:SetUserPlaced(true)
rareFrame:RegisterForDrag("LeftButton")
rareFrame:SetScript("OnDragStart", DragStart)
rareFrame:SetScript("OnDragStop", DragStop)

mainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
mainFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
mainFrame:RegisterEvent("CHANNEL_ROSTER_UPDATE")
mainFrame:RegisterEvent("ADDON_LOADED")
mainFrame:SetScript("OnEvent", MainEvents)

mainFrame.updateFrame = CreateFrame("Frame", "mainFrame.updateFrame", mainFrame)
mainFrame.updateFrame:SetScript("OnUpdate", OverallUpdater)
OverallUpdater(mainFrame, 10)
