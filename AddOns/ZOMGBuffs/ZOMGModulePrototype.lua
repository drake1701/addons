local z = ZOMGBuffs
if (z) then

local new, del, deepDel, copy = z.new, z.del, z.deepDel, z.copy

local L = LibStub("AceLocale-3.0"):GetLocale("ZOMGBuffs")

z.modulePrototype = {}
function z.modulePrototype:CheckBuffs()
end

function z.modulePrototype:SetClickSpells(cell)
end

function z.modulePrototype:TooltipUpdate(tooltip)
end

function z.modulePrototype:OnSaveTemplate(templateName)
end

function z.modulePrototype:OnSelectTemplate(templateName)
end

function z.modulePrototype:OnDeleteTemplate(n)
end

function z.modulePrototype:OnRenameTemplate(old, new)
end

function z.modulePrototype:OnModifyTemplate(key, value)
end

function z.modulePrototype:GetModuleOptions()
	return self.options
end

function z.modulePrototype:OnModuleEnable()
end

function z.modulePrototype:OnModuleDisable()
end

function z.modulePrototype:OnModuleInitialize()
end

function z.modulePrototype:OnResetDB()
end

function z.modulePrototype:CanChangeState()
	return true
end

function z.modulePrototype:IsModuleActive()
	return self:IsEnabled()
	--return z:IsModuleActive(self)
end

--function z.modulePrototype:Print(...)
--	z:Print(self, ...)
--end
--
--function z.modulePrototype:Printf(...)
--	z:Printf(self, ...)
--end

-- argCheck
--[===[@debug@
function z.modulePrototype.argCheck(self, arg, num, kind, kind2, kind3, kind4, kind5)
	z.argCheck(self, arg, num, kind, kind2, kind3, kind4, kind5)
end
--@end-debug@]===]

function z.modulePrototype:MakeTemplateDescription()
	return L["Load this template"]
end

-- ReagentsOptions
function z.modulePrototype:MakeReagentsOptions(args)
	if (self.db) then
		local any
		local level = UnitLevel("player")
		for k,v in pairs(self.reagents) do
			if ((not v.maxLevel or level <= v.maxLevel) and (not v.minLevel or level >= v.minLevel)) then
				if (not self.db.char.reagents[k]) then
					self.db.char.reagents[k] = v[1]
				end
				local name = k
				if (type(name) == "number") then
					name = GetItemInfo(k)
					if (not name) then
						-- Not in cache, so we'll retreive it for next time
						GameTooltip:SetHyperlink(format("|Hitem:%d|h", k))
						GameTooltip:Hide()
					end
				end

				if (name) then
					local icon = select(10, GetItemInfo(k))
					if (icon and icon ~= "") then
						name = "|T"..icon..":0|t "..name
					end
					args[name or tostring(k)] = {
						type = "range",
						name = name,
						desc = format(L["Auto purchase level for %s (will not exceed this amount)"], name),
						get = function(info) return self.db.char.reagents[k] end,
						set = function(info,value) self.db.char.reagents[k] = value end,
						min = 0,
						max = v[3],
						step = v[2]
					}
					any = true
				end
			else
				self.db.char.reagents[k] = nil			-- 0
			end
		end
	end
end

-- getOptAuto
function z.modulePrototype:getOptAuto(which)
	local templates = self:GetTemplates()
	if (templates and templates[which]) then
		return templates[which].state or "never"
	end
end

-- setOptAuto
function z.modulePrototype:setOptAuto(which, state)
	local templates = self:GetTemplates()
	if (templates and templates[which]) then
		templates[which].state = (state ~= "never" and state) or nil
	end
end

