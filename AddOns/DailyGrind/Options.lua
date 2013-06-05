-- Author      : Deldinor of Elune
-- Create Date : 2/20/2011 3:01:53 PM

function DailyGrind:ShowOptions()
	InterfaceOptionsFrame_OpenToCategory(addonFullName);
	InterfaceOptionsFrame_OpenToCategory(addonFullName); -- HACK: Second call as workaround for 5.3 bug
end

DailyGrind.defaultSettings = {
	Enabled = true,
	AutoAcceptAllEnabled = false,
	Verbose = false,
	Blacklist = {},
	NpcBlacklist = {},
	RewardList = {},
	SuspendKeys = { CTRL = 1 },
	RepeatableQuestsEnabled = false
}

DailyGrind.Options = {
	type = "group",
	name = addonFullName,
	get = function(info) return Settings[ info[#info] ] end,
	set = function(info, value) Settings[ info[#info] ] = value end,
	args = {
		General = {
			order = 1,
			type = "group",
			name = "General Settings",
			desc = "General Settings",
			args = {
				Enabled = {
					type = "toggle",
					name = "Enabled",
					desc = "Enables or disables "..addonTitle.."'s automation functions, though your completed quests will still be recorded.",
					order = 1
				},
				AutoAcceptAllEnabled = {
					type = "toggle",
					name = "Accept ALL Dailies",
					desc = "Optionally allows you to accept ALL daily quests you encounter, even if you've never encountered them before. Your completed quests will still be recorded into your history while this option is enabled.",
					order = 2
				},
				Verbose = {
					type = "toggle",
					name = "Verbose Mode",
					desc = "Displays more messages about what the addon is doing when it's automating actions for you.",
					order = 3
				},
				intro = {
					order = 4,
					type = "description",
					name = "\n"..addonTitle.." auto-accepts and auto-completes daily and repeatable quests as you encounter them.\n\nDaily quests that you complete are added to your quest history. Whenever you see that daily again, you will automatically accept and complete it. This approach is taken so that players may read through quests that they have not yet encountered.\n"
				},
				Blacklist = {
					type = "input",
					multiline = true,
					width = "double",
					name = "Blacklist",
					desc = "Add any quests that you don't want "..addonTitle.." to auto-accept or auto-complete, |c"..commandColor.."one quest per line|r. Proper capitalization is not required, but all other characters in the quest name must be accurate. You may may also use |c"..commandColor.."*|r as a wildcard.",
					order = 5,
					get = function(info)
						return CharacterBlacklist:ToString();
					end,
					set = function(info, value)
						local itemList = { strsplit("\n", value:trim()) };
						CharacterBlacklist:Populate(itemList);
					end,
				},
				NpcBlacklist = {
					type = "input",
					multiline = true,
					width = "double",
					name = "NPC Blacklist",
					desc = "Add any NPCs that you don't want "..addonTitle.." to auto-accept or auto-complete quests from, |c"..commandColor.."one NPC per line|r. Proper capitalization is not required, but all other characters in the NPC name must be accurate. You may may also use |c"..commandColor.."*|r as a wildcard.",
					order = 6,
					get = function(info)
						return CharacterNpcBlacklist:ToString();
					end,
					set = function(info, value)
						local itemList = { strsplit("\n", value:trim()) };
						CharacterNpcBlacklist:Populate(itemList);
					end,
				},
				RewardList = {
					type = "input",
					multiline = true,
					width = "double",
					name = "Reward List",
					desc = "Add any quest rewards that you want "..addonTitle.." to automatically select, |c"..commandColor.."one reward per line|r. Proper capitalization is not required, but all other characters in the reward name must be accurate. You may may also use |c"..commandColor.."*|r as a wildcard.",
					order = 7,
					get = function(info)
						return CharacterRewardList:ToString();
					end,
					set = function(info, value)
						local itemList = { strsplit("\n", value:trim()) };
						CharacterRewardList:Populate(itemList);
					end,
				},
				SuspendKeys = {
					type = "group",
					name = "Suspend Keys",
					guiInline = true,
					order = 9,
					args = {
						intro = {
							order = 0,
							type = "description",
							name = "Temporarily suspend automation by holding down any of the selected keys while talking to an NPC."
						},
						ALT = {
							order = 1,
							type = "toggle",
							name = "ALT",
							get = function(info)
								return Settings.SuspendKeys["ALT"];
							end,
							set = function(info, value)
								CharacterSuspendKeyList:Set("ALT", value);
							end
						},
						CTRL = {
							order = 2,
							type = "toggle",
							name = "CTRL (default)",
							get = function(info)
								return Settings.SuspendKeys["CTRL"];
							end,
							set = function(info, value)
								CharacterSuspendKeyList:Set("CTRL", value);
							end
						},
						SHIFT = {
							order = 3,
							type = "toggle",
							name = "SHIFT",
							get = function(info)
								return Settings.SuspendKeys["SHIFT"];
							end,
							set = function(info, value)
								CharacterSuspendKeyList:Set("SHIFT", value);
							end
						},
					}
				},
				repeatableQuestGroup = {
					type = "group",
					name = "Reaptable Quests",
					guiInline = true,
					order = 11,
					args = {
						RepeatableQuestsEnabled = {
							order = 1,
							width = "full",
							type = "toggle",
							name = "Automate Repeatable Quests",
							desc = "Forces "..addonTitle.." to attempt to complete Repeatable Quests (|c"..repeatableQuestColor.."blue question marks|r) immediately upon encountering them."
						},
						intro = {
							order = 2,
							type = "description",
							name = "Forces "..addonTitle.." to attempt to complete Repeatable Quests (the ones with |c"..repeatableQuestColor.."blue question marks|r instead of exclamation points) immediately upon encountering them.\n\nDefault behavior is to attempt to complete the Repeatable Quest only after it has been clicked on in the NPC's dialog window. Checking this option will cause Daily Grind to attempt to turn in the quest without this safeguard.\n\n|cFFFF0000"..repeatableWarning.."|r"
						},
					},
				},
				questHistoryGroup = {
					type = "group",
					name = "Quest History",
					guiInline = true,
					order = 12,
					args = {
						intro = {
							order = 1,
							type = "description",
							name = "You may start over by clicking the |c"..commandColor.."Clear Quest History|r button. This applies to all characters on your account.\n"
						},
						clear = {
							type = "execute",
							order = 2,
							name = "Clear Quest History",
							desc = "Reset your quest history. This applies to all characters on your account.",
							confirm = function()
								return "Are you sure you wish to clear your quest history? This action cannot be undone!"
							end,
							func = function()
								DailyGrind:ResetHistory();
							end,
						},
					},
				},
			},
		},
	},
}
