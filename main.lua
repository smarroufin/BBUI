local BBUI_Default = {
    BuffsScale = 1,
    HideBags = true,
    AutoRepair = true,
    AutoRepairGuild = false,
    AutoSellJunk = true
}

local function BBUI_UpdateActionBars()
    MainMenuBarArtFrameBackground:Hide()
    MainMenuBarArtFrame.LeftEndCap:Hide()
    MainMenuBarArtFrame.RightEndCap:Hide()
    MainMenuBarArtFrameBackground:Hide()
    MainMenuBarArtFrame.PageNumber:Hide()
    ActionBarUpButton:Hide()
    ActionBarDownButton:Hide()
    RegisterStateDriver(StanceBarFrame, "visibility", "hide")
    local r1 = MultiBarBottomRightButton1
    local bWidth = r1:GetWidth()
    local margin = 6
    r1:ClearAllPoints()
    r1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", -(bWidth * 6 + margin * 5 + margin / 2), 2)
    local r6 = MultiBarBottomRightButton6
    local r7 = MultiBarBottomRightButton7
    r7:ClearAllPoints()
    r7:SetPoint("TOPLEFT", r6, "TOPRIGHT", margin, 0)
    local l1 = MultiBarBottomLeftButton1
    l1:ClearAllPoints()
    l1:SetPoint("BOTTOMLEFT", r1, "TOPLEFT", 0, margin)
    local m1 = ActionButton1
    m1:ClearAllPoints()
    m1:SetPoint("BOTTOMLEFT", l1, "TOPLEFT", 0, margin)
end

local function BBUI_UpdateMicroMenu()
    MicroButtonAndBagsBar:ClearAllPoints()
    MicroButtonAndBagsBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 4, -4)
    MicroButtonAndBagsBar.MicroBagBar:Hide()
    if (BBUI_Default.HideBags) then
        CharacterBag0Slot:Hide()
        CharacterBag1Slot:Hide()
        CharacterBag2Slot:Hide()
        CharacterBag3Slot:Hide()
    end
end

local function BBUI_UpdateUnitFrames()
    local xFromCenter, yFromTop = 200, 100
    PlayerFrame:SetMovable(true)
    PlayerFrame:SetUserPlaced(true)
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("RIGHT", UIParent, "CENTER", -xFromCenter, -yFromTop)
    PlayerFrame:SetMovable(false)
    TargetFrame:SetMovable(true)
    TargetFrame:SetUserPlaced(true)
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("LEFT", UIParent, "CENTER", xFromCenter, -yFromTop)
    TargetFrame:SetMovable(false)
end

local function BBUI_MoveBuffFrame()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetScale(BBUI_Default.BuffsScale)
    BuffFrame:SetPoint("TOPRIGHT", PlayerFrame, "TOPLEFT", 0, -10)
end

local function BBUI_UpdateMinimap()
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()
    MinimapBorderTop:Hide()
    MiniMapWorldMapButton:Hide()
    MinimapBackdrop:EnableMouseWheel(true)
    MinimapBackdrop:SetScript("OnMouseWheel", function(_, arg1)
        if not arg1 then
            return
        end
        if arg1 > 0 and Minimap:GetZoom() < 5 then
            Minimap:SetZoom(Minimap:GetZoom() + 1)
        elseif arg1 < 0 and Minimap:GetZoom() > 0 then
            Minimap:SetZoom(Minimap:GetZoom() - 1)
        end
    end)
end

local function BBUI_UpdateChat()
    ChatFrame1:ClearAllPoints()
    ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
end

local function BBUI_RegisterMerchantEvents()
    local AutoRepairFrame = CreateFrame("Frame")
    AutoRepairFrame:RegisterEvent("MERCHANT_SHOW")
    AutoRepairFrame:SetScript("OnEvent", function()
        if BBUI_Default.AutoSellJunk then
            for bag = 0, 4 do
                for bagSlot = 1, GetContainerNumSlots(bag) do
                    local itemLink = GetContainerItemLink(bag, bagSlot)
                    if itemLink then
                        local _, _, rarity, _, _, _, _, _, _, _, price = GetItemInfo(itemLink)
                        if rarity == 0 and price ~= 0 then
                            UseContainerItem(bag, bagSlot)
                            PickupMerchantItem()
                        end
                    end
                end
            end
        end
        if BBUI_Default.AutoRepair and CanMerchantRepair() then
            RepairAllItems(BBUI_Default.AutoRepairGuild)
        end
    end)
end

local function BBUI_OnEvent(self, event, arg1, arg2, arg3)
    BBUI_UpdateActionBars()
    BBUI_UpdateMicroMenu()
    BBUI_UpdateUnitFrames()
    hooksecurefunc("UIParent_UpdateTopFramePositions", BBUI_MoveBuffFrame)
    BBUI_UpdateMinimap()
    BBUI_UpdateChat()
    BBUI_RegisterMerchantEvents()
end

local BBUIEventFrame = CreateFrame("Frame")
BBUIEventFrame:RegisterEvent('PLAYER_LOGIN')
BBUIEventFrame:SetScript('OnEvent', BBUI_OnEvent)