-- MakeTemplateOptions
function z.modulePrototype:MakeTemplateOptions()
	if (not self.db) then
		return
	end

	local args = {}
	local templates = self:GetTemplates()

	if (templates) then
		local list = new()
		for k,v in pairs(templates) do
			tinsert(list, k)
		end
		sort(list)

		if ((templates.current and templates.current.modified) or templates.last) then
			if (#list > 0) then
				args.spacer = {
					type = "header",
					name = " ",
					order = 100,
				}
			end

			if (templates.last) then
				args.last = {
					type = "execute",
					name = L["Last"],
					desc = self:MakeTemplateDescription("last", L["Revert to the previously unsaved template"]),
					order = 101,
					func = function(n) self:SelectTemplate("last") end,
				}
			end

			if (templates.current.modified or self:GetSelectedTemplate() == "-") then
				args.save = {
					type = "input",
					name = L["Save"],
					desc = L["Save current setup as a new template"],
					get = false,
					set = function(info,n) self:SaveTemplate(n) end,
					order = 102,
				}
			end
		end

		for i = 1,#list do
			if (list[i] ~= "current" and list[i] ~= "last") then
				local templateName = list[i]
				if (type(templateName) ~= "string" or templateName == "") then
					templateName = "Unnamed"
				end
				args[templateName] = {
					type = "group",
					name = templateName,
					desc = self:MakeTemplateDescription(templateName),
					order = i,
					args = {
						load = {
							type = "execute",
							name = L["Load"],
							desc = L["Load this template"],
							func = function() self:SelectTemplate(templateName) end,
							order = 1,
						},
						auto = {
							type = "select",
							name = L["Auto Switch"],
							desc = L["Automatically switch to this template"],
							values = {never = L["Never"], party = L["Party"], raid = L["Raid"], solo = L["Solo"], bg = L["Battleground"], arena = L["Arena"]},
							get = function() return self:getOptAuto(templateName) end,
							set = function(info,val) self:setOptAuto(templateName, val) end,
							order = 2,
						},
						rename = {
							type = "input",
							name = L["Rename"],
							desc = L["Rename this template"],
							get = false,
							set = function(info, value) self:RenameTemplate(templateName, value) end,
							order = 99,
						},
						delete = {
							type = "execute",
							name = L["Delete"],
							desc = L["Delete this template"],
							func = function(n) self:DeleteTemplate(templateName) end,
							order = 100,
						}
					}
				}
			end
		end

		self.options.args.template.args = args
		del(list)
	end
end

-- ModifyTemplate
function z.modulePrototype:ModifyTemplate(key, value)
--[===[@debug@
	self:argCheck(key, 1, "string")
	self:argCheck(value, 2, "string", "boolean", "nil")
--@end-debug@]===]
	if (self.db) then
		local templates = self:GetTemplates()

		if (templates and templates.current) then
			value = value or nil
			if (templates.current[key] ~= value) then
				templates.current[key] = value
				if (self:GetSelectedTemplate() ~= "-") then
					templates.current.modified = true
				end

				self:OnModifyTemplate(key, value)

				z:CheckForChange(self)
				z:UpdateCellSpells()
				self:MakeTemplateOptions()

				if (z.qTooltip) then
					z:OnTooltipUpdate()
				end
			end
		end
	end
end

-- DeleteTemplate
function z.modulePrototype:DeleteTemplate(n)
	self:OnDeleteTemplate(n)

	local templates = self:GetTemplates()
	templates[n] = nil
	self:MakeTemplateOptions()
end

-- RenameTemplate
function z.modulePrototype:RenameTemplate(old, new)
	if (new and new ~= "" and new ~= "-") then
		self:OnRenameTemplate(n)

		local templates = self:GetTemplates()

Xtemplates = templates
Xold = old
Xnew = new
		if (templates[old]) then
			local t = templates[old]
			templates[old] = nil
			templates[new] = t

			if (self:GetSelectedTemplate() == old) then
				self:SetSelectedTemplate(new)
			end

			self:MakeTemplateOptions()

			self:Printf(L["Renamed template |cFFFFFF80%s|r to |cFFFFFF80%s|r"], tostring(old), tostring(new))
		end
	end
end

-- GetTemplates
function z.modulePrototype:GetTemplates()
	local page
	if (not self.db.profile.templates and GetNumSpecGroups() > 1 and GetActiveSpecGroup() > 1) then
		page = "templates"..GetActiveSpecGroup()

		if (not self.db.char[page]) then
			-- First time selecting a new talent group will copy the templates from group 1
			self.db.char[page] = copy(self.db.char.templates)

			self.db.char["selectedTemplate"..GetActiveSpecGroup()] = self.db.char.selectedTemplate
		end
	else
		page = "templates"
	end
	return self.db.char[page] or self.db.profile[page]
end

-- GetSelectedTemplate
function z.modulePrototype:GetSelectedTemplate()
	if (not self.db.profile.templates and GetNumSpecGroups() > 1 and GetActiveSpecGroup() > 1) then
		local name = "selectedTemplate"..GetActiveSpecGroup()
		return self.db.char[name]
	end

	return self.db.char.selectedTemplate
end

-- GetSelectedTemplate
function z.modulePrototype:SetSelectedTemplate(set)
	if (not self.db.profile.templates and GetNumSpecGroups() > 1 and GetActiveSpecGroup() > 1) then
		local name = "selectedTemplate"..GetActiveSpecGroup()
		self.db.char[name] = set
		return
	end

	self.db.char.selectedTemplate = set
end

-- SaveTemplate
function z.modulePrototype:SaveTemplate(templateName)
	if (self.db and templateName and templateName ~= "" and templateName ~= "-") then
		local templates = self:GetTemplates()

		local template = templates.current
		template.modified = nil
		self:SetSelectedTemplate(templateName)
		templates[templateName] = copy(template)

		self:OnSaveTemplate(templateName, templates[templateName])

		self:Printf(L["Saved template %q"], templateName)

		self:MakeTemplateOptions(self)
	end
end

-- SelectTemplate
function z.modulePrototype:SelectTemplate(templateName, reason)
	if (self.db) then
		local templates = self:GetTemplates()
		if (templates[templateName]) then
			if (templates.current and templates.current.modified) then
				del(templates.last)
				templates.last = copy(templates.current)
			end

			if (reason) then
				self:Printf(L["Switched to template %q because %s"], templateName, reason)
			else
				self:Printf(L["Switched to template %q"], templateName)
			end

			self:SetSelectedTemplate(templateName)
			templates.current = copy(templates[templateName])

			self:OnSelectTemplate()

			self:MakeTemplateOptions(self)

			z:CheckForChange(self)
			z:UpdateCellSpells()

			return true
		end
	end
end

-- OnStateChanged
function z.modulePrototype:OnStateChanged(newState, reason)
	if (self.db and self:CanChangeState()) then
		local t = self.db.char.templates or self.db.profile.templates
		if (t) then
			for k,v in pairs(t) do
				if (k ~= "current" and v.state == newState) then
					if (k ~= self:GetSelectedTemplate()) then
						if (not self.lastAutoTemplate or self.lastAutoTemplate ~= k) then
							self.lastAutoTemplate = k

							if (t.current and t.current.modified) then
								self:SaveTemplate(L["Autosave"])
							end
							self:SelectTemplate(k, reason)
						end
					end
					break
				end
			end
		end
	end
end

-- OnResetDB
function z.modulePrototype:SetupDB()
	if (self.db) then
		local templates = self:GetTemplates()
		if (templates) then
			local template = templates.current
			if (not template) then
				if (self.db.char.defaultTemplate or self.db.profile.defaultTemplate) then
					self:SelectTemplate(self.db.char.defaultTemplate or self.db.profile.defaultTemplate)
					if (not templates.current) then
						templates.current = {}
					end
				else
					templates.current = {}
				end
			end
		end
	end
end

-- PLAYER_TALENT_UPDATE
function z.modulePrototype:PLAYER_TALENT_UPDATE()
	if (self.db and self.db.char.templates) then
		self:MakeTemplateOptions()
		self:OnResetDB()
		z:SetupForSpell()
		z:RequestSpells()
	end
end

-- OnInitialize
function z.modulePrototype:OnInitialize()
	self.name = self:GetName()
	self:OnModuleInitialize()
end

-- SetupOptions
function z.modulePrototype:SetupOptions()
	if (self.options) then
		local name = self:GetName()
		if (not z.options.args[name]) then
			z.options.args[name] = self.options
			self.options.order = 5
			z.optionsFrames[self:GetName()] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ZOMGBuffs", L[name], "ZOMGBuffs", name)
		end
	end
end

-- OnEnable
function z.modulePrototype:OnEnable()
	self:SetupDB()
	self:OnResetDB()
	self:SetupOptions()

	self:RegisterEvent("PLAYER_TALENT_UPDATE")

	self.currentTalentGroup = GetActiveSpecGroup()

	self:OnModuleEnable()
	self:MakeTemplateOptions(self)
end

-- OnDisable
function z.modulePrototype:OnDisable()
	self:OnModuleDisable()
end

z:SetDefaultModulePrototype(z.modulePrototype)

end
