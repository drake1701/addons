-- DailyProf
-- Dräke

SLASH_DAILYPROF1 = '/dailyprof';

COOLDOWNS = {
    ['Alchemical Catalyst'] = true,
    ['Secrets of Draenor Alchemy'] = true,
    
    ['Truesteel Ingot'] = true,
    ['Secrets of Draenor Blacksmithing'] = true,
    
    ['Secrets of Draenor Enchanting'] = true,
    
    ['Gearspring Parts'] = true,
    ['Secrets of Draenor Engineering'] = true,
    
    ['War Paints'] = true,
    ['Secrets of Draenor Inscription'] = true,
    
    ['Taladite Crystal'] = true,
    ['Secrets of Draenor Jewelcrafting'] = true,
    
    ['Burnished Leather'] = true,
    ['Secrets of Draenor Leatherworking'] = true,
    
    ['Hexweave Cloth'] = true,
    ['Secrets of Draenor Tailoring'] = true,
}

local function handler(msg, editbox)
    local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions()
    local firstProf = tostring(GetProfessionInfo(prof1))
    DEFAULT_CHAT_FRAME:AddMessage(firstProf)
    CastSpellByName(firstProf)
        if not GetTradeSkillCategoryFilter(0) then
			SetTradeSkillCategoryFilter(0, 1, 1)
		end
    	SetTradeSkillItemNameFilter("")
    	SetTradeSkillItemLevelFilter(0,0)
        local numSkills = GetNumTradeSkills()
    	for i = 1, numSkills do
    		local skillName, skillType, _, isExpanded = GetTradeSkillInfo(i)
    		if i == 1 and skillType == "subheader" then skillType = "header" end
    		if skillType == "header" or skillType == "subheader" then
    			if not isExpanded then
    				ExpandTradeSkillSubClass(i)
    			end
    		end
    	end
        for i = 1, numSkills, 1 do
            local skillName, skillType, _, isExpanded, _, _, _, _, _, _, _, displayAsUnavailable, _ = GetTradeSkillInfo(i);
            if i == 1 and skillType == "subheader" then skillType = "header" end
            
			if (name and type ~= "header") then
                DEFAULT_CHAT_FRAME:AddMessage(skillName)
            end
            
            if(COOLDOWNS[skillName]) then
                local cooldown = GetTradeSkillCooldown(i)
                if(cooldown) then
                    local s = math.floor( cooldown % 60)
                    local m = math.floor((cooldown / 60) % 60)
                    local h = math.floor((cooldown / (60 * 60)) % 24)
                    DEFAULT_CHAT_FRAME:AddMessage(skillName .. " Resets in " .. h .. "hr " .. m .. "min " .. s .. "sec");
                else 
                    DoTradeSkill(i, 1);
                end
            end
        end
    CloseTradeSkill();
    local secondProf = tostring(GetProfessionInfo(prof2))
    DEFAULT_CHAT_FRAME:AddMessage(secondProf)
    CastSpellByName(secondProf)
        if not GetTradeSkillCategoryFilter(0) then
			SetTradeSkillCategoryFilter(0, 1, 1)
		end
    	SetTradeSkillItemNameFilter("")
    	SetTradeSkillItemLevelFilter(0,0)
        local numSkills = GetNumTradeSkills()
    	for i = 1, numSkills do
    		local skillName, skillType, _, isExpanded = GetTradeSkillInfo(i)
    		if i == 1 and skillType == "subheader" then skillType = "header" end
    		if skillType == "header" or skillType == "subheader" then
    			if not isExpanded then
    				ExpandTradeSkillSubClass(i)
    			end
    		end
    	end
        for i = 1, numSkills, 1 do
            skillName, skillType, numAvailable, isExpanded, serviceType, numSkillUps, indentLevel, showProgressBar, currentRank, maxRank, startingRank = GetTradeSkillInfo(i)
            if i == 1 and skillType == "subheader" then skillType = "header" end
            
            if(COOLDOWNS[skillName]) then
                local cooldown = GetTradeSkillCooldown(i);
                if(cooldown) then
                    local s = math.floor( cooldown % 60)
                    local m = math.floor((cooldown / 60) % 60)
                    local h = math.floor((cooldown / (60 * 60)) % 24)
                    DEFAULT_CHAT_FRAME:AddMessage(skillName .. " Resets in " .. h .. "hr " .. m .. "min " .. s .. "sec");
                else 
                    DoTradeSkill(i, 1);
                end
            end
        end
    CloseTradeSkill()
end

SlashCmdList["DAILYPROF"] = handler;