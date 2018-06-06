-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------

local VERSION = "8.0.1"
local BAGS_WIDTH = (4*42+42)

-------------------------------------------------------------------------------
-- Variables
-------------------------------------------------------------------------------
local _

-- Create new textures for bags and microbuttons backdrop
MainMenuBarArtFrameBackground.MicroButtonArt = MainMenuBarArtFrameBackground:CreateTexture();
MainMenuBarArtFrameBackground.MicroButtonArt:SetSize(BAGS_WIDTH + 15, 46);
MainMenuBarArtFrameBackground.MicroButtonArt:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, -BAGS_WIDTH - 10, -10);
MainMenuBarArtFrameBackground.MicroButtonArt:SetTexture(MicroButtonAndBagsBar.MicroBagBar:GetTexture());
MainMenuBarArtFrameBackground.MicroButtonArt:SetTexCoord(275/1024, 572/1024, 212/256, 255/256);

MainMenuBarArtFrameBackground.MultiBagsArt = MainMenuBarArtFrameBackground:CreateTexture();
MainMenuBarArtFrameBackground.MultiBagsArt:SetSize(BAGS_WIDTH - 40, 46);
MainMenuBarArtFrameBackground.MultiBagsArt:SetPoint("BOTTOMRIGHT", MainMenuBarArtFrame, BAGS_WIDTH - 42, -10);
MainMenuBarArtFrameBackground.MultiBagsArt:SetTexture(MicroButtonAndBagsBar.MicroBagBar:GetTexture());
MainMenuBarArtFrameBackground.MultiBagsArt:SetTexCoord(395/1024, 525/1024, 177/256, 211/256);

MainMenuBarArtFrameBackground.MainBagsArt = MainMenuBarArtFrameBackground:CreateTexture();
MainMenuBarArtFrameBackground.MainBagsArt:SetSize(44, 46);
MainMenuBarArtFrameBackground.MainBagsArt:SetPoint("BOTTOMRIGHT", MainMenuBarArtFrame, BAGS_WIDTH + 2, -10);
MainMenuBarArtFrameBackground.MainBagsArt:SetTexture(MicroButtonAndBagsBar.MicroBagBar:GetTexture());
MainMenuBarArtFrameBackground.MainBagsArt:SetTexCoord(525/1024, 569/1024, 168/256, 211/256);

-- Enlarge status bars to include bags and microbuttons
-- and move them between the 2 rows of buttons, as it should
hooksecurefunc(StatusTrackingBarManager, "LayoutBar", function (self, bar, barWidth, isTopBar, isDouble)
		
	bar:ClearAllPoints();
	
	if ( isDouble ) then
		if ( isTopBar ) then
			bar:SetPoint("BOTTOM", MainMenuBarArtFrame, "TOP", 0, -7);
		else		
			bar:SetPoint("BOTTOM", MainMenuBarArtFrame, "TOP", 0, -16);
		end
		self:SetDoubleBarSize(bar, barWidth + BAGS_WIDTH * 2);
	else 
		bar:SetPoint("BOTTOM", MainMenuBarArtFrame, "TOP", 0, -16);
		self:SetSingleBarSize(bar, barWidth + BAGS_WIDTH * 2);
    end
end);

