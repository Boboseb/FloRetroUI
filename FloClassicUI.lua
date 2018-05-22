-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------

local VERSION = "8.0.1"

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
		self:SetDoubleBarSize(bar, barWidth);
	else 
		bar:SetPoint("BOTTOM", MainMenuBarArtFrame, "TOP", 0, -17);
		self:SetSingleBarSize(bar, barWidth);
    end
end);

hooksecurefunc(MainMenuBar, "SetPositionForStatusBars", function ()
	MainMenuBar:ClearAllPoints(); 
	MainMenuBarArtFrame.LeftEndCap:ClearAllPoints(); 
	MainMenuBarArtFrame.RightEndCap:ClearAllPoints(); 

    MainMenuBar:SetPoint("BOTTOM", MainMenuBar:GetParent(), 0, 0);
	MainMenuBarArtFrame.LeftEndCap:SetPoint("BOTTOMLEFT", MainMenuBar, -98, 0); 
    MainMenuBarArtFrame.RightEndCap:SetPoint("BOTTOMRIGHT", MainMenuBar, 98, 0);
    
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
