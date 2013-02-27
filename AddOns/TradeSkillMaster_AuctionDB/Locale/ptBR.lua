-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_AuctionDB - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/TradeSkillMaster_AuctionDB.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_AuctionDB Locale - ptBR
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_AuctionDB/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_AuctionDB", "ptBR")
if not L then return end

L["A full auction house scan will scan every item on the auction house but is far slower than a GetAll scan. Expect this scan to take several minutes or longer."] = "Um escaneamento completo da casa de leilões irá escanear todos os itens da casa de leilões, porém é bem mais lento que um escaneamento PegaTudo. Espere que este escaneamento demore vários minutos ou mais."
L["A GetAll scan is the fastest in-game method for scanning every item on the auction house. However, it may disconnect you from the game and has a 15 minute cooldown."] = "Um escaneamento PegaTudo é o método mais rápido para escanear todos os itens da casa de leilões. Porém, ele pode te desconectar do jogo e possui uma recarga de 15 minutos."
L["Alchemy"] = "Alquimia"
L["Any items in the AuctionDB database that contain the search phrase in their names will be displayed."] = "Qualquer item no bando de dados do AuctionDB que contém a frase procurada em seus nomes serão exibidos."
L["A profession scan will scan items required/made by a certain profession."] = "Um escaneamento de profissão escaneará itens necessários/criados por uma certa profissão."
L["Are you sure you want to clear your AuctionDB data?"] = "Você tem certeza de que quer limpar os dados do seu AuctionDB?"
L["Ascending"] = "Crescente"
L["AuctionDB - Market Value"] = "AuctionDB - Valor de Mercado"
L["AuctionDB - Minimum Buyout"] = "AuctionDB - Arremate Mínimo"
L["Blacksmithing"] = "Ferraria"
L["|cffff0000WARNING:|r As of 4.0.1 there is a bug with GetAll scans only scanning a maximum of 42554 auctions from the AH which is less than your auction house currently contains. As a result, thousands of items may have been missed. Please use regular scans until blizzard fixes this bug."] = "|cffff0000WARNING:|r Desde o 4.0.1 existe um bug com o BuscarTodos escaneando um máximo de 42554 leilões da CL que é menos o que sua casa de leilão contém atualmente. Como resultado, milhares de itens podem ter sido ignorados. Por favor use escaneamentos normais até a Blizzard arrumar o problema."
L["Cooking"] = "Culinária"
L["Descending"] = "Decrescente"
L["Disenchant source:"] = "Origem de Desencanto" -- Needs review
L["Disenchant Value:"] = "Valor de Desencanto" -- Needs review
L["Display disenchant value in tooltip."] = "Mostrar valor de Desencanto nas Dica de interface" -- Needs review
L["Done Scanning"] = "Escaneamento Completo"
L["Enable display of AuctionDB data in tooltip."] = "Habilita a exibição de dados do AuctionDB nas dicas de interface."
L["Enchanting"] = "Encantamento"
L["Engineering"] = "Engenharia"
L["General Options"] = "Opções Gerais"
L["Hide poor quality items"] = "Esconder itens de qualidade inferior"
L["If checked, poor quality items won't be shown in the search results."] = "Se marcado, itens de qualidade inferior não serão exibidos nos resultados das buscas."
L["If checked, the disenchant value of the item will be shown. This value is calculated using the average market value of materials the item will disenchant into."] = "Se selecionado, o valor de desencanto do item sera mostrado. Este valor é calculado usando o preço médio dos materias em que o item sera desencantado" -- Needs review
L["Inscription"] = "Escrivania"
L["Invalid value entered. You must enter a number between 5 and 500 inclusive."] = "Valor inválido. Você deve digitar um número entre 5 e 500 (inclusive)."
L["Item Link"] = "Link do Item"
L["Item MinLevel"] = "NívelMín do Item"
L["Items per page"] = "Itens por página"
L["Items %s - %s (%s total)"] = "Itens %s - %s (%s no total)"
L["Item SubType Filter"] = "Filtro de SubTipo de Item"
L["Item Type Filter"] = "Filtro de Tipo de Item"
L["It is strongly recommended that you reload your ui (type '/reload') after running a GetAll scan. Otherwise, any other scans (Post/Cancel/Search/etc) will be much slower than normal."] = "É altamente recomendado que você recarregue sua IU (digite '/reload') após rodar um escaneamento PegaTudo. De outra forma, qualquer outro escaneamento (Postagem/Cancelamento/Busca/etc) será muito mais lento que o normal."
L["Jewelcrafting"] = "Joalheria"
L["Last Scanned"] = "Escaneado pela última vez"
L["Last Scanned:"] = "Ultimo Escaneamento" -- Needs review
L["Leatherworking"] = "Couraria"
L["Market Value"] = "Valor de Mercado"
L["Market Value:"] = "Preço de mercado" -- Needs review
L["Min Buyout"] = "Arremate Minimo" -- Needs review
L["Min Buyout:"] = "Arremate minimo" -- Needs review
L["Minimum Buyout"] = "Arremate Mínimo"
L["Never scan the auction house again!"] = "Nunca escaneie a casa de leilões novamente!"
L["Next Page"] = "Próxima Página"
L["No items found"] = "Nenhum item encontrado"
L["Not Ready"] = "Não está pronto"
L["Num(Yours)"] = "Num(Seu)"
L["Options"] = "Opções"
L["Previous Page"] = "Página anterior"
L["Professions:"] = "Profissões:"
L["Ready"] = "Pronto"
L["Ready in %s min and %s sec"] = "Pronto em $s min e %s seg"
L["Refresh"] = "Refrescar"
L["Refreshes the current search results."] = "Refrescar os resultados da busca atual."
L["Removed %s from AuctionDB."] = "%s removido do AuctionDB."
L["Reset Data"] = "Redefinir Dados"
L["Resets AuctionDB's scan data"] = "Redefine os dados de escaneamento do AuctionDB"
L["Result Order:"] = "Order de Resultado" -- Needs review
L["Run Full Scan"] = "Rodar um Escaneamento Completo"
L["Run GetAll Scan"] = "Executar Escaneamento PegarTudo"
L["Run Profession Scan"] = "Rodar um Escaneamento de Profissão"
L["Run Scan"] = "Executar Escaneamento"
L["%s ago"] = "%s atrás"
L["Scan interrupted."] = "Escaneamento interrompido."
L["Scanning..."] = "Escaneando..."
L["Scan the auction house with AuctionDB to update its market value and min buyout data."] = "Escaneia a casa de leilões com o AuctionDB para atualizar seus dados de valores de mercado e arremates mínimos."
L["Search"] = "Buscar"
L["Search Options"] = "Opções de Busca"
L["Seen Last Scan:"] = "Visto no ultimo Escaneamento" -- Needs review
L["Select how you would like the search results to be sorted. After changing this option, you may need to refresh your search results by hitting the \"Refresh\" button."] = "Selecione como você gostaria que os resultados da busca sejam ordenados. Depois de alterar esta opção você deve refrescar os resultados de sua busca clicando no botão \"Refrescar\"."
L["Select professions to include in the profession scan."] = "Selecione profissões a incluir no escaneamento de profissão."
L["Select whether to sort search results in ascending or descending order."] = "Selecione para mostrar os resultados em ordem crescente ou decrescente" -- Needs review
L["Select whether to use market value or min buyout for calculating disenchant value."] = "Selecione se for usar valor de mercado ou arremate minimo para calcular o valor de desencanto" -- Needs review
L["Shift-Right-Click to clear all data for this item from AuctionDB."] = "Shift-Clique-Direito para limpar todos os dados para este item do AuctionDB."
L["Sort items by"] = "Ordenar items por"
L["%s - Scanning page %s/%s of filter %s/%s"] = "%s - Escaneando a página %s/%s do filtro %s/%s"
L["Tailoring"] = "Alfaiataria"
L["The author of TradeSkillMaster has created an application which uses blizzard's online auction house APIs to update your AuctionDB data automatically. Check it out at the link in TSM_AuctionDB's description on curse or at: %s"] = "O autor do TradeSkillMaster criou um aplicativo que utiliza as APIs de casas de leilões da Blizzard para atualizar seus dados do AuctionDB automaticamente. Verifique no link da descrição do TSM_AuctionDB no curse ou em: %s"
L["This determines how many items are shown per page in results area of the \"Search\" tab of the AuctionDB page in the main TSM window. You may enter a number between 5 and 500 inclusive. If the page lags, you may want to decrease this number."] = "Determina quantos itens são mostrados por página na área de resultados da aba \"Busca\" da página do AuctionDB na janela principal do TSM. Você pode digitar um número entre 5 e 500 (inclusive). Se houver demora na página você pode querer diminuir este número."
L["Total Seen Count:"] = "Total de vezes visto" -- Needs review
L["Use the search box and category filters above to search the AuctionDB data."] = "Use a caixa de busca e filtros de categoria acima para procurar nos dados do AuctionDB."
L["Waiting for data..."] = "Aguardando pelos dados..."
L["You can filter the results by item subtype by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in the item type dropdown and \"Herbs\" in this dropdown."] = "Você pode filtrar os resultados por subtipo de item usando esta opção. Por exemplo, se você quer procurar todas as ervas você deve selecionar \"Mercadorias\" no menu de tipo de item e \"Ervas\" neste menu."
L["You can filter the results by item type by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in this dropdown and \"Herbs\" as the subtype filter."] = "Você pode filtrar os resultados por tipo de item usando esta opção. Por exemplo, se você quer procurar todas as ervas você deve selecionar \"Mercadorias\" neste menu e \"Ervas\" no menu de subtipo. "
L["You can use this page to lookup an item or group of items in the AuctionDB database. Note that this does not perform a live search of the AH."] = "Você pode usar esta página para procurar por um item ou grupo de itens no banco de dados do AuctionDB. Observe que isto não executará uma pesquisa ao vivo na CL."
 