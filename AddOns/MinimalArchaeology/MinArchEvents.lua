function MinArch:EventMain(event, ...)
	if (event == "CURRENCY_DISPLAY_UPDATE" and MinArchHideNext == true) then
		MinArch:MaineEventHideAfterDigsite();		
	elseif (event == "SKILL_LINES_CHANGED") then
		MinArch:UpdateArchaeologySkillBar();		
	elseif (event == "ARTIFACT_DIG_SITE_UPDATED" and MinArchOptions['HideAfterDigsite'] == true) then
		MinArchHideNext = true;
	elseif (event == "ARTIFACT_COMPLETE" and MinArchHideNext == true and MinArchOptions['WaitForSolve'] == true) then
		MinArch:HideMain();
		MinArchHideNext = false;
		
		MinArchHist:RegisterEvent("ARTIFACT_HISTORY_READY");
		RequestArtifactCompletionHistory();
	elseif (event == "PLAYER_ALIVE" or event == "ARTIFACT_COMPLETE") then
		MinArchHist:RegisterEvent("ARTIFACT_HISTORY_READY");
		RequestArtifactCompletionHistory();
	elseif (event == "ADDON_LOADED" and MinArch ~= nil and MinArchIsReady ~= true) then
		MinArch:MainEventAddonLoaded();
	elseif (event == "ADDON_LOADED") then
		local addonname = ...;
		
		if (addonname == "Blizzard_ArchaeologyUI") then
			MinArchMain:UnregisterEvent("ARTIFACT_HISTORY_READY");
		end
		
	elseif (event == "ARCHAEOLOGY_CLOSED") then
		MinArchMain:RegisterEvent("ARTIFACT_HISTORY_READY");
	end	
	
	if (MinArchIsReady == true) then
		MinArch:UpdateMain();
	end
end

function MinArch:EventHist(event, ...)
	if (event == "ARTIFACT_HISTORY_READY") then
		if (IsArtifactCompletionHistoryAvailable()) then
			for i = 1, 12 do
				MinArch:LoadItemDetails(i);
				MinArch:GetHistory(i);
			end
			MinArch:CreateHistoryList(MinArchOptions['CurrentHistPage']);
			MinArch:CreateHistoryList(MinArchOptions['CurrentHistPage']);
			
			if (MinArchIsReady == true) then
				MinArch:UpdateMain();
			end
			
			MinArchHist:UnregisterEvent("ARTIFACT_HISTORY_READY");
		end
	end
end

function MinArch:EventDigsites(event, ...)
	if (event == "UNIT_SPELLCAST_SENT") then
		local unit, spellname, rank, desc = ...;
	
		if MinArchDigsites:IsVisible() and unit == "player" and spellname == GetSpellInfo(73979) then
			for index, artifact in pairs(MinArch['artifacts']) do
				if (desc ~= nil and artifact['race'] ~= nil ) then
					local hasRace = string.find(tostring(desc), tostring(artifact['race']));
						
					if (hasRace ~= nil) then
						MinArch:UpdateActiveDigSitesRace(tostring(artifact['race']));
						
						local ContID = GetCurrentMapContinent();
						if (ContID ~= nil) then
							MinArch:CreateDigSitesList(ContID);
							MinArch:CreateDigSitesList(ContID);
						end
					end
				end			
			end	
			
			
		end
	elseif (event == "WORLD_MAP_UPDATE" and MinArchIsReady == true) then		
		MinArch:ShowRaceIconsOnMap();
	else
		MinArch:UpdateActiveDigSites();
		local ContID = GetCurrentMapContinent();
		if (ContID ~= nil) then
			MinArch:CreateDigSitesList(ContID);
			MinArch:CreateDigSitesList(ContID);
		end
	end
end

function MinArch:MaineEventHideAfterDigsite()
	if (MinArchOptions['WaitForSolve'] == true) then
		local wait = false;
		for i=1,12 do
			MinArch:UpdateArtifact(i);
			if (MinArch['artifacts'][i]['canSolve'] and MinArchOptions['ABOptions'][i]['Hide'] == false) then
				wait = true;
			end
		end

		if (wait == false) then
			MinArch:HideMain();
			MinArchHideNext = false;
		end
	else
		MinArch:HideMain();
		MinArchHideNext = false;
	end
end

function MinArch:MainEventAddonLoaded()
	-- Apply Settins/SavedVariables
	if (MinArchOptions['MinimapPos'] ~= nil) then
		MinArch:MinimapButtonReposition();
	else
		MinArchOptions['MinimapPos'] = 45;
	end
	
	if (MinArchOptions['CurrentHistPage'] == nil) then
		MinArchOptions['CurrentHistPage'] = 1;
	end
		
	if (MinArchOptions['StartHidden'] == nil) then
		MinArchOptions['StartHidden'] = false;
	else
		if (MinArchOptions['StartHidden'] == true) then
			MinArch:HideMain();
		end
	end
		
	if (MinArchOptions['HideMain'] == nil) then
		MinArch:ShowMain();
	else
		if (MinArchOptions['HideMain'] == true) then
			MinArch:HideMain();
		end
	end
		
	if (MinArchOptions['HideMinimap'] == nil) then
		MinArchOptions['HideMinimap'] = false;
	else
		if (MinArchOptions['HideMinimap'] == true) then
			MinArchMinimapButton:Hide();
		end
	end
		
	if (MinArchOptions['DisableSound'] == nil) then
		MinArchOptions['DisableSound'] = false;
	end

	if (MinArchOptions['HideAfterDigsite'] == nil) then
		MinArchOptions['HideAfterDigsite'] = false;
	end	
		
	if (MinArchOptions['WaitForSolve'] == nil) then
		MinArchOptions['WaitForSolve'] = false;
	end	
		
	if (MinArchOptions['FrameScale'] == nil) then
		MinArchOptions['FrameScale'] = 100;
	end
		
	for i=0,12 do
		if (MinArchOptions['ABOptions'][i] == nil) then
			MinArchOptions['ABOptions'][i] = {}; 
			MinArchOptions['ABOptions'][i]['Hide'] = false;
			MinArchOptions['ABOptions'][i]['Cap'] = false;
			MinArchOptions['ABOptions'][i]['AlwaysUseKeystone'] = false;
		end
	end
	
	MinArch:CommonFrameScale(MinArchOptions['FrameScale']);
	MinArchIsReady = true;
		
	ChatFrame1:AddMessage("Minimal Archaeology Loaded!");
end
