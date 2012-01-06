-- Arquivo Principal
-- Caça Palavras

--[[
	Trabalho Elaborado da matéria de Fundamentos de Sistemas Multimídia
	
	Falta fazer: Dos requisitos nenhum.
	
	Melhorar: Criar modos, melhorar a interface gráfica do jogo, ajustar o som do jogo
]]--

-----------------------------------------------------------------------------------------------------------------------------
--																Main
-----------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------
--	Global Constants
--------------------------------------------------
local _G, print, setfenv, type, io, pairs, loadfile = 
      _G, print, setfenv, type, io, pairs, loadfile

local fimDeJogo = false																--Booleana que marca o fim de jogo
local arqEntrada = "entrada.lua"													--Arquivo de Entrada
local largura, altura = canvas:attrSize()											--Largura e altura da Tela
local bkColor = 'white'									--Cor de fundo
local cursorColor = 'teal'								--Cor do cursor
local lineColor = 'maroon'								--Cor da Linha
local font={face='Arial', height=30}					--Fonte
local fontColor='black'									--Cor da Fonte
local dx=0												--Posição inicial em x
local dy=0												--Posição inicial em y
--local tamGrade = 0										--Tamanho da grade de letras (Declarada no arquivo de entrada)
--local numPalavras = 0										--Número de palavras a serem procuradas (Declarada no arquivo de entrada)
--local matrizLetras = {}									--Matriz de Letras (Declarada no arquivo de entrada)
--local palavras = {}										--Lista de Palavras (Declarada no arquivo de entrada)
--local palavraEncontrada = {}							--Verifica se a palavra foi encontrada
local canvas = canvas									--Cavas MTFKA!
local offset = 50										--Offset entre a matriz de letras e a lista de palavras
local cursor = {x=0, y=0}								--CursorOriginal
local pressedCursor = {x=-1, y=-1}						--Cursor fixo pressionado
local hSpace = 50										--Espaçamento horizontal
local vSpace = 30										--Espaçamento Vertical
local linhas = {}										--Linhas em cima de palavras que o usuário de dorgas já achou
local control = 0								--Variável de controle porque por algum motivo ao clicar a seta pro lado uma vez, vai duas, dorgas manolo

--------------------------------------------------
--	Functions
--------------------------------------------------

--------------------------------------------------
--	IO Stuff
--------------------------------------------------

function loadArquivo()
	--PQP! ERA SO ISSO! KCT!
	dofile(arqEntrada)
end 

--------------------------------------------------
--	Canvas Stuff
--------------------------------------------------
function atualizaCanvas()
	limpaCanvas()
	desenhaLinhas()
	desenhaCursores()
	desenharGrade()
	canvas:flush()
end

function desenhaLinhas()
	canvas:attrColor(lineColor)
	
	--Marcar na Grade
	for key, pontos in pairs(linhas) do
		--vertical
		if(pontos.p1y == pontos.p2y) then
			canvas:drawRect('fill', (math.min(pontos.p1x, pontos.p2x) * hSpace), (math.min(pontos.p1y,pontos.p2y) * vSpace)  + (font.height/2), 
							((math.abs(pontos.p1x - pontos.p2x)-2) * font.height) + ((math.abs(pontos.p1x - pontos.p2x)-1) * hSpace) ,(font.height/4))
		--horizontal
		elseif(pontos.p1x == pontos.p2x) then
			canvas:drawRect('fill', (math.min(pontos.p1x, pontos.p2x) * hSpace) + (font.height/4), (math.min(pontos.p1y,pontos.p2y) * vSpace), 
							(font.height/4),((math.abs(pontos.p1y - pontos.p2y)-1) * font.height) + ((math.abs(pontos.p1y - pontos.p2y)-1) * vSpace))
		
		--diagonal
		else
			for i=0, math.floor(font.height/2) do
				canvas:drawLine(((pontos.p1x * hSpace)) + i, ((pontos.p1y * vSpace) + (font.height/2)) + i, 
								((pontos.p2x * hSpace)) + i, ((pontos.p2y * vSpace) + (font.height/2)) + i)
			end
		end
	end
	
	--Marcar as palavras encontradas
	yInicial = ((tamGrade)*vSpace) + offset
	xInicial = 0
	
	for i=0, (numPalavras-1) do
		if(palavraEncontrada[palavras[i]] == true) then
			canvas:drawRect('fill', xInicial, (yInicial + font.height/2), (string.len(palavras[i]) - 2) * font.height, font.height/4)
		end
		xInicial = xInicial + (string.len(palavras[i]) * font.height)
	end
	
end

function desenhaCursores()
	canvas:attrColor(cursorColor)
	canvas:drawRect('fill',(cursor.x * hSpace),(cursor.y * vSpace),font.height,font.height)
	
	
	if (pressedCursor.x ~= -1) then
		canvas:drawRect('fill',(pressedCursor.x * hSpace),(pressedCursor.y * vSpace),font.height,font.height)
	end
end

function limpaCanvas()
	--limpando o canvas
	canvas:attrColor(0, 0, 0, 0)
	canvas:clear()
	GeraBK()
end

function desenharGrade()
	--printando as letras
	
	canvas:attrColor(fontColor)
   	canvas:attrFont(font.face, font.height)
   	tempX = dx
 	tempY = dy
   	for i=0,(tamGrade-1) do
 		for j=0,(tamGrade-1) do
			canvas:drawText(tempX, tempY, matrizLetras[i*tamGrade + j])
			tempX = tempX + hSpace
		end
		tempY = tempY + vSpace
		tempX = dx
	end
	
	
	--printando as palavras
	tempY = tempY + offset
	tempX = dx
	
	for i=0, (numPalavras-1) do
		canvas:drawText(tempX, tempY, palavras[i])
		tempX = tempX + (string.len(palavras[i]) * font.height)
	end
	
	
