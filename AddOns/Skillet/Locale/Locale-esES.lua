--[[
 
Skillet: A tradeskill window replacement.
Copyright (c) 2007 Robert Clark <nogudnik@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

]]--

local L = LibStub("AceLocale-3.0"):NewLocale("Skillet", "esES")
if not L then return end

L["About"] = "Acerca de"
L["ABOUTDESC"] = "Imprime información acerca de Skillet"
L["alts"] = "alts"
L["Appearance"] = "Apariencia"
L["APPEARANCEDESC"] = "Opciones que controlan como Skillet es mostrado"
L["bank"] = "banco"
L["Blizzard"] = "Blizzard"
L["buyable"] = "vendible"
L["Buy Reagents"] = "Comprar Reactivos"
L["By Difficulty"] = "Por Dificultad"
L["By Item Level"] = "Por Nivel del Objeto"
L["By Level"] = "Por Nivel"
L["By Name"] = "Por Nombre"
L["By Quality"] = "Por Calidad"
L["By Skill Level"] = "Por Nivel de Habilidad"
L["can be created from reagents in your inventory"] = "puede ser creado con los reactivos de tu inventario"
L["can be created from reagents in your inventory and bank"] = "puede ser creado con los reactivos de tu inventario y banco"
L["can be created from reagents on all characters"] = "puede ser creado con los reactivos de todos tus caracteres"
L["Clear"] = "Limpiar"
L["click here to add a note"] = "Click aquí para añadir una nota"
L["Collapse all groups"] = "Contraer todos los grupos"
L["Config"] = "Configuración"
L["CONFIGDESC"] = "Abre una ventana de configuración para Skillet"
L["Could not find bag space for"] = "No puedo encontrar un espacio en la bolsa para"
L["craftable"] = "Manufacturable"
L["Crafted By"] = "Manufacturado por"
L["Create"] = "Crear"
L["Create All"] = "Crear Todo"
L[" days"] = "días"
L["Delete"] = "Borrar"
L["DISPLAYREQUIREDLEVELDESC"] = "Si el elemento fabricado requiere un nivel mínimo para utilizar, este nivel será mostrado con la receta"
L["DISPLAYREQUIREDLEVELNAME"] = "Mostrar nivel necesario"
L["DISPLAYSGOPPINGLISTATAUCTIONDESC"] = "Mostrar una Lista de la Compra de los elementos que son necesarios para fabricar recetas encoladas pero que no están en tus bolsas"
L["DISPLAYSGOPPINGLISTATAUCTIONNAME"] = "Mostrar Lista de la Compra en la Subasta"
L["DISPLAYSHOPPINGLISTATBANKDESC"] = "Mostrar una Lista de la Compra de los elementos que son necesarios para fabricar recetas encoladas pero que no están en tus bolsas"
L["DISPLAYSHOPPINGLISTATBANKNAME"] = "Mostrar Lista de la Compra en los Bancos"
L["DISPLAYSHOPPINGLISTATGUILDBANKDESC"] = "Muestra una lista de compra de Objetos que son necesarios para manufacturar las recetas encoladaspe ro no estan en bolsas"
L["DISPLAYSHOPPINGLISTATGUILDBANKNAME"] = "Muestra lista de compra en Banco de Hermandad"
L["Draenor Engineering"] = "Draenor Engineering" -- Requires localization
L["Enabled"] = "Habilitado"
L["Enchant"] = "Encantar"
L["ENHANCHEDRECIPEDISPLAYDESC"] = "Cuando activo, nombres de las recetas tendrán uno o más caracteres '+' añadido a su nombre para indicar la dificultad de la receta."
L["ENHANCHEDRECIPEDISPLAYNAME"] = "Mostrar la dificultad de la receta como texto"
L["Expand all groups"] = "Expandir todos los grupos"
L["Features"] = "Características"
L["FEATURESDESC"] = "Comportamiento opcional que puede activarse y desactivarse"
L["Filter"] = "Filtro"
L["Flush All Data"] = "Flush All Data" -- Requires localization
L["FLUSHALLDATADESC"] = "Flush all Skillet data" -- Requires localization
L["Glyph "] = "Glifo "
L["Gold earned"] = "Oro ganado"
L["Grouping"] = "Agrupando"
L["have"] = "Tiene"
L["Hide trivial"] = "Ocultar Triviales"
L["Hide uncraftable"] = "Ocultar Imposibles de Crear"
L["Include alts"] = "Incluir Alts"
L["Include guild"] = "Include guild" -- Requires localization
L["Inventory"] = "Inventario"
L["INVENTORYDESC"] = "Información del Inventario"
L["is now disabled"] = "ahora esta deshabilitado"
L["is now enabled"] = "ahora esta habilitado"
L["Library"] = "Librería"
L["LINKCRAFTABLEREAGENTSDESC"] = "Si puedes crear un reactivo necesario para la receta actual, clickenado el reactivo le llevará a su receta."
L["LINKCRAFTABLEREAGENTSNAME"] = "Hacer reactivos clickeables"
L["Load"] = "Cargar"
L["Merge items"] = "Merge items" -- Requires localization
L["Move Down"] = "Mover abajo"
L["Move to Bottom"] = "Mover al Final"
L["Move to Top"] = "Mover al Inicio"
L["Move Up"] = "Mover arriba"
L["need"] = "necesita"
L["No Data"] = "No Datos"
L["None"] = "Ninguno"
L["No such queue saved"] = "Esta cola no esta guardada"
L["Notes"] = "Notas"
L["not yet cached"] = "aún no en caché"
L["Number of items to queue/create"] = "Número de elementos a encolar/crear"
L["Options"] = "Opciones"
L["Order by item"] = "Order by item" -- Requires localization
L["Pause"] = "Pausar"
L["Process"] = "Procesando"
L["Purchased"] = "Comprado"
L["Queue"] = "Encolar"
L["Queue All"] = "Encolar Todo"
L["QUEUECRAFTABLEREAGENTSDESC"] = "Si puedes crear un reactivo necesario para la receta actual, y no tienes suficientes, entonces estos reactivos serán añadidos a la cola"
L["QUEUECRAFTABLEREAGENTSNAME"] = "Encolar reactivos fabricables"
L["QUEUEGLYPHREAGENTSDESC"] = "Si puede crear un producto necesario para la receta actual, y no tiene suficiente, entonces el producto será añadido a la cola. Esta opción es solo para Gilfos."
L["QUEUEGLYPHREAGENTSNAME"] = "Cola de productos necesarios para Gilfos"
L["Queue is empty"] = "La cola esta vacía"
L["Queue is not empty. Overwrite?"] = "La cola no esta vacía. Sobrescribir?"
L["Queues"] = "Encolado Guardar/ Cargar"
L["Queue with this name already exsists. Overwrite?"] = "La cola con este nombre ya existe. Sobrescribir?"
L["Reagents"] = "Reagents" -- Requires localization
L["reagents in inventory"] = "reactivos en el inventario"
L["Really delete this queue?"] = "Borrar esta cola realmente?"
L["Rescan"] = "Rescanear"
L["Reset"] = "Reset" -- Requires localization
L["RESETDESC"] = "Reset Skillet position" -- Requires localization
L["Retrieve"] = "Recuperar"
L["Save"] = "Guardar"
L["Scale"] = "Escala"
L["SCALEDESC"] = "Escala de la venta de Habilidades de Comercio (predeterminado 1.0)"
L["Scan completed"] = "Escaneo completado"
L["Scanning tradeskill"] = "Escaneando Habilidades de Comercio"
L["Selected Addon"] = "Addon Seleccionado"
L["Select skill difficulty threshold"] = "Selecciona el umbral de nivel de habilidad"
L["Sells for "] = "Se vende por"
L["Shopping Clear"] = "Shopping Clear" -- Requires localization
L["SHOPPINGCLEARDESC"] = "Clear the shopping list" -- Requires localization
L["Shopping List"] = "Lista Compra"
L["SHOPPINGLISTDESC"] = "Mostrar la Lista de la Compra"
L["SHOWBANKALTCOUNTSDESC"] = "Cuando se calcula y se muestra contador de elementos fabricables, incluir elementos de tu banco y de tus otros caracteres."
L["SHOWBANKALTCOUNTSNAME"] = "Incluir contenido del banco y caracter alt"
L["SHOWCRAFTCOUNTSDESC"] = "Mostrar el número de veces que se puede elaborar una receta, no el número total de elementos elaborables"
L["SHOWCRAFTCOUNTSNAME"] = "Mostrar Contador Fabricación"
L["SHOWCRAFTERSTOOLTIPDESC"] = "Muestra el carácter alternativo que puede manufacturar un objeto en la información de las notas de este objeto."
L["SHOWCRAFTERSTOOLTIPNAME"] = "Muestra los artesanos en la información de las notas."
L["SHOWDETAILEDRECIPETOOLTIPDESC"] = "Mostrar un tooltip detallado cuando se cierne sobre recetas en el panel izquierdo"
L["SHOWDETAILEDRECIPETOOLTIPNAME"] = "Mostrar tooltip detallado para recipientes"
L["SHOWFULLTOOLTIPDESC"] = "Muestra toda la información acerca de un objeto para crearlo. Si Ud. lo desactiva solo vera la información de las notas compacta (mantener Ctrl para mostral toda la informacion de las notas)"
L["SHOWFULLTOOLTIPNAME"] = "Usar la información de las notas normal."
L["SHOWITEMNOTESTOOLTIPDESC"] = "Añadir notas proporcionadas para un elemento al tooltip para ese elemento"
L["SHOWITEMNOTESTOOLTIPNAME"] = "Añadir notas usuario especificadas al tooltip"
L["SHOWITEMTOOLTIPDESC"] = "Muestra Notas de información de objetos manufacturables, en vez de la nota de la receta."
L["SHOWITEMTOOLTIPNAME"] = "Muestra Nota de información cuando es posible"
L["Skillet Trade Skills"] = "Skillet - Habilidades de Comercio"
L["Skipping"] = "Saltarse"
L["Sold amount"] = "Cantidad vendida"
L["SORTASC"] = "Ordenar la lista de recetas del mayor (arriba) al menor (abajo)"
L["SORTDESC"] = "Ordenar la lista de recetas del menor (arriba) al mayor (abajo)"
L["Sorting"] = "Sorting"
L["Source:"] = "Procedencia::"
L["STANDBYDESC"] = "Intercambio pausa on/off"
L["STANDBYNAME"] = "Pausa"
L["Start"] = "Iniciar"
L["Supported Addons"] = "Addons Soportados"
L["SUPPORTEDADDONSDESC"] = "Addons soportados que pueden o son usados para rastrear el inventario"
L["This merchant sells reagents you need!"] = "¡Este mercader vende los reactivos que necesitas!"
L["Total Cost:"] = "Coste Total:"
L["Total spent"] = "Total gastado"
L["Trained"] = "Aprendido"
L["TRANSPARAENCYDESC"] = "Transparencia de la ventana principal de las Habilidades de Comercio"
L["Transparency"] = "Transparencia"
L["Unknown"] = "Desconocido"
L["Using Bank for"] = "Using Bank for" -- Requires localization
L["Using Reagent Bank for"] = "Using Reagent Bank for" -- Requires localization
L["VENDORAUTOBUYDESC"] = "Si tiene recetas en cola y habla con un vendedor que vende algo necesario para las recetas, se adquiere automáticamente."
L["VENDORAUTOBUYNAME"] = "Automáticamente comprar los reactivos"
L["VENDORBUYBUTTONDESC"] = "Muestra un botón cuando hable con los vendedores que le permitirá ver los reactivos necesarios para todas las recetas en cola."
L["VENDORBUYBUTTONNAME"] = "Mostrar botón comprar reactivos en proveedores"
L["View Crafters"] = "Ver artesanos" -- Needs review