-- Move back the bags and micro buttons inside the main UI
hooksecurefunc(MainMenuBar, "SetPositionForStatusBars", function ()

    -- Move left and right dragons further to make some room
	MainMenuBarArtFrame.LeftEndCap:ClearAllPoints();
	MainMenuBarArtFrame.RightEndCap:ClearAllPoints();
	MainMenuBarArtFrame.LeftEndCap:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, -98 - BAGS_WIDTH, -10);
    MainMenuBarArtFrame.RightEndCap:SetPoint("BOTTOMRIGHT", MainMenuBarArtFrame, 98 + BAGS_WIDTH, -10);

    -- avoid taint
    if InCombatLockdown() then return end

    -- Reposition MainMenuBarArtFrame and use it as the anchor instead of MainMenuBar where possible
    MainMenuBarArtFrameBackground:ClearAllPoints();
    MainMenuBarArtFrameBackground:SetPoint("BOTTOM", MainMenuBarArtFrame, 0, -10);

    MainMenuBarArtFrame:ClearAllPoints();
    if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then 
        MainMenuBarArtFrame:SetPoint("TOPLEFT", MainMenuBar, 0, 10 - 17);
        MainMenuBarArtFrame:SetPoint("BOTTOMRIGHT", MainMenuBar, 0, 10 - 17);
	elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
        MainMenuBarArtFrame:SetPoint("TOPLEFT", MainMenuBar, 0, 10 - 14);
        MainMenuBarArtFrame:SetPoint("BOTTOMRIGHT", MainMenuBar, 0, 10 - 14);
	else 
        MainMenuBarArtFrame:SetPoint("TOPLEFT", MainMenuBar, 0, 10);
        MainMenuBarArtFrame:SetPoint("BOTTOMRIGHT", MainMenuBar, 0, 10);
	end

    -- Move the bags buttons
    MainMenuBarBackpackButton:SetParent(MainMenuBarArtFrame);
    MainMenuBarBackpackButton:ClearAllPoints();
    MainMenuBarBackpackButton:SetPoint("RIGHT", MainMenuBarArtFrame, BAGS_WIDTH, -13);
    
    for i = 0,3 do
        _G["CharacterBag"..i.."Slot"]:SetParent(MainMenuBarArtFrame);
        _G["CharacterBag"..i.."Slot"]:SetSize(40, 40);
        _G["CharacterBag"..i.."Slot"].IconBorder:SetSize(40, 40);
    end
    CharacterBag0Slot:ClearAllPoints();
    CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -4, 0);

    -- Move the microbuttons
    MicroButtonAndBagsBar:Hide();
    FloRetroUI_MainMenuBar_OnShow();

    -- Move the aditional action bars above status bar
    if ( IsPlayerInWorld() ) then

        -- Don't let UIParent_ManageFramePositions manage the MultiBarBottomLeft
        UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil;
        MultiBarBottomLeft:ClearAllPoints();

        MultiBarBottomRightButton7:ClearAllPoints();

        if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
            MultiBarBottomLeft:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 27);
            MultiBarBottomRightButton7:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, 27);
        elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
            MultiBarBottomLeft:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 24);
            MultiBarBottomRightButton7:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, 24);
       else 
            MultiBarBottomLeft:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 13);
            MultiBarBottomRightButton7:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, 13);

            --UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"].baseY = 2;
            --UIPARENT_MANAGED_FRAME_POSITIONS["MultiCastActionBarFrame"].baseY = 8;
            --UIPARENT_MANAGED_FRAME_POSITIONS["MULTICASTACTIONBAR_YPOS"].baseY = 0;
        end
        --UIParent_ManageFramePositions();
    end
end);

-- Move the microbuttons
function FloRetroUI_MainMenuBar_OnShow()

    if InCombatLockdown() then return end

    MoveMicroButtons("LEFT", MainMenuBarArtFrame, "LEFT", -BAGS_WIDTH - 10, -12, false);

    MainMenuBarPerformanceBar:SetSize(28, 40);
    for i=1, #MICRO_BUTTONS do
        _G[MICRO_BUTTONS[i]]:SetSize(24, 36);
        _G[MICRO_BUTTONS[i].."Flash"]:SetSize(29, 40);
        if i ~= 1 then
            local relativeTo;
            _, relativeTo = _G[MICRO_BUTTONS[i]]:GetPoint(1);
            _G[MICRO_BUTTONS[i]]:SetPoint("BOTTOMLEFT", relativeTo, "BOTTOMRIGHT", -4, 0);
        end
	end
end

MainMenuBar:HookScript("OnShow", FloRetroUI_MainMenuBar_OnShow);

-- Two columns right multibar
SetCVar("multiBarRightHorizontalLayout", "1");

-- Move the right bar toward the bottom
hooksecurefunc("MultiActionBar_Update", function()
    if InCombatLockdown() then return end
    if ( SHOW_MULTI_ACTIONBAR_3 ) then
		VerticalMultiBarsContainer:SetPoint("BOTTOMRIGHT", 0, MicroButtonAndBagsBar:GetTop() + 24);
    end
end);