end


function GeraBK()
	canvas:attrColor(bkColor)
	canvas:drawRect('fill',0,0,largura,altura)
end

--------------------------------------------------
--	Control Stuff
--------------------------------------------------

function pegaPalavra(p1X, p1Y, p2X, p2Y)	
	
	--verfica a integridade caso pegue diagonal
	palavra = ''
	if(p1Y ~= p2Y) and (p1X ~= p2X) and  (math.abs(p1X - p2X) ~= math.abs(p1Y - p2Y)) then
		return palavra
	end

	--Verificando Verticalmente
	if(p1Y == p2Y) then
		for i = math.min(p1X, p2X), math.max(p1X, p2X) do
			palavra = palavra..matrizLetras[(p1Y* tamGrade) + i]
		end
	--Verificando Horizontalmente
	elseif(p1X == p2X) then
		for i = math.min(p1Y, p2Y), math.max(p1Y, p2Y) do
			palavra = palavra..matrizLetras[(i * tamGrade) + p1X]
		end
	--Verificando na Diagonal
	else
		delta = math.abs(p1X - p2X)
		--determinar o tipo da diagonal
		
		novoP1 = {x=0, y=0}
		novoP2 = {x=0 ,y=0}
		if(p1X < p2X) then
			novoP1.x = p1X
			novoP1.y = p1Y
			
			novoP2.x = p2X
			novoP2.y = p2Y
		else
			novoP1.x = p2X
			novoP1.y = p2Y
			
			novoP2.x = p1X
			novoP2.y = p1Y
		end
		
		--diagonal do tipo primária
		if(novoP1.y < novoP2.y) then
			for i = 0, delta do
				palavra = palavra..matrizLetras[((novoP1.y + i) * tamGrade) + (novoP1.x + i)]
			end
		--diagonal do tipo secundária
		else
			for i = 0, delta do
				palavra = palavra..matrizLetras[((novoP1.y - i) * tamGrade) + (novoP1.x + i)]
			end
		end
	end
	
	return palavra
end

local function verificaPalavra(palavra)
	for key, p in pairs(palavras) do
		if (p == palavra) and (palavraEncontrada[p] == false) then
			palavraEncontrada[p] = true
			return true
		end
	end
	return false
end

local function adicionaLinha(ponto1, ponto2)
	table.insert(linhas, {p1x = ponto1.x, p1y = ponto1.y ,p2x = ponto2.x, p2y = ponto2.y})
end

local function acabouJogo()
	for k,v in pairs(palavraEncontrada) do
		if(v == false) then
			return false
		end
	end
	return true
end

--------------------------------------------------
-- Handler
--------------------------------------------------


local function handler (evt)
	--Inicializando
	if evt.class == 'ncl' and evt.type == "presentation" and evt.action == 'start' then
		loadArquivo()
		atualizaCanvas()
	end
	
	--Tratando eventos de teclas
	if (evt.class == 'key') and (evt.type == 'press') and (control == 0)	then
		
		if evt.key == 'BLUE' then
			event.post{class='ncl', type='presentation', action='stop'}
		end
		
		if evt.key == 'CURSOR_UP' then
			
			cursor.y = math.max(0,(cursor.y - 1))
			control = 1
			
		elseif evt.key == 'CURSOR_DOWN' then
			
			cursor.y = math.min((tamGrade - 1),(cursor.y + 1))
			control = 1
			
		elseif evt.key == 'CURSOR_RIGHT' then
			
			cursor.x = math.min((tamGrade - 1),(cursor.x + 1))
			control = 1
			
		elseif evt.key == 'CURSOR_LEFT' then
		
			cursor.x = math.max(0,(cursor.x - 1))
			control = 1
		end
		
		--texto=''
		if evt.key == 'ENTER' and (pressedCursor.x == -1) and (pressedCursor.y == -1) and (fimDeJogo == false) then
			--texto = texto..'Setei!\n'
			pressedCursor.x = cursor.x
			pressedCursor.y = cursor.y
			control = 1
			
		elseif evt.key == 'ENTER' and (pressedCursor.x ~=-1) and (pressedCursor.y ~= -1) then
			tentativa1 = ''
			tentativa1 = pegaPalavra(cursor.x, cursor.y, pressedCursor.x, pressedCursor.y)
			tentativa2 = string.reverse(tentativa1)
			--texto = 'Tentativa 1: '..texto..tentativa1..' Tentativa 2: '..tentativa2
			
			if((verificaPalavra(tentativa1) == true) or verificaPalavra(tentativa2) == true) then
				--texto = texto..' TRUE MTFKA!'
				
				adicionaLinha(cursor, pressedCursor)
				fimDeJogo = acabouJogo()
			end
			
			
			--libera o cursor
			pressedCursor.x = -1
			pressedCursor.y = -1
			control = 1
		end
		
		atualizaCanvas()
		
		--debug
		--[[
		texto = ''
		for indice,opcao in pairs(evt) do
			texto = texto.. indice..':'..opcao..'| '
		end
		canvas:drawText(largura/100,altura*0.1 + 15*#linhas,texto)
		canvas:flush()
		]]--
		--canvas:drawText(0,300,texto)
		--canvas:flush()
		if(fimDeJogo == true) then
			canvas:attrColor('blue')
			canvas:drawText(0,300,'Acabou o Jogo! Tecle Azul para sair')
			canvas:flush()
		end
	
	else
		--Tratamento para a pressão dupla lá
		control = 0
	end
end

event.register(handler)	