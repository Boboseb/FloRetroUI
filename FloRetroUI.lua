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

hooksecurefunc(StatusTrackingBarManager, "LayoutBar", function (self, bar, barWidth, isTopBar, isDouble)
		
	bar:ClearAllPoints();
	
	if ( isDouble ) then
		if ( isTopBar ) then
			bar:SetPoint("BOTTOM", MainMenuBarArtFrame, "TOP", 0, -8);
		else		
			bar:SetPoint("BOTTOM", MainMenuBarArtFrame, "TOP", 0, -17);
		end
		self:SetDoubleBarSize(bar, barWidth + BAGS_WIDTH * 2);
	else 
		bar:SetPoint("BOTTOM", MainMenuBarArtFrame, "TOP", 0, -17);
		self:SetSingleBarSize(bar, barWidth + BAGS_WIDTH * 2);
    end
end);

hooksecurefunc(MainMenuBar, "SetPositionForStatusBars", function ()
	MainMenuBar:ClearAllPoints();
	MainMenuBarArtFrame.LeftEndCap:ClearAllPoints();
	MainMenuBarArtFrame.RightEndCap:ClearAllPoints();

    MainMenuBar:SetPoint("BOTTOM", MainMenuBar:GetParent(), 0, 0);
	MainMenuBarArtFrame.LeftEndCap:SetPoint("BOTTOMLEFT", MainMenuBar, -98 - BAGS_WIDTH, 0);
    MainMenuBarArtFrame.RightEndCap:SetPoint("BOTTOMRIGHT", MainMenuBar, 98 + BAGS_WIDTH, 0);
    
    MainMenuBarBackpackButton:SetParent(MainMenuBar);
    MainMenuBarBackpackButton:ClearAllPoints();
    MainMenuBarBackpackButton:SetPoint("RIGHT", MainMenuBar, BAGS_WIDTH, -3);
    
    for i = 0,3 do
        _G["CharacterBag"..i.."Slot"]:SetParent(MainMenuBar);
        _G["CharacterBag"..i.."Slot"]:SetSize(40, 40);
        _G["CharacterBag"..i.."Slot"].IconBorder:SetSize(40, 40);
    end
    CharacterBag0Slot:ClearAllPoints();
    CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -4, 0);
    MicroButtonAndBagsBar:Hide();

    FloRetroUI_MainMenuBar_OnShow();

    if ( IsPlayerInWorld() ) then
        MultiBarBottomRightButton7:ClearAllPoints();

        if ( StatusTrackingBarManager:GetNumberVisibleBars() == 2 ) then
            UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"].baseY = 27;
            UIPARENT_MANAGED_FRAME_POSITIONS["PETACTIONBAR_YPOS"].baseY = 103;
            MultiBarBottomRightButton7:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, 27);
        elseif ( StatusTrackingBarManager:GetNumberVisibleBars() == 1 ) then
            UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"].baseY = 24;
            UIPARENT_MANAGED_FRAME_POSITIONS["PETACTIONBAR_YPOS"].baseY = 100;
            MultiBarBottomRightButton7:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, 24);
       else 
            UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"].baseY = 13;
            UIPARENT_MANAGED_FRAME_POSITIONS["PETACTIONBAR_YPOS"].baseY = 89;
            MultiBarBottomRightButton7:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, 13);

            --UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"].baseY = 2;
            --UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"].baseY = 2;
            --UIPARENT_MANAGED_FRAME_POSITIONS["MultiCastActionBarFrame"].baseY = 8;
            --UIPARENT_MANAGED_FRAME_POSITIONS["MULTICASTACTIONBAR_YPOS"].baseY = 0;
        end
        UIParent_ManageFramePositions();
    end
end);

function FloRetroUI_MainMenuBar_OnShow()
	--UpdateMicroButtonsParent(MainMenuBarArtFrame);
    MoveMicroButtons("LEFT", MainMenuBar, "LEFT", -BAGS_WIDTH - 10, -2, false);

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
