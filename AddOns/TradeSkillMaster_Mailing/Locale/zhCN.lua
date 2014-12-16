-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- TradeSkillMaster_Mailing Locale - zhCN
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/tradeskillmaster_mailing/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Mailing", "zhCN")
if not L then return end

L[ [=[Automatically rechecks mail every 60 seconds when you have too much mail.

If you loot all mail with this enabled, it will wait and recheck then keep auto looting.]=] ] = [=[当你有过多邮件时，每60秒自动重新检查邮件。
若你启用此功能时打开所有邮件，插件将等待并重新检查以保持自动拾取。]=]
L["Auto Recheck Mail"] = "自动复查邮件"
L["BE SURE TO SPELL THE NAME CORRECTLY!"] = "请务必保证收件人姓名拼写的正确性!!!"
L["Buy: %s (%d) | %s | %s"] = "竞拍获胜: %s (%d) | %s | %s"
L["Cannot finish auto looting, inventory is full or too many unique items."] = "自动打开邮件无法完成，背包已满或者拥有过多唯一物品。"
L["Chat Message Options"] = "聊天框消息选项"
L["Clear"] = "清除"
L["Clears the item box."] = "清空项目列表"
L["Click this button to send all disenchantable greens in your bags to the specified character."] = "点击此按钮将您背包中所有能分解的绿装发送给指定角色。"
L["Click this button to send excess gold to the specified character."] = "点击此按钮将发送超额的金币给指定角色。"
L["Click this button to send off the item to the specified character."] = "点击此按钮将物品邮寄给指定角色。"
L["COD Amount (per Item):"] = "邮件收费金额(每件):"
L["COD: %s | %s | %s | %s"] = "付款取信: %s | %s | %s | %s"
L["Collected COD of %s from %s for %s."] = "收取付费邮件%s, 从%s处, 花费%s。"
L["Collected expired auction of %s"] = "收取过期拍卖品 %s"
L["Collected mail from %s with a subject of '%s'."] = "从%s处收到主题为'%s'的邮件。"
L["Collected purchase of %s (%d) for %s."] = "收取购买的 %s (%d), 花费%s。"
L["Collected sale of %s (%d) for %s."] = "收取出售的 %s (%d), 收入%s。"
L["Collected %s and %s from %s."] = "收取%s和%s,从%s处。"
L["Collected %s from %s."] = "收取%s, 从%s处。"
L["Collect Gold"] = "收取金币"
L["Could not loot item from mail because your bags are full."] = "由于您的背包已满,无法再收取邮件。"
L["Could not send mail due to not having free bag space available to split a stack of items."] = "由于您的背包没有拆开堆叠的空间,无法发送出邮件。"
L["Display Total Money Received"] = "显示收取金币总额"
L["Drag (or place) the item that you want to send into this editbox."] = "将您想要邮寄的物品拖进编辑框。"
L["Enable Inbox Chat Messages"] = "开启对话框收件信息"
L["Enable Sending Chat Messages"] = "开启对话框发件信息"
L["Enter name of the character disenchantable greens should be sent to."] = "输入收取分解绿装的收件人姓名。"
L["Enter the desired COD amount (per item) to send this item with. Setting this to '0c' will result in no COD being set."] = "输入您希望的该物品邮寄时收取的费用(每件)。设置为 '0c' 将不会收取费用。"
L["Enter the name of the player you want to send excess gold to."] = "输入收取额外金币的收件人姓名。"
L["Enter the name of the player you want to send this item to."] = "输入收取这件物品的收件人姓名。"
L["Error creating operation. Operation with name '%s' already exists."] = "操作创建失败。操作名 '%s' 已经存在。"
L["Expired: %s | %s"] = "拍卖已到期: %s | %s"
L["General"] = "常规"
L["General Settings"] = "常规设置"
L["Give the new operation a name. A descriptive name will help you find this operation later."] = "给新操作命名, 一个描述性的名称将方便您找到它。"
L["If checked, a maxium quantity to send to the target can be set. Otherwise, Mailing will send as many as it can."] = "如果勾选，可以设置发送给目标的最大数量。不勾选，将会尽可能地发送(无限制发送)。"
L["If checked, information on mails collected by TSM_Mailing will be printed out to chat."] = "如果勾选，通过TSM_Mailing收取的邮件信息将会在聊天框里显示。"
L["If checked, information on mails sent by TSM_Mailing will be printed out to chat."] = "如果勾选，通过TSM_Mailing发送的邮件信息将会在聊天框里显示。"
L["If checked, the Mailing tab of the mailbox will be the default tab."] = "如果勾选，Mailing标签的将被设定为邮箱的默认标签。"
L["If checked, the 'Open All' button will leave any mail containing gold."] = "如果勾选，按钮“全部打开”将不再会收取含有金币的邮件。"
L["If checked, the target's current inventory will be taken into account when determing how many to send. For example, if the max quantity is set to 10, and the target already has 3, Mailing will send at most 7 items."] = "如果勾选，当决定发送多少时,收件人当前的库存将被考虑进来。例如,如果最大的数量设置为10件,目标已经有3件,邮件将发送最多7件。"
L["If checked, the target's guild bank will be included in their inventory for the 'Restock Target to Max Quantity' option."] = "如果勾选，  '对目标最大量补货'  时会包括其公会银行库存。"
L["If checked, the total amount of gold received will be shown at the end of automatically collecting mail."] = "如果勾选，收取的总金币数会显示在自动收件的最后。"
L["Inbox"] = "收信箱"
L["Include Guild Bank in Restock"] = "补充库存里包括公会银行"
L["Item (Drag Into Box):"] = "物品(拖进列表):"
L["Keep Quantity"] = "保持数量"
L["Leave Gold with Open All"] = "全部打开(不取金币)"
L["Limit (In Gold):"] = "限制(金):"
L["Mail Disenchantables:"] = "邮寄分解绿装:"
L["Mailing all to %s."] = "全部邮寄至 %s。"
L["Mailing operations contain settings for easy mailing of items to other characters."] = "Mailing操作的设置邮寄使邮寄更加便捷。"
L["Mailing up to %d to %s."] = "邮寄%d给%s。"
L["Mailing will keep this number of items in the current player's bags and not mail them to the target."] = "这是该物品的背包内最低保有量, 保有的物品不会被邮寄出去。"
L["Mail Selected Groups"] = "邮寄选定分组"
L["Mail Send Delay"] = "邮寄时间间隔"
L["Make Mailing Default Mail Tab"] = "将Mailing设置为默认标签"
L["Maxium Quantity"] = "最大数量"
L["Max Quantity:"] = "最大数量:"
L["Multiple Items"] = "多件物品"
L["New Operation"] = "新操作"
L["Next inbox update in %d seconds."] = "邮箱将在%d秒后刷新。"
L["No Item Specified"] = "没有指定物品"
L["No Quantity Specified"] = "没有指定数量"
L["No Target Player"] = "没有目标角色"
L["No Target Specified"] = "无指定目标"
L["Not sending any gold as you have less than the specified limit."] = "没有邮寄金币,因为您的金币数量低于金币保有量。"
L["Not Target Specified"] = "没有指定目标"
L["Open All"] = "全部打开"
L["Operation Name"] = "操作名"
L["Operations"] = "操作"
L["Operation Settings"] = "操作设置"
L["Options"] = "选项"
L["Other"] = "其他"
L["Quick Send"] = "快速发送"
L["Relationships"] = "关联"
L["Reload UI"] = "重载界面"
L["Restart Delay (minutes)"] = "自动邮件重启延迟（分钟）"
L["Restock Target to Max Quantity"] = "对目标最大数量补货"
L["Sale: %s (%d) | %s | %s"] = "拍卖成功: %s (%d) | %s | %s"
L["Send Disenchantable Greens to %s"] = "邮寄分解绿装给 %s"
L["Send Excess Gold to Banker:"] = "邮寄超额金币给金库角色:"
L["Send Excess Gold to %s"] = "邮寄超额金币给 %s"
L["Sending..."] = "发送中..."
L["Send Items Individually"] = "单独发送每种物品"
L["Sends each unique item in a seperate mail."] = "使用单独的邮件发送每个唯一物品"
L["Send %sx%d to %s - No COD"] = "邮寄 %sx%d 给 %s - 不收费"
L["Send %sx%d to %s - %s per Item COD"] = "邮寄 %sx%d 给 %s - 单件收费 %s"
L["Sent all disenchantable greens to %s."] = "邮寄全部分解绿件给 %s。"
L["Sent %s to %s."] = "邮寄%s给%s。"
L["Sent %s to %s with a COD of %s."] = "邮寄%s给%s附带收费%s。"
L["Set Max Quantity"] = "设置最大数量"
L["Sets the maximum quantity of each unique item to send to the target at a time."] = "设置单次邮寄的每种物品的最大邮寄量。"
L["Shift-Click to automatically re-send after the amount of time specified in the TSM_Mailing options."] = "Shift+右键点击 自动重发(在TSM_Mailing选项里设定的指定时间后)。"
L["Showing all %d mail."] = "显示全部%d封邮件。"
L["Showing %d of %d mail."] = "显示 %d / %d 封邮件。"
L["Skipping operation '%s' because there is no target."] = "由于没有目标,跳过操作 '%s' 。"
L["%s to collect."] = "%s等待收取。"
L["%s total gold collected!"] = "共收取金币 %s!"
L["Target:"] = "收件人:"
L["Target is Current Player"] = "收件人是当前玩家"
L["Target Player"] = "收件人"
L["Target Player:"] = "收件人:"
L["The name of the player you want to mail items to."] = "您所希望的收件角色的姓名。"
L["This is maximum amount of gold you want to keep on the current player. Any amount over this limit will be send to the specified character."] = "这是您希望的当前角色金币保有量。多余的金币会被邮寄到指定角色(金库角色)。"
L["This is the maximum number of the specified item to send when you click the button below."] = "这是当您点击下面的按钮时邮寄指定物品的最大邮寄量。"
L["This slider controls how long the mail sending code waits between consecutive mails. If this is set too low, you will run into internal mailbox errors."] = "此滑动条控制着连续发送邮件的间隔时间。若设置数值太低，会出现内部邮箱错误。"
L["This tab allows you to quickly send any quantity of an item to another character. You can also specify a COD to set on the mail (per item)."] = "此标签允许您快速发送任何数量的物品给另一个角色。您也可以通过设置发送收费邮件(单件计费)。"
L["TSM Groups"] = "TSM分组"
L["TSM_Mailing Excess Gold"] = "TSM_Mailing 超额金币"
L["When you shift-click a send mail button, after the initial send, it will check for new items to send at this interval."] = "当你shift+左键点击发送按钮, 初次邮寄后，将在设置的分钟数后检查新物品。"
