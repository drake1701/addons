local E, L, DF = unpack(select(2, ...))
local B = E:GetModule('Blizzard');

local ObjectiveFrameHolder = CreateFrame("Frame", "ObjectiveFrameHolder", E.UIParent)
ObjectiveFrameHolder:SetWidth(130)
ObjectiveFrameHolder:SetHeight(22)
ObjectiveFrameHolder:SetPoint('TOPRIGHT', E.UIParent, 'TOPRIGHT', -135, -300)

function B:ObjectiveFrameHeight()
	ObjectiveTrackerFrame:Height(E.db.general.objectiveFrameHeight)
end

local function IsFramePositionedLeft(frame)
	local x = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local screenHeight = GetScreenHeight()
	local positionedLeft = false

	if x and x < (screenWidth / 2) then
		positionedLeft = true;
	end

	return positionedLeft;
end

function B:MoveObjectiveFrame()
	E:CreateMover(ObjectiveFrameHolder, 'ObjectiveFrameMover', L['Objective Frame'])
	ObjectiveFrameHolder:SetAllPoints(ObjectiveFrameMover)

	ObjectiveTrackerFrame:ClearAllPoints()
	ObjectiveTrackerFrame:SetPoint('TOP', ObjectiveFrameHolder, 'TOP')
	B:ObjectiveFrameHeight()
	ObjectiveTrackerFrame:SetClampedToScreen(false)
	hooksecurefunc(ObjectiveTrackerFrame,"SetPoint",function(_,_,parent)
		if parent ~= ObjectiveFrameHolder then
			ObjectiveTrackerFrame:ClearAllPoints()
			ObjectiveTrackerFrame:SetPoint('TOP', ObjectiveFrameHolder, 'TOP')
		end
	end)

	hooksecurefunc("BonusObjectiveTracker_AnimateReward", function(block)
		local rewardsFrame = ObjectiveTrackerBonusRewardsFrame;
		rewardsFrame:ClearAllPoints();
		if E.db.general.bonusObjectivePosition == "RIGHT" or (E.db.general.bonusObjectivePosition == "AUTO" and IsFramePositionedLeft(ObjectiveTrackerFrame)) then
			rewardsFrame:SetPoint("TOPLEFT", block, "TOPRIGHT", -10, -4);
		else
			rewardsFrame:SetPoint("TOPRIGHT", block, "TOPLEFT", 10, -4);
		end
	end)
end