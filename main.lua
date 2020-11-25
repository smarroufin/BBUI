local BBUI_Default = {
    ImproveActionBar = true,
    HideStances = true,
    ImproveBags = true,
    HideMainBag = true,
    HideBags = true,
    MoveUnitFrames = true,
    MoveBuffs = true,
    BuffsScale = 1,
    ImproveMinimap = true,
    ImproveChat = true,
    AutoRepair = true,
    AutoRepairGuild = false,
    AutoSellJunk = true
}

local function BBUI_UpdateActionBars()
    if BBUI_Default.ImproveActionBar then
        MainMenuBarArtFrameBackground:Hide()
        MainMenuBarArtFrame.LeftEndCap:Hide()
        MainMenuBarArtFrame.RightEndCap:Hide()
        MainMenuBarArtFrameBackground:Hide()
        MainMenuBarArtFrame.PageNumber:Hide()
        ActionBarUpButton:Hide()
        ActionBarDownButton:Hide()
        local r1 = MultiBarBottomRightButton1
        local buttonWidth = r1:GetWidth()
        local margin = 4
        local xStart = -(buttonWidth * 6 + margin * 5 + margin / 2)
        r1:ClearAllPoints()
        r1:SetPoint("BOTTOMLEFT", StatusTrackingBarManager, "TOP", xStart, -7)
        local l1 = MultiBarBottomLeftButton1
        l1:ClearAllPoints()
        l1:SetPoint("BOTTOMLEFT", r1, "TOPLEFT", 0, margin)
        local m1 = ActionButton1
        m1:ClearAllPoints()
        m1:SetPoint("BOTTOMLEFT", l1, "TOPLEFT", 0, margin)
        for _, v in ipairs({"MultiBarBottomRightButton", "MultiBarBottomLeftButton", "ActionButton"}) do
            for i = 2, 12 do
                local prevButton = _G[v .. (i - 1)]
                local button = _G[v .. i]
                button:ClearAllPoints()
                button:SetPoint("LEFT", prevButton, "RIGHT", margin, 0)
            end
        end
    end
    if BBUI_Default.HideStances then
        RegisterStateDriver(StanceBarFrame, "visibility", "hide")
    end
end

local function BBUI_UpdateMicroMenu()
    if BBUI_Default.ImproveBags then
        MicroButtonAndBagsBar:ClearAllPoints()
        MicroButtonAndBagsBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 4, -4)
        MicroButtonAndBagsBar.MicroBagBar:Hide()
        if BBUI_Default.HideBags then
            CharacterBag0Slot:Hide()
            CharacterBag1Slot:Hide()
            CharacterBag2Slot:Hide()
            CharacterBag3Slot:Hide()
            if BBUI_Default.HideMainBag then
                MainMenuBarBackpackButton:Hide()
            end
        end
    end
end

local function BBUI_UpdateUnitFrames()
    if BBUI_Default.MoveUnitFrames then
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
end

local function BBUI_UpdateBuffs()
    if BBUI_Default.MoveBuffs then
        hooksecurefunc("UIParent_UpdateTopFramePositions", function()
            BuffFrame:ClearAllPoints()
            BuffFrame:SetPoint("TOPRIGHT", PlayerFrame, "TOPLEFT", 0, -10)
        end)
    end
    BuffFrame:SetScale(BBUI_Default.BuffsScale)
end

local function BBUI_UpdateMinimap()
    if BBUI_Default.ImproveMinimap then
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
end

local function BBUI_UpdateChat()
    if BBUI_Default.ImproveChat then
        QuickJoinToastButton:Hide()
        ChatFrameChannelButton:Hide()
    end
end

local function BBUI_RegisterMerchantEvents()
    if BBUI_Default.AutoSellJunk or BBUI_Default.AutoRepair then
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
end

local function BBUI_OnEvent(self, event, arg1, arg2, arg3)
    BBUI_UpdateActionBars()
    BBUI_UpdateMicroMenu()
    BBUI_UpdateUnitFrames()
    BBUI_UpdateBuffs()
    BBUI_UpdateMinimap()
    BBUI_UpdateChat()
    BBUI_RegisterMerchantEvents()
end

local BBUIEventFrame = CreateFrame("Frame")
BBUIEventFrame:RegisterEvent('PLAYER_LOGIN')
BBUIEventFrame:SetScript('OnEvent', BBUI_OnEvent)
