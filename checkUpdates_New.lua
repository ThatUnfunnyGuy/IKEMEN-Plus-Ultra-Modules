local loadLuaModule = true
--[[=============================================================================
This Lua Module has been specifically designed for I.K.E.M.E.N. PLUS ULTRA Engine.
		Therefore, it may NOT be compatible with I.K.E.M.E.N. GO Engine.
=================================================================================]]

--[[=============================================================================
Credits to CD2 for making the original script! This is, technically, just "my" version of it.
Also, I might update this later to make it less messy...
=================================================================================]]
--; UPDATES MENU SCREENPACK DEFINITION
--;===========================================================
t_updatesMenu = {
	{text = "CHECK FOR UPDATES", gotomenu = "f_checkUpdates()"},
	--{text = "TEST", 	gotomenu = "f_comingSoon()"},
	{text = "CHANGELOGS", 	gotomenu = "f_viewChangelog()"},
}
for i=1, #t_updatesMenu do
	t_updatesMenu[i]['id'] = textImgNew()
end
--Insert new item to t_mainMenu table loaded by screenpack.lua
table.insert(t_mainMenu, #t_mainMenu, {text = "UPDATES", gotomenu = "f_updatesMenu()", id = textImgNew()})
--;===========================================================
--; CHECK UPDATES ITEM
--;===========================================================

--;===========================================================
--; CHECK UPDATES
--;===========================================================
function f_checkUpdates()
	webOpen("https://github.com/CableDorado2/Ikemen-Plus-Ultra")
	
end

function f_viewChangelog()
	if data.debugMode then f_loadChangelog() end
	if #t_changelogList == 0 then
		changelogInfo = true
		infoScreen = true
		return
	end
	cmdInput()
	local cursorPosX = 1
	local moveTxt = 0
	local changelogMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	local maxItems = 1
	local cursorUpdate = true
	--
	local txtScaleX = 1
	local txtScaleY = 1
	local txtPosX = -50
	local function f_resetYPos() txtPosY = 30 end
	f_resetYPos()
	local txtSpacing = 12
--4:3 Resolution
	if (resolutionHeight / 3 * 4) == resolutionWidth then
		txtPosX = 1
		txtScaleX = 0.75
		txtScaleY = 0.75
--16:10 Resolution
	elseif (resolutionHeight / 10 * 16) == resolutionWidth then
		txtPosX = -25
		txtScaleX = 0.9
		txtScaleY = 0.9
	end
	data.fadeTitle = f_fadeAnim(MainFadeInTime, 'fadein', 'black', sprFade)
	while true do
	--BACK
		if esc() or commandGetState(p1Cmd, 'e') or commandGetState(p2Cmd, 'e') then
			data.fadeTitle = f_fadeAnim(MainFadeInTime, 'fadein', 'black', sprFade)
			sndPlay(sndSys, 100, 2)
			break
	--PREVIOUS PAGE
		elseif commandGetState(p1Cmd, 'l') or commandGetState(p2Cmd, 'l') or ((commandGetState(p1Cmd, 'holdl') or commandGetState(p2Cmd, 'holdl')) and bufl >= 30) then
			sndPlay(sndSys, 100, 0)
			changelogMenu = changelogMenu - 1
			cursorUpdate = true
	--NEXT PAGE
		elseif commandGetState(p1Cmd, 'r') or commandGetState(p2Cmd, 'r') or ((commandGetState(p1Cmd, 'holdr') or commandGetState(p2Cmd, 'holdr')) and bufr >= 30) then
			sndPlay(sndSys, 100, 0)
			changelogMenu = changelogMenu + 1
			cursorUpdate = true
	--MOVE UP TXT
		elseif ((commandGetState(p1Cmd, 'u') or commandGetState(p2Cmd, 'u')) or ((commandGetState(p1Cmd, 'holdu') or commandGetState(p2Cmd, 'holdu')) and bufu >= 5)) and txtPosY < 30 then
			txtPosY = txtPosY + 1
	--MOVE DOWN TXT
		elseif ((commandGetState(p1Cmd, 'd') or commandGetState(p2Cmd, 'd')) or ((commandGetState(p1Cmd, 'holdd') or commandGetState(p2Cmd, 'holdd')) and bufd >= 5)) then
			txtPosY = txtPosY - 1
		end
		if changelogMenu < 1 then
			changelogMenu = #t_changelogList
			if #t_changelogList > maxItems then
				cursorPosX = maxItems
			else
				cursorPosX = #t_changelogList
			end
		elseif changelogMenu > #t_changelogList then
			changelogMenu = 1
			cursorPosX = 1
		elseif ((commandGetState(p1Cmd, 'l') or commandGetState(p2Cmd, 'l')) or ((commandGetState(p1Cmd, 'holdl') or commandGetState(p2Cmd, 'holdl')) and bufl >= 30)) and cursorPosX > 1 then
			cursorPosX = cursorPosX - 1
		elseif ((commandGetState(p1Cmd, 'r') or commandGetState(p2Cmd, 'r')) or ((commandGetState(p1Cmd, 'holdr') or commandGetState(p2Cmd, 'holdr')) and bufr >= 30)) and cursorPosX < maxItems then
			cursorPosX = cursorPosX + 1
		end
		if cursorPosX == maxItems then
			moveTxt = (changelogMenu - maxItems) * 15
		elseif cursorPosX == 1 then
			moveTxt = (changelogMenu - 1) * 15
		end
		if #t_changelogList <= maxItems then
			maxChangelog = #t_changelogList
		elseif changelogMenu - cursorPosX > 0 then
			maxChangelog = changelogMenu + maxItems - cursorPosX
		else
			maxChangelog = maxItems
		end
		if cursorUpdate then
			f_resetYPos()
			--f_readLicense(t_licenseList[changelogMenu].path) --Get Text Data (old method)
			cursorUpdate = false
		end
		animDraw(f_animVelocity(licenseBG, -0.1, -0.1))
	--Draw Changelog Text Content
		for i=1, #t_changelogList[changelogMenu].content do
			textImgSetText(txt_license, t_changelogList[changelogMenu].content[i])
			textImgSetPos(txt_license, txtPosX, txtPosY + txtSpacing * (i - 1))
			textImgSetScale(txt_license, txtScaleX, txtScaleY)
			textImgDraw(txt_license)
		end
		--f_textRender(txt_license, licenseContent, 0, txtPosX, txtPosY, txtSpacing, 0, -1) --Draw Text from license file (old method)
		animPosDraw(licenseTitleBG, -56, 0) --Draw Title BG
		textImgSetText(txt_licenseTitle, t_changelogList[changelogMenu].name.." CHANGELOG")
		textImgDraw(txt_licenseTitle) --Draw Menu Title
		drawLicenseInputHints()
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		if commandGetState(p1Cmd, 'holdu') or commandGetState(p2Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') or commandGetState(p2Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		if commandGetState(p1Cmd, 'holdr') or commandGetState(p2Cmd, 'holdr') then
			bufl = 0
			bufr = bufr + 1
		elseif commandGetState(p1Cmd, 'holdl') or commandGetState(p2Cmd, 'holdl') then
			bufr = 0
			bufl = bufl + 1
		else
			bufr = 0
			bufl = 0
		end
		cmdInput()
		refresh()
	end
end

function f_readChangelog(path)
changelogFile = io.open(path,"r") --Open .txt file refer in path var in reading mode
changelogContent = licenseFile:read("*all") --Read file content line by line
changelogFile:close() --Close .txt file
end

function f_updatesMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local updatesMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	f_infoReset()
	f_sideReset()
	while true do
		if not infoScreen and not sideScreen then
			if esc() or commandGetState(p1Cmd, 'e') or commandGetState(p2Cmd, 'e') then
				sndPlay(sndSys, 100, 2)
				break
			elseif commandGetState(p1Cmd, 'u') or commandGetState(p2Cmd, 'u') or ((commandGetState(p1Cmd, 'holdu') or commandGetState(p2Cmd, 'holdu')) and bufu >= 30) then
				sndPlay(sndSys, 100, 0)
				updatesMenu = updatesMenu - 1
			elseif commandGetState(p1Cmd, 'd') or commandGetState(p2Cmd, 'd') or ((commandGetState(p1Cmd, 'holdd') or commandGetState(p2Cmd, 'holdd')) and bufd >= 30) then
				sndPlay(sndSys, 100, 0)
				updatesMenu = updatesMenu + 1
			end
			if updatesMenu < 1 then
				updatesMenu = #t_updatesMenu
				if #t_updatesMenu > 5 then
					cursorPosY = 5
				else
					cursorPosY = #t_updatesMenu - 1
				end
			elseif updatesMenu > #t_updatesMenu then
				updatesMenu = 1
				cursorPosY = 0
			elseif ((commandGetState(p1Cmd, 'u') or commandGetState(p2Cmd, 'u')) or ((commandGetState(p1Cmd, 'holdu') or commandGetState(p2Cmd, 'holdu')) and bufu >= 30)) and cursorPosY > 0 then
				cursorPosY = cursorPosY - 1
			elseif ((commandGetState(p1Cmd, 'd') or commandGetState(p2Cmd, 'd')) or ((commandGetState(p1Cmd, 'holdd') or commandGetState(p2Cmd, 'holdd')) and bufd >= 30)) and cursorPosY < 5 then
				cursorPosY = cursorPosY + 1
			end
			if cursorPosY == 5 then
				moveTxt = (updatesMenu - 6) * 13
			elseif cursorPosY == 0 then
				moveTxt = (updatesMenu - 1) * 13
			end
			if #t_updatesMenu <= 5 then
				maxupdatesMenu = #t_updatesMenu
			elseif updatesMenu - cursorPosY > 0 then
				maxupdatesMenu = updatesMenu + 5 - cursorPosY
			else
				maxupdatesMenu = 5
			end
			if btnPalNo(p1Cmd, true) > 0 or btnPalNo(p2Cmd, true) > 0 then
				sndPlay(sndSys, 100, 1)
				f_gotoFunction(t_updatesMenu[updatesMenu])
			end
		end
		drawBottomMenuSP()
		for i=1, #t_updatesMenu do
			if i == updatesMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_updatesMenu[i].id, jgFnt, bank, 0, t_updatesMenu[i].text, 159, 122 + i * 13 - moveTxt))
		end
		if not infoScreen and not sideScreen then
			animSetWindow(cursorBox, 0,125 + cursorPosY * 13, 316,13)
			f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
			animDraw(f_animVelocity(cursorBox, -1, -1))
		end
		drawMiddleMenuSP()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, "CHECK UPDATES")
		textImgDraw(txt_version)
		f_sysTime()
		if maxupdatesMenu > 6 then
			animDraw(menuArrowUp)
			animUpdate(menuArrowUp)
		end
		if #t_updatesMenu > 6 and maxupdatesMenu < #t_updatesMenu then
			animDraw(menuArrowDown)
			animUpdate(menuArrowDown)
		end
		if not infoScreen and not sideScreen then drawMainMenuInputHints() end
		if sideScreen then f_sideSelect() end
		if infoScreen then f_infoMenu() end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		if commandGetState(p1Cmd, 'holdu') or commandGetState(p2Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') or commandGetState(p2Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		cmdInput()
		refresh()
	end
end
