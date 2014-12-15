-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_AuctionDB                           --
--           http://www.curse.com/addons/wow/tradeskillmaster_auctiondb           --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- TradeSkillMaster_AuctionDB Locale - zhCN
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_AuctionDB/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_AuctionDB", "zhCN")
if not L then return end

L["A full auction house scan will scan every item on the auction house but is far slower than a GetAll scan. Expect this scan to take several minutes or longer."] = "完整扫描拍卖行内的所有物品，此方式远慢于快速扫描，预计费时几分钟甚至更久。"
L["A GetAll scan is the fastest in-game method for scanning every item on the auction house. However, there are many possible bugs on Blizzard's end with it including the chance for it to disconnect you from the game. Also, it has a 15 minute cooldown."] = "快速扫描时扫描拍卖行中每件物品最快的方式。然而,在服务器端有着可能的BUG会使您掉线,所以每15分钟才能执行一次。"
L["Any items in the AuctionDB database that contain the search phrase in their names will be displayed."] = "任何包含搜索短语的AuctionDB数据库中的物品都将显示。"
L["Are you sure you want to clear your AuctionDB data?"] = "您确定要清除AuctionDB数据吗?"
L["Ascending"] = "升序"
L["AuctionDB - Market Value"] = "AuctionDB - 市场价"
L["AuctionDB - Minimum Buyout"] = "AuctionDB - 最低一口价"
L["Can't run a GetAll scan right now."] = "现在还不能执行快速扫描。"
L["Descending"] = "降序"
L["Display lowest buyout value seen in the last scan in tooltip."] = "在鼠标提示中显示上次扫描的最低一口价。"
L["Display market value in tooltip."] = "在鼠标提示中显示市场价。"
L["Display number of items seen in the last scan in tooltip."] = "在鼠标提示中显示上次扫描的物品总数。"
L["Display total number of items ever seen in tooltip."] = "在鼠标提示中显示物品的历史最高数量。"
L["Done Scanning"] = "完成扫描"
L["Download the FREE TSM desktop application which will automatically update your TSM_AuctionDB prices using Blizzard's online APIs (and does MUCH more). Visit %s for more info and never scan the AH again! This is the best way to update your AuctionDB prices."] = "下载完全免费的 TSM APP (TSM应用程序) 来更新你的 AuctionDB数据库中的物品价格 (利用到暴雪提供的在线APIs)。访问 %s 来获取更多信息。以后将不用在游戏里扫描拍卖行物价了,这将是更新拍卖行物价好最好的方法。(已经不支持国服！)"
L["Enable display of AuctionDB data in tooltip."] = "在鼠标提示中显示AuctionDB数据"
L["GetAll scan did not run successfully due to issues on Blizzard's end. Using the TSM application for your scans is recommended."] = "快速扫描由于服务器端的争议而不能成功的运行,因此强烈推荐使用 TSM APP 进行物价扫描。"
L["Hide poor quality items"] = "隐藏灰色物品"
L["If checked, poor quality items won't be shown in the search results."] = "如果勾选,灰色物品将不会出现在扫描结果中。"
L["If checked, the lowest buyout value seen in the last scan of the item will be displayed."] = "如果勾选,将显示上次扫描的物品最低一口价。"
L["If checked, the market value of the item will be displayed"] = "如果勾选,将显示物品的市场价。"
L["If checked, the number of items seen in the last scan will be displayed."] = "如果勾选,将显示上次扫描的物品总数。"
L["If checked, the total number of items ever seen will be displayed."] = "如果勾选,将显示物品总数的历史最高值。"
L["Imported %s scans worth of new auction data!"] = "%s已经保存最新的扫描数据!"
L["Invalid value entered. You must enter a number between 5 and 500 inclusive."] = "输入错误,您必须输入一个5 - 500之间的数字。"
L["Item Link"] = "物品链接"
L["Item MinLevel"] = "最低物品等级"
L["Items per page"] = "每页显示的物品"
L["Items %s - %s (%s total)"] = "物品 %s - %s (总数 %s) "
L["Item SubType Filter"] = "物品子类型筛选"
L["Item Type Filter"] = "物品类型筛选"
L["It is strongly recommended that you reload your ui (type '/reload') after running a GetAll scan. Otherwise, any other scans (Post/Cancel/Search/etc) will be much slower than normal."] = "强烈推荐您在运行快速扫描后重载界面(输入'/rl')，否则任何其他的扫描（上架/下架/搜索等）都较平时要慢。"
L["Last Scanned"] = "上一次扫描"
L["Last updated from in-game scan %s ago."] = "距离上次游戏内的数据扫描 %s 。"
L["Last updated from the TSM Application %s ago."] = "距离上次游戏外TSM APP的数据扫描 %s 。"
L["Market Value"] = "市场价"
L["Market Value:"] = "市场价:"
L["Market Value x%s:"] = "市场价 x%s:"
L["Min Buyout:"] = "最低一口价:"
L["Min Buyout x%s:"] = "最低一口价 x%s:"
L["Minimum Buyout"] = "最低一口价"
L["Next Page"] = "下一页"
L["No items found"] = "未找到物品"
L["No scans found."] = "扫描无发现。"
L["Not Ready"] = "还未就绪"
L["Not Scanned"] = "未扫描"
L["Num(Yours)"] = "数量(你的)" -- Needs review
L["Options"] = "选项"
L["Previous Page"] = "上一页"
L["Processing data..."] = "处理数据…"
L["Ready"] = "准备完毕"
L["Ready in %s min and %s sec"] = "在%s分%s秒內完成"
L["Refreshes the current search results."] = "刷新当前搜索结果。"
L["Removed %s from AuctionDB."] = "以从AuctionDB中移除%s。"
L["Reset Data"] = "重置数据"
L["Resets AuctionDB's scan data"] = "重置AuctionDB扫描数据"
L["Result Order:"] = "结果顺序:"
L["Run Full Scan"] = "执行完整扫描"
L["Run GetAll Scan"] = "执行快速扫描"
L["Running query..."] = "运行查询…"
L["%s ago"] = "%s之前"
L["Scanning page %s/%s"] = "扫描页面 %s/%s"
L["Scanning the auction house in game is no longer necessary!"] = "在游戏扫描拍卖行不再是必要的了!（国服还是必要的！！！）"
L["Search"] = "搜索"
L["Search Options"] = "搜索选项"
L["Seen Last Scan:"] = "查看上次扫描:"
L["Select how you would like the search results to be sorted. After changing this option, you may need to refresh your search results by hitting the \"Refresh\" button."] = "将搜索结果按你的要求排序.改变该选项后,你可能需要点击\"刷新\"按钮来刷新搜索结果."
L["Select whether to sort search results in ascending or descending order."] = "选择是以升序还是降序排列搜索结果。"
L["Shift-Right-Click to clear all data for this item from AuctionDB."] = "Shift+右键点击 从AuctionDB中清除此物品的所有数据。"
L["Sort items by"] = "排序物品按"
L["This determines how many items are shown per page in results area of the \"Search\" tab of the AuctionDB page in the main TSM window. You may enter a number between 5 and 500 inclusive. If the page lags, you may want to decrease this number."] = "这个数字决定TSM主窗口中AuctionDB页面的\"搜索\"标签的搜索结果区域每页显示多少项目。您可以输入一个5到500之间的数字.如果页面加载缓慢，可以尝试减小这个数字。"
L["Total Seen Count:"] = "结果总数:"
L["Use the search box and category filters above to search the AuctionDB data."] = "使用搜索框和筛选器来搜索AuctionDB数据."
L["You can filter the results by item subtype by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in the item type dropdown and \"Herbs\" in this dropdown."] = "你可以用这个下拉菜单来按物品 子类型 筛选搜索结果。例如,如果你想搜索所有的草药,你需要物品类型下拉菜单中选择\"商品\",并在物品子类型下拉菜单中选择\"草药\"。"
L["You can filter the results by item type by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in this dropdown and \"Herbs\" as the subtype filter."] = "你可以用这个下拉菜单来按物品 类型 筛选搜索结果。例如,如果你想搜索所有的草药,你需要物品类型下拉菜单中选择\"商品\",并在物品子类型下拉菜单中选择\"草药\"。"
L["You can use this page to lookup an item or group of items in the AuctionDB database. Note that this does not perform a live search of the AH."] = "你可以使用这个页面来查看AuctionDB数据库中的物品或者分组。请注意,这并不是在拍卖行的实时搜索。"
 