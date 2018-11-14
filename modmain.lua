mods = GLOBAL.rawget(GLOBAL, "mods")
if not mods then
	mods = {}
	GLOBAL.rawset(GLOBAL, "mods", mods)
end
mods.RussianLanguagePack = {}
local t = mods.RussianLanguagePack
t.modinfo = modinfo
--����, �� �������� ����� ����������� ������� ������ po ����� � ���� ����������.
--�� ����� ������, ��� ������ ��� ������������� ���� �������� ��� ����� � ����� ���� �� ������ �� �����.
t.StorePath = MODROOT--"scripts/languages/"
t.UpdateLogFileName = "updatelog.txt"
t.MainPOfilename = "russian.po"
t.ROG_POfilename = "ROG.po"
t.SW_POfilename = "SW.po"
t.H_POfilename = "H.po"
t.UpdatePeriod = {"OncePerLaunch","OncePerDay","OncePerWeek","OncePerMonth","Never"}
t.SteamURL = "http://steamcommunity.com/sharedfiles/filedetails/?id=207427039"

io = GLOBAL.io
STRINGS = GLOBAL.STRINGS
tonumber = GLOBAL.tonumber
tostring = GLOBAL.tostring
assert = GLOBAL.assert
rawget = GLOBAL.rawget
require = GLOBAL.require
dumptable = GLOBAL.dumptable
GetPlayer = GLOBAL.GetPlayer






t.ROG_Installed = rawget(GLOBAL,"REIGN_OF_GIANTS") and GLOBAL.IsDLCEnabled and GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS)
t.SW_Installed = rawget(GLOBAL,"CAPY_DLC") and GLOBAL.IsDLCEnabled and GLOBAL.IsDLCEnabled(GLOBAL.CAPY_DLC)
t.H_Installed = rawget(GLOBAL,"H_DLC") and GLOBAL.IsDLCEnabled and GLOBAL.IsDLCEnabled(GLOBAL.H_DLC)



function GLOBAL.escapeR(str) --������� \r �� ����� ������. ����� ��� �����, ����������� � ������.
	if string.sub(str,#str)=="\r" then return string.sub(str,1,#str-1) else return str end
end
local escapeR=GLOBAL.escapeR




local function GetPoFileVersion(file) --���������� ������ po �����
	local f = assert(io.open(file,"r"))
	local ver=nil
	for line in f:lines() do
		ver=string.match(escapeR(line),"#%s+������%s+(.+)%s*$")
		if ver then break end
	end
	f:close()
	if not ver then ver="�� ������" end
	return ver
end

--���� ����� ������ ���� ��� ����������� �� � ����, �� ���������, ���� �� ��� ���, � ���� ���, �� ��������
if t.StorePath and t.StorePath~=MODROOT then
	local function copyfile(source,dest) --�������� ���� �� source � dest. ��� ���� ������ ��������� ��� �����.
		local f = assert(io.open(source,"rb"))
		local content = f:read("*all")
		f:close()
		f = assert(io.open(dest,"w"))
		f:write(content)
		f:close()
	end
	--��������� po ����
	if GLOBAL.kleifileexists(MODROOT..t.MainPOfilename)
	   and (not GLOBAL.kleifileexists(t.StorePath..t.MainPOfilename) or GetPoFileVersion(t.StorePath..t.MainPOfilename)~=modinfo.version) then
		copyfile(MODROOT..t.MainPOfilename,t.StorePath..t.MainPOfilename)
	end

	if t.ROG_Installed or t.SW_Installed then
		-- ��������� ROG po ����
		if GLOBAL.kleifileexists(MODROOT..t.ROG_POfilename)
		   and (not GLOBAL.kleifileexists(t.StorePath..t.ROG_POfilename) or GetPoFileVersion(t.StorePath..t.ROG_POfilename)~=modinfo.version) then
			copyfile(MODROOT..t.ROG_POfilename,t.StorePath..t.ROG_POfilename)
		end
		-- ��������� SW po ����
		if GLOBAL.kleifileexists(MODROOT..t.SW_POfilename)
		   and (not GLOBAL.kleifileexists(t.StorePath..t.SW_POfilename) or GetPoFileVersion(t.StorePath..t.SW_POfilename)~=modinfo.version) then
			copyfile(MODROOT..t.SW_POfilename,t.StorePath..t.SW_POfilename)
		end
		-- ��������� H po ����
		if GLOBAL.kleifileexists(MODROOT..t.H_POfilename)
		   and (not GLOBAL.kleifileexists(t.StorePath..t.H_POfilename) or GetPoFileVersion(t.StorePath..t.H_POfilename)~=modinfo.version) then
			copyfile(MODROOT..t.H_POfilename,t.StorePath..t.H_POfilename)
		end
	end


	--��������� ��� ����
	if GLOBAL.kleifileexists(MODROOT..t.UpdateLogFileName)
	   and not GLOBAL.kleifileexists(t.StorePath..t.UpdateLogFileName) then
		copyfile(MODROOT..t.UpdateLogFileName,t.StorePath..t.UpdateLogFileName)
	end
	--��������� ��������, ���� ����� �� �������� ���� po
	if not GLOBAL.kleifileexists(t.StorePath..t.MainPOfilename) then
		t.StorePath=MODROOT
	end
end



--� ���� ������� ���������� ��������, ����������� � ���������� ������� �������
function ApplyRussianFonts()
	--����� �������, ������� ����� ���������.
	local RusFontsFileNames={"talkingfont__ru.zip",
				 "stint-ucr50__ru.zip",
				 "stint-ucr20__ru.zip",
				 "opensans50__ru.zip",
				 "belisaplumilla50__ru.zip",
				 "belisaplumilla100__ru.zip",
				 "buttonfont__ru.zip"}
	if GLOBAL.rawget(GLOBAL,"TALKINGFONT_WATHGRITHR") then
		table.insert(RusFontsFileNames,"talkingfont_wathgrithr__ru.zip")
	end
	--���� ��������: ������� ��������� ������, ���� ��� ���� ���������

	--���������� � ���������� ���������� ������� ������ ������, ������� ����� ��������,
	--����� �� �������� ��� ������������
	GLOBAL.DEFAULTFONT = "opensans"
	GLOBAL.DIALOGFONT = "opensans"
	GLOBAL.TITLEFONT = "bp100"
	GLOBAL.UIFONT = "bp50"
	GLOBAL.BUTTONFONT="buttonfont"
	GLOBAL.NUMBERFONT = "stint-ucr"
	GLOBAL.TALKINGFONT = "talkingfont"
	if GLOBAL.rawget(GLOBAL,"TALKINGFONT_WATHGRITHR") then
		GLOBAL.TALKINGFONT_WATHGRITHR = "talkingfont_wathgrithr"
	end
	GLOBAL.SMALLNUMBERFONT = "stint-small"
	GLOBAL.BODYTEXTFONT = "stint-ucr"

	--��������� �����, � ������ ��� ����
	for i,FileName in ipairs(RusFontsFileNames) do
		GLOBAL.TheSim:UnloadFont("rusfont"..tostring(i))
	end
	GLOBAL.TheSim:UnloadPrefabs({"rusfonts_"..modname})


	--���� ��������: ��������� ������ �� �����

	--��������� ������ �������
	local RusFontsAssets={}
	for i,FileName in ipairs(RusFontsFileNames) do 
		table.insert(RusFontsAssets,GLOBAL.Asset("FONT",MODROOT.."fonts/"..FileName))
	end

	--������ ������, ������������ ��� � ���������
	local RusFontsPrefab=GLOBAL.Prefab("common/rusfonts_"..modname, nil, RusFontsAssets)
	GLOBAL.RegisterPrefabs(RusFontsPrefab)
	GLOBAL.TheSim:LoadPrefabs({"rusfonts_"..modname})

	--��������� ������ ��������� � ������� �������
	for i,FileName in ipairs(RusFontsFileNames) do
		GLOBAL.TheSim:LoadFont(MODROOT.."fonts/"..FileName, "rusfont"..tostring(i))
	end
	--��������� � ���������� ���������� ������� ���� ������
	GLOBAL.DEFAULTFONT = "rusfont4"
	GLOBAL.DIALOGFONT = "rusfont4"
	GLOBAL.TITLEFONT = "rusfont6"
	GLOBAL.UIFONT = "rusfont5"
	GLOBAL.BUTTONFONT= "rusfont7"
	GLOBAL.NUMBERFONT = "rusfont2"
	GLOBAL.TALKINGFONT = "rusfont1"
	GLOBAL.SMALLNUMBERFONT = "rusfont3"
	GLOBAL.BODYTEXTFONT = "rusfont2"
	if GLOBAL.rawget(GLOBAL,"TALKINGFONT_WATHGRITHR") then
		GLOBAL.TALKINGFONT_WATHGRITHR = "rusfont8"
	end

end


--��������� ������ �� �����, � ���� ��� �� ������������� ������� ������, �� ��������� �������
-- local poversion=GetPoFileVersion(t.StorePath..t.MainPOfilename)
-- if poversion~=modinfo.version then
	-- local OldStart=GLOBAL.Start --�������������� �������, ����� ���������� ������� ����� ����� ������� �����.
	-- function Start() 
		-- OldStart()
		-- ApplyRussianFonts()
		-- local a,b="/","\\"
		-- if GLOBAL.PLATFORM == "NACL" or GLOBAL.PLATFORM == "PS4" or GLOBAL.PLATFORM == "LINUX_STEAM" or GLOBAL.PLATFORM == "OSX_STEAM" then
			-- a,b=b,a
		-- end
		-- local text="������ ����: "..modinfo.version..", ������ PO �����: "..poversion.."\n����: "..string.gsub(GLOBAL.CWD..t.StorePath,a,b)..t.MainPOfilename.."\n������� ������ ��������."
		-- local PopupDialogScreen = require "screens/popupdialog"
	        -- GLOBAL.TheFrontEnd:PushScreen(PopupDialogScreen("�������� ������ PO �����", text,
			-- {{text="�������", cb = function() GLOBAL.TheFrontEnd:PopScreen() end}}))
	-- end
	-- GLOBAL.Start=Start
	-- return
-- end


--������� ��������� ���� language.lua �� ������� ����������� po ����� � ������ ������ �����������
function language_lua_has_rusification(filename)
	if not GLOBAL.kleifileexists(filename) then return false end --��� �����? ��� �������


	local f = assert(io.open(filename,"r")) --������ ���� ���� � �����
	local content =""
	for line in f:lines() do
		content=content..line
	end
	f:close()

	content=string.gsub(content,"\r","")--������� ��� �������� �������, �� ������, ���� ��� �����
	content=string.gsub(content,"%-%-%[%[.-%]%]","")--������� ������������� �����������
	if string.sub(content,#content)~="\n" then content=content.."\n" end --��������� ������� ������ � ����� �����, ���� �����
	local tocomment={}
	for str in string.gmatch(content,"([^\n]*)\n") do --������� ��� ������
		if not str then str="" end
		str=string.gsub(str,"%-%-.*$","")--������� ��� ������������ �����������
		--���������� ������, ������� ����� ���������
		if string.find(str,"LanguageTranslator:LoadPOFile(",1,true) then table.insert(tocomment,str) end --�������� po
		if string.find(str,"russian_fix",1,true) then table.insert(tocomment,str) end --�������� ���� ������ ������ �����������
	end
	if #tocomment==0 then return false end --���� �� ������� �����, ������� ����� ����������������, �� �������

	content={}
	local f=assert(io.open(filename,"r"))
	for line in f:lines() do --����� ��������� ��� ������, ����������� ��������
		for _,str in ipairs(tocomment) do --������� ��� ������, ������� ����� ����������������
			local a,b=string.find(line,str,1,true)
			if a then --���� ���� ���������� ��...
				line=string.sub(line,1,a-1).."--"..str..string.sub(line,b+1)
				break --������������ � ��������� ����
			end
		end
		table.insert(content,line)
	end
	f:close()
	f = assert(io.open(filename,"w")) --��������� ����� language.lua � ������������ ��������
	for _,str in ipairs(content) do
		f:write(str.."\n")
	end
	f:close()
	return true
end
local languageluapath ="scripts/languages/language.lua"

if language_lua_has_rusification(languageluapath) then --���� � language.lua ������������ �����������
	local OldStart=GLOBAL.Start --�������������� �������, ����� ���������� ������� ����� ����� ������� ����� � ���������������
	function Start() 
		OldStart()
		ApplyRussianFonts()
		local a,b="/","\\"
		if GLOBAL.PLATFORM == "NACL" or GLOBAL.PLATFORM == "PS4" or GLOBAL.PLATFORM == "LINUX_STEAM" or GLOBAL.PLATFORM == "OSX_STEAM" then
			a,b=b,a
		end
		local text="� ����� "..string.gsub("data/"..languageluapath,a,b).."\n������� ����������� ������ �����������.\n��� ����������� ���� ��������������."
		local PopupDialogScreen = require "screens/popupdialog"
	        GLOBAL.TheFrontEnd:PushScreen(PopupDialogScreen("���������� ����������� �����������", text,
			{{text="�������", cb = function() GLOBAL.TheFrontEnd:PopScreen() GLOBAL.SimReset() end}}))
	end
	GLOBAL.Start=Start
end

--�������������� ������� �������� �������
local OldClose
function NewClose()
	GLOBAL.SetPause(false)
	GLOBAL.TheInput:EnableDebugToggle(true)
	TheFrontEnd:PopScreen()
	--������������� �������� ��������� ��� (��� Ctrl+L)
	TheFrontEnd:HideConsoleLog()
end

--���������� ������� �������� � ������ ��������� �� �������
AddClassPostConstruct("screens/consolescreen", function(self) --��������� ������� ������ � �������� ��-�� ������ ������ �������� � ���� �������
	local NewConsoleValidChars=[[ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,:;[]<>\@!#$%&()'*+-/=?^_{|}~"�������������������������������������Ũ�������������������������߲�������]]
	self.console_edit:SetCharacterFilter( NewConsoleValidChars )
--��������� ������� ������ � ������� (� ������� ��� �� �������� �� �������?)
	self.console_edit:SetAllowClipboardPaste(true)
--��������� �������
	Close=self["Close"]
	self["Close"]=NewClose
end)



Assets={
	Asset("ATLAS",MODROOT.."images/eyebutton.xml"), --������ � ������
	Asset("ATLAS",MODROOT.."images/gradient.xml"), --�������� �� ������� ������� ������� ���� � ���������� ��������
	Asset("ATLAS",MODROOT.."images/rus_mapgen.xml"), --���������������� ����������� � ���� ������������� ������ ����
	--���������
	Asset("ATLAS",MODROOT.."images/rus_locked.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_wickerbottom.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_waxwell.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_willow.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_wilson.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_woodie.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_wes.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_wolfgang.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_wendy.xml")
	}
	if t.ROG_Installed or t.SW_Installed then
		table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_wathgrithr.xml"))
		table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_webber.xml"))
	end
	if t.SW_Installed then
		table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_walani.xml"))
	end



GLOBAL.getmetatable(GLOBAL.TheSim).__index.UnregisterAllPrefabs = (function()
	local oldUnregisterAllPrefabs = GLOBAL.getmetatable(GLOBAL.TheSim).__index.UnregisterAllPrefabs
	return function(self, ...)
		oldUnregisterAllPrefabs(self, ...)
		ApplyRussianFonts()
	end
end)()

ApplyRussianFonts()

--��������� �������, ������������ ������� ������
local OldRegisterPrefabs=GLOBAL.ModManager.RegisterPrefabs --��������� �������,� ������� ����� ���������� ������ � ��������� ���������� ��������� ���������
local function NewRegisterPrefabs(self)
	OldRegisterPrefabs(self)
	ApplyRussianFonts()
	GLOBAL.TheFrontEnd.consoletext:SetFont(GLOBAL.BODYTEXTFONT) --�����, ����� ����� � ������� �� ������
	GLOBAL.TheFrontEnd.consoletext:SetRegionSize(900, 404) --����-���� �������� �� ���������, ����� �� �������� ����� � ������ ������
end
GLOBAL.ModManager.RegisterPrefabs=NewRegisterPrefabs

--���������� ���������� ������� ������ � ���� �������� ������ ����
AddClassPostConstruct("screens/worldgenscreen", function(self)
	ApplyRussianFonts()
	--��������� ��� ��������� ��������, ������� ������ ������������������
	self.worldgentext:SetFont(GLOBAL.TITLEFONT)
	self.flavourtext:SetFont(GLOBAL.UIFONT)
end)


GLOBAL.RusUpdatePeriod={"OncePerLaunch","OncePerDay","OncePerWeek","OncePerMonth","Never"}

function t.ChaptersListInit()
	local tbl={
	{id="181337", text="���� � ���������",			name="ui",			potype="main"},
	{id="181142", text="������� ���������",			name="speech_maxwell",		potype="main"},
	{id="181335", text="������� ����", 			name="speech_woodie",		potype="main"},
	{id="181143", text="������� �����",			name="speech_wendy",		potype="main"},
	{id="181144", text="������� �����������",		name="speech_wickerbottom",	potype="main"},
	{id="181145", text="������� ������",			name="speech_willow",		potype="main"},
	{id="181333", text="������� �������",			name="speech_wilson",		potype="main"},
	{id="181334", text="������� ����������",		name="speech_wolfgang",		potype="main"},
	{id="181336", text="������� WX-78",			name="speech_wx78",		potype="main"},
	{id="181210", text="�������������� �����",		name="misc",			potype="main"},
	{id="181139", text="�������� ���������",		name="names",			potype="main"},
	{id="181132", text="������� ��������",			name="actions",			potype="main"},
	{id="181155", text="����� ������",			name="animalnames",		potype="main"},
	{id="181156", text="������� ������",			name="animaltalks",		potype="main"},
	{id="181135", text="�������� ����������",		name="character",		potype="main"},
	{id="181136", text="������� ������ ����",		name="lucy",			potype="main"},
	{id="181137", text="�������������� ������� ���������",	name="maxwell_misc",		potype="main"},
	{id="181140", text="�������� ��������",			name="recipies",		potype="main"},
	{id="192218", text="������� ��������� � ������ ������",	name="private",			potype="main"}  
	}
	if t.ROG_Installed or t.SW_Installed or t.H_Installed then
		table.insert(tbl,{id="210434", text="ROG ������� �������",	name="DLC1_speech_webber",	potype="ROG"})
		table.insert(tbl,{id="210433", text="ROG ������� �������",	name="DLC1_speech_wathgrithr",	potype="ROG"})
		table.insert(tbl,{id="225881", text="ROG ������� ���������",	name="DLC1_speech_maxwell",	potype="ROG"})
		table.insert(tbl,{id="225887", text="ROG ������� ����",		name="DLC1_speech_woodie",	potype="ROG"})
		table.insert(tbl,{id="225882", text="ROG ������� �����",	name="DLC1_speech_wendy",	potype="ROG"})
		table.insert(tbl,{id="225883", text="ROG ������� �����������",	name="DLC1_speech_wickerbottom",potype="ROG"})
		table.insert(tbl,{id="225884", text="ROG ������� ������",	name="DLC1_speech_willow",	potype="ROG"})
		table.insert(tbl,{id="225885", text="ROG ������� �������",	name="DLC1_speech_wilson",	potype="ROG"})
		table.insert(tbl,{id="225886", text="ROG ������� ����������",	name="DLC1_speech_wolfgang",	potype="ROG"})
		table.insert(tbl,{id="225888", text="ROG ������� WX-78",	name="DLC1_speech_wx78",	potype="ROG"})
	end                                 
                                               
	return tbl
end
t.ChaptersList = t.ChaptersListInit()





--���������� ���������� ����� ����� ����
local function StringTime(n,s)
	local pl_type=n%10==1 and n%100~=11 and 1 or(n%10>=2 and n%10<=4
       		and(n%100<10 or n%100>=20)and 2 or 3)
	s=s or {"����","���","����"}
	return s[pl_type]
end 

--�������� ������������ ���������� ��������� � ������ �������� �������� str1 � ������������ �������� action
function rebuildname(str1,action,objectname)
	local function repsubstr(str,pos,substr)--�������� ��������� substr � ������ str � ������� pos
		pos=pos-1
		return string.sub(str,1,pos)..substr..string.sub(str,pos+#substr+1,#str)
	end
	if not str1 then
		return nil
	end
	local 	sogl=  {['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,
			['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1}

	local sogl2 = {['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1,['�']=1}
	local sogl3 = {["�"]=1,["�"]=1,["�"]=1,["�"]=1,["�"]=1,["�"]=1}

	local animated = {pigman = true, pigguard = true, bunnyman = true, wildbore = true, wildboreguard = true, mermfisher = true}
	
	local resstr=""
	local delimetr
	local wasnoun=false
	local wordcount=#(str1:gsub("[%s-]","~"):split("~"))
	local counter=0
	local FoundNoun

	for str in string.gmatch(str1.." ","[�-��-���A-Za-z0-9%%'%.]+[%s-]") do
		counter=counter+1
		delimetr=string.sub(str,#str)
		str=string.sub(str,1,#str-1)
		if action=="WALKTO" then --���� � (����? ����?) ���������
			if string.sub(str,#str-1)=="��" and resstr=="" then
				str=repsubstr(str,#str-1,"��")
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str-1,"��")
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str-1,"��")
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str-1,"��")
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str-1,"���")
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str-1,"���")
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str-1,"���")
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str-1,"���")
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str-1,"��")
			elseif string.sub(str,#str-1)=="��" and counter<wordcount then
				str=repsubstr(str,#str-1,"����")
			elseif string.sub(str,#str-1)=="��" and resstr=="" then
				str=repsubstr(str,#str-1,"���")
			elseif string.sub(str,#str-1)=="��" and resstr=="" then
				str=repsubstr(str,#str-1,"���")
			elseif string.sub(str,#str-2)=="���" then
				str=string.sub(str,1,#str-3).."��"
			elseif string.sub(str,#str-1)=="��" then
				str=string.sub(str,1,#str-2).."��"
				wasnoun=true
			elseif string.sub(str,#str-2)=="���" then
				str=string.sub(str,1,#str-3).."��"
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str-1,"��")
				wasnoun=true
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str,"�")
				wasnoun=true
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str,"�")
				wasnoun=true
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str,"�")
				wasnoun=true
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str,"�")
				wasnoun=true
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str,"�")
				wasnoun=true
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str,"�")
				wasnoun=true
			elseif string.sub(str,#str-1)=="��" then
				str=str.."�"
			elseif string.sub(str,#str-1)=="��" and not wasnoun then
				str=repsubstr(str,#str,"��")
				wasnoun=true
			elseif string.sub(str,#str)=="�" and not wasnoun then
				str=repsubstr(str,#str,"��")
				wasnoun=true
			elseif string.sub(str,#str)=="�" and not wasnoun then
				str=repsubstr(str,#str,"��")
				wasnoun=true
			elseif string.sub(str,#str)=="�" and not wasnoun then
				str=repsubstr(str,#str,"�")
				wasnoun=true
			elseif string.sub(str,#str)=="�" and not wasnoun then
				str=repsubstr(str,#str,"�")
				wasnoun=true
			elseif string.sub(str,#str)=="�" and not wasnoun then
				str=repsubstr(str,#str,"�")
				wasnoun=true
			elseif string.sub(str,#str-1)=="��" and not wasnoun then
				str=repsubstr(str,#str-1,"��")
				wasnoun=true
			elseif string.sub(str,#str)=="�" and not wasnoun then
				str=repsubstr(str,#str,"�")
				wasnoun=true
			elseif sogl[string.sub(str,#str)] and not wasnoun then
				str=str.."�"
				wasnoun=true
			end
		--������� (����? ���?) �����������
		--������������� � ����� ������, ������ ��� �������
		elseif action and objectname and animated[objectname] then 
			if string.sub(str,#str-2)=="���" then
				str=string.sub(str,1,#str-2).."��"
			elseif string.sub(str,#str-2)=="���" then
				str=string.sub(str,1,#str-2).."���"
			elseif string.sub(str,#str-2)=="���" then
				str=string.sub(str,1,#str-2).."���"
			elseif string.sub(str,#str-1)=="��" then
				str=string.sub(str,1,#str-2).."��"
			elseif string.sub(str,#str)=="�" then
				str=string.sub(str,1,#str-1).."�"
			elseif string.sub(str,#str)=="�" then
				str=string.sub(str,1,#str-1).."�"
			elseif string.sub(str,#str)=="�" then
				str=string.sub(str,1,#str-1).."�"
			elseif string.sub(str,#str)=="�" then
				str=string.sub(str,1,#str-1).."�"
			elseif sogl[string.sub(str,#str)] then
				str=str.."�"
			end
		elseif action then --������� (����? ���?) �����������
			if string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str-1,"��")
			elseif string.sub(str,#str-1)=="��" then
				str=repsubstr(str,#str-1,"��")
			elseif string.sub(str,#str)=="�" then
				str=repsubstr(str,#str,"�")
			elseif string.sub(str,#str)=="�" then
				str=repsubstr(str,#str,"�")
			end
		end
		resstr=resstr..str..delimetr
	end
	resstr=string.sub(resstr,1,#resstr-1)
	return resstr
end


GLOBAL.testname=function(name, key)
	if name and (not key) and type(name)=="string" and GLOBAL.rawget(STRINGS.NAMES,name:upper()) then key=name:upper() name=STRINGS.NAMES[key] end
	local output = "���� � "..rebuildname(name,"WALKTO", key).."\n"
	output = output .. "��������� "..rebuildname(name,"DEFAULTACTION", key)
	print("\n"..output.."\n")
	return output
end

function t.testnames(fileorlist, outputfilename)
	local res
	if not fileorlist then return end
	if type(fileorlist)=="string" then
		local f = assert(io.open(MODROOT..fileorlist, "r"))
		fileorlist = {}
		for line in f:lines() do
			if line~="" then table.insert(fileorlist, line) end
		end
		f:close()
	end
	outputfilename = outputfilename or "testnames.txt"
	local f = assert(io.open(MODROOT..outputfilename, "w"))
	for _, key in ipairs(fileorlist) do
		key = STRINGS.NAMES[key] and key or key:upper()
		f:write(key.."\t")
		if STRINGS.NAMES[key] then
			f:write(STRINGS.NAMES[key].."\t")
			local foundgender = false
			for gender, list in pairs(t.NamesGender) do
				if list[key] or list[key:lower()] then
					if gender=="he" then f:write("�������")
					elseif gender=="he2" then f:write("������� ������˨����")
					elseif gender=="she" then f:write("�������")
					elseif gender=="it" then f:write("�������")
					elseif gender=="plural" then f:write("������������� �����")
					elseif gender=="plural2" then f:write("������������� �����, ������˨����") end
					foundgender = true
					f:write("\n")
					break
				end
			end
			if not foundgender then f:write("������� (�� ���������)\n") end
			f:write(GLOBAL.testname(STRINGS.NAMES[key], key).."\n\n")
		else
			f:write("������. �� ������ ����\n\n")
		end
	end
	f:close()
end

function parsefixed(file, fillall)
	local f = assert(io.open(MODROOT..file, "r"))
	local lines = {}
	for line in f:lines() do
		table.insert(lines,line)
	end
	f:close()
	local i = 1
	local txt1, txt2 = "", ""
	local function buildline(starter, new, old, key)
		local res = starter..new
		local len = #res
		while len<48 do
			res = res.. "\t"
			len = len+(4-len%4)
		end
		res = res..old
		len = len+#old
		while len<88 do
			res = res.. "\t"
			len = len+(4-len%4)
		end
		res = res..key
		return res
	end
	while i<#lines do
		local key, val = lines[i]:match("^(.-)\t(.-)\t")
		local tofixwalkto, walkto = lines[i+1]:match("(.?)���� � (.*)")
		local tofixinspect, inspect = lines[i+2]:match("(.?)��������� (.*)")
		if key and val then
			if (tofixwalkto=="-" or fillall) and walkto then txt1 = txt1..buildline("#���� � ", walkto, val, key).."\n" end
			if (tofixinspect=="-" or fillall) and inspect then txt2 = txt2..buildline("#������� ", inspect, val, key).."\n" end
		end
		i = i+4
	end
	f = assert(io.open(MODROOT.."toadd.txt", "w"))
	f:write("WALKTO\n"..txt1.."\n\n\n")
	f:write("INSPECT\n"..txt2)
	f:close()
end
--parsefixed("testnames.txt", false)




--��������� � ����� fn ��� ����� � ���������, ��������� � ��������� action)
local function printnames(fn,action,openfn)
	local filename = MODROOT..fn..".txt"
	local str1,str2
	local names={}
	local f=assert(io.open(MODROOT..(openfn or "names_new.txt"),"r"))
	for line in f:lines() do
		str1=string.match(line,"[.\t]([^.\t]*)$")
		str2=STRINGS.NAMES[str1]
		if not (t.RussianNames[str2] and t.RussianNames[str2]["KILL"]) then
			local s1
			if action=="DEFAULTACTION" then
				s1="������� "
			elseif action=="WALKTO" then
				s1="���� � "
			elseif action=="KILL" then
				s1="�� ��� ���� "
			end
			s1=s1..rebuildname(str2,action,str1:lower())
			local name=s1
			local len=#s1
			while len<48 do
				name=name.."\t"
				len=len+8
			end
			s1=str2
			name=name..s1
			len=#s1
			while len<48 do
				name=name.."\t"
				len=len+8
			end
			name=name..str1.."\n"
			table.insert(names,name)
		end
	end
	f:close()
	local file = io.open(filename, "w")
	for i,v in ipairs(names) do
		file:write(v)
	end
	file:close()
end



t.RussianNames = {} --������� � ������� ������� �������� ��������� � ��������� �������
t.ActionsToSave = {} --������� ��������� ��-�� �����, �� �������� �������� � ����� ��� ���������� po
t.ShouldBeCapped = {} --�������, � ������� ��������� ������ ��������, ������ ����� ������� ������� � ������� ����� ��� ���������.

--��������� ������ ���, ������� ������ ���������� � ��������� �����. ������ ������ �������� �� �������� ��������.
function t.LoadCappedNames(data)
	t.ShouldBeCapped={}
	local filename = t.StorePath..t.MainPOfilename
	if (data and #data==0) or not GLOBAL.kleifileexists(filename) then return nil end
	local insection=false
	local function parseline(line)
		line=escapeR(line)
		if string.sub(line,1,10)=="# --------" then
			insection=string.find(line,"������ ���������� � ��������� �����",1,true)
		elseif insection and string.sub(line,1,1)=="#" then
			t.ShouldBeCapped[string.sub(line,2):lower()]=true
		end
	end
	if data then
		for _,line in ipairs(data) do
			parseline(line)
		end
	else
		local f=assert(io.open(filename,"r"))
		for line in f:lines() do
			parseline(line)
		end
		f:close()
	end
	
	end
	



t.NamesGender={} --������� � �������� ���, ���������������� �� �����.
t.NamesGender["he"]={}
t.NamesGender["he2"]={}
t.NamesGender["she"]={}
t.NamesGender["it"]={}
t.NamesGender["plural"]={}
t.NamesGender["plural2"]={}
--��������� ������ ���, � ������ ������� ����. ������ ������ �������� �� �������� ��������.
--������������ ��� ����������� ��������� ��������� ��������.
function t.LoadNamesGender(data)
	t.NamesGender={} 
	t.NamesGender["he"]={}
	t.NamesGender["he2"]={}
	t.NamesGender["she"]={}
	t.NamesGender["it"]={}
	t.NamesGender["plural"]={}
	t.NamesGender["plural2"]={}
	local filename = t.StorePath..t.MainPOfilename
	if (data and #data==0) or not GLOBAL.kleifileexists(filename) then return nil end
	local insection=false
	local part=nil
	local function parseline(line)
		line=escapeR(line)
		if string.sub(line,1,10)=="# --------" then
			insection=string.find(line,"��� � ����� ���������",1,true)
		elseif insection and string.sub(line,1,1)=="#" then
			if line=="# �������:" then part="he" 
			elseif line=="# ������� 2 �����:" then part="he2" --����������� � ������������ ����� �������� ����
			elseif line=="# �������:" then part="she" 
			elseif line=="# �������:" then part="it" 
			elseif line=="# ������������� �����:" then part="plural"
			elseif line=="# ������������� ����� 2 �����:" then part="plural2" --����������� �� ������������� ����� (����� ������ ���)
			elseif part~=nil then
				t.NamesGender[part][string.sub(line,2):lower()]=true
			end
			
		end
	end
	if data then
		for _,line in ipairs(data) do
			parseline(line)
		end
	else
		local f=assert(io.open(filename,"r"))
		for line in f:lines() do
			parseline(line)
		end
		f:close()
	end
end





--��������� ������������ �������� ��������� � ������ ������ �� po �����. ���� ������� data, �� �������� ���
function t.LoadFixedNames(BuildErrorLog, data)
	t.RussianNames={}
	t.ActionsToSave={}

	local filename = t.StorePath..t.MainPOfilename

	if (data and #data==0) or not GLOBAL.kleifileexists(filename) then return nil end

	local action=nil
	local predcessorword=""
	local f,errorlog=nil,{}
	if BuildErrorLog then f=assert(io.open(MODROOT.."FixedNamesErrors.txt","w")) end

	local function parseline(line)
		line=escapeR(line)
		if string.sub(line,1,10)=="# --------" then --�������� ���������� ������� � ����� �� ��������
			action=string.match(line,"��������%s+(.*)%s*$") --�������� ��������� �������� ��������
			if action then
				action=action:upper()
				if action=="DEFAULTACTION" then
					predcessorword="�������"
				elseif action=="WALKTO" then
					predcessorword="���� �"
				elseif action=="KILL" then
					predcessorword="�� ��� ����"
				else --��� ������ ��������
					predcessorword=GLOBAL.LanguageTranslator.languages["ru"]["STRINGS.ACTIONS."..action] or ""
				end
				t.ActionsToSave[action]={} --������ ������� � ������� ���� ��������.
			end
		elseif action and line~="" and string.sub(line,1,1+#predcessorword)=="#"..predcessorword then
			local translation=string.match(line,predcessorword.." (.-)\t") 
			local original=string.match(line,"\t([^\t]+)\t") 
			local path=string.match(line,"\t([^\t]-)$")
			if BuildErrorLog and path~="OTHER" then
				if not STRINGS.NAMES[path] and not errorlog[path] then
					f:write("�� ������ ������� "..tostring(path).."\n")
					errorlog[path]=true
				elseif GLOBAL.LanguageTranslator.languages["ru"]["STRINGS.NAMES."..path]~=original and not errorlog[path] then
					f:write("�� notabenoid ���������� �������� �������� "..tostring(original).." ("..tostring(path)..")".." �� "..GLOBAL.LanguageTranslator.languages["ru"]["STRINGS.NAMES."..path].."\n")
					errorlog[path]=true
				end
			end
			table.insert(t.ActionsToSave[action],{pth=path,trans=translation,orig=original})
			if t.RussianNames[original] then
				t.RussianNames[original][action]=translation
			else
				t.RussianNames[original]={}
				t.RussianNames[original]["DEFAULT"]=STRINGS.NAMES[path] --��������� ������������ ��� �� ��
				t.RussianNames[original].path=path --��������� ����
				if action~="DEFAULTACTION" then
					t.RussianNames[original]["DEFAULTACTION"]=rebuildname(original,"DEFAULTACTION")
				end
				if action~="WALKTO" then
					t.RussianNames[original]["WALKTO"]=rebuildname(original,"WALKTO")
				end
				t.RussianNames[original][action]=translation
			end
		end
	end
	if data then
		for _,line in ipairs(data) do
			parseline(line)
		end
	else
		local f=assert(io.open(filename,"r"))
		for line in f:lines() do
			parseline(line)
		end
		f:close()
	end
	if BuildErrorLog then f:close() end
end



--������ ����� �������� ������ ����
local UPDATENAME=GLOBAL.STRINGS.UI.MAINSCREEN.UPDATENAME

--��������� �����������
LoadPOFile(t.StorePath..t.MainPOfilename, "ru")

--��������������� �������� ������ ���� �� ������
GLOBAL.LanguageTranslator.languages["ru"]["STRINGS.UI.MAINSCREEN.UPDATENAME"]=UPDATENAME


--���������� ������� ���������� ��� ROG � SW
function ApplyROG_SWRussification()
	if t.ROG_Installed or t.SW_Installed then
		--������ ����� ����� ��������
		local rustemp={}
		for i,v in pairs(GLOBAL.LanguageTranslator.languages["ru"]) do
			rustemp[i]=v
		end
		--��������� PO ��� ROG
		LoadPOFile(t.StorePath..t.ROG_POfilename, "ru")
		--���������� ������ ��������
		for i,v in pairs(rustemp) do
			if not GLOBAL.LanguageTranslator.languages["ru"][i] then
				GLOBAL.LanguageTranslator.languages["ru"][i]=v
			end
		end
		rustemp=nil

		if t.SW_Installed then
			--����� ������ ����� ����� ��������
			local rustemp={}
			for i,v in pairs(GLOBAL.LanguageTranslator.languages["ru"]) do
				rustemp[i]=v
			end
			--��������� PO ��� SW
			LoadPOFile(t.StorePath..t.SW_POfilename, "ru")
			--���������� ������ ��������
			for i,v in pairs(rustemp) do
				if not GLOBAL.LanguageTranslator.languages["ru"][i] then
					GLOBAL.LanguageTranslator.languages["ru"][i]=v
				end
			end
			rustemp=nil
		end
		
		if t.H_Installed then
			--����� ������ ����� ����� ��������
			local rustemp={}
			for i,v in pairs(GLOBAL.LanguageTranslator.languages["ru"]) do
				rustemp[i]=v
			end
			--��������� PO ��� SW
			LoadPOFile(t.StorePath..t.H_POfilename, "ru")
			--���������� ������ ��������
			for i,v in pairs(rustemp) do
				if not GLOBAL.LanguageTranslator.languages["ru"][i] then
					GLOBAL.LanguageTranslator.languages["ru"][i]=v
				end
			end
			rustemp=nil
		end
	end
end
ApplyROG_SWRussification()



--����� ������ �� ����� �� �������-�����������. ���������� � ������ ���������:
--split("|a|","|") ����� ������� �� "", "�" � ""
--split("�","|") ����� ������� �� "�"
--split("","|") ����� ������� �� ""
--split("|","|") ����� ������� �� "" � ""
--�� ���� ������������ ����� ������� ����� ��������� �������� (�� �������������)
local function split(str,sep)
       	local fields, first = {}, 1
	str=str..sep
	for i=1,#str do
		if string.sub(str,i,i+#sep-1)==sep then
			fields[#fields+1]=(i<=first) and "" or string.sub(str,first,i-1)
			first=i+#sep
		end
	end
        return fields
end


local LetterCasesHash={u2l={["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",
							["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",
							["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",
							["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�"},
					   l2u={["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",
							["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",
							["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",
							["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�"}}
--������ ������ � ������ �������
local function firsttolower(tmp)
	if not tmp then return end
	local firstletter=string.sub(tmp,1,1)
	firstletter = LetterCasesHash.u2l[firstletter] or firstletter
	return firstletter:lower()..string.sub(tmp,2)
end

--������ ������ � ������� �������
local function firsttoupper(tmp)
	if not tmp then return end
	local firstletter=string.sub(tmp,1,1)
	firstletter = LetterCasesHash.l2u[firstletter] or firstletter
	return firstletter:upper()..string.sub(tmp,2)
end

function isupper(letter)
	if not letter or type(letter)~="string" then return end
	return LetterCasesHash.u2l[letter] or (#letter==1 and letter>="A" and letter<="Z")
end

function islower(letter)
	if not letter or type(letter)~="string" then return end
	return LetterCasesHash.l2u[letter] or (#letter==1 and letter>="a" and letter<="z")
end

local function russianupper(tmp)
	if not tmp then return end
	local res=""
	local letter
	for i=1,string.len(tmp) do
		letter = string.sub(tmp,i,i)
		letter = LetterCasesHash.l2u[letter] or letter
		res = res..letter:upper()
	end
	return res
end

local function russianlower(tmp)
	if not tmp then return end
	local res=""
	local letter
	for i=1,string.len(tmp) do
		letter = string.sub(tmp,i,i)
		letter = LetterCasesHash.u2l[letter] or letter
		res = res..letter:lower()
	end
	return res
end


--��������� ������� ������ �����, �������� ����������.
--���������� ����� ���� ���������� ��� ���������.
GLOBAL.CharacterInherentTags={}
for char in pairs(GLOBAL.GetActiveCharacterList()) do
	GLOBAL.CharacterInherentTags[char]={}
end


--!!!��������, ������������ ������ �������� ���
if not table.contains(GLOBAL.CHARACTER_GENDERS.FEMALE, "walani") then table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "walani") end

--������� ���� � ������� ����-����, ����������� � [] � �������� ������, ��������������� ��������� char
--�������� � ������ ��������� ��� ������� ���� ����������� � [] � ����������� �������� |.
--� ����� ������ ����������� ���: [�������|�������|���|������������� �����|��� ������� ���������=��� �������]
--��� ���� ������ ������� ��� �������� ����� ������� ���������� ���� �������������� � ����� ������������������:
--������ � ������� �������, ������ � �������, ������ � ������� ���, �������� � ��. �����.
--��� ������� ����� ��������� � ����� �� ��������� (�������� ������). ����� ��� �� ������ � ������ ��� �������
--������ (��� �������� ����� �������) ���������: [wes=�� ������|��� �������|wolfgang=�����|��� �������|��� ���]
--���� � ��������� �� ������ ������ ��� char, �� ������ ������� �������� ���� (����� webber'�, �������� ������
--���������� ���������� ������� �������������� �����, � Wx-78, ������� �� ������� ��������� ������� �����),
--���� ��� � �����, �� ������ �� �����������.
--�������� ����� ����� �������� ����, �������� �������� ����� "he", "she", "it" ��� "plural"/"they"/"pl".
--�������� � ���������� ��������� (� ��������� �������) ����� ���������� � ������ ����� �������:
--[he=�������|willow,wendy=������� ��� ������������]
--������: "�����[plural=��], [��������|�������|��������|��������|wickerbottom=�������], ������ ���[��|��|��|��] ������[��|��|��|��]?"
--�������������� �������� talker �������� �������� ������� ����������. ������ ����� ��� ���������� ��������� �������� � ��������
function t.ParseTranslationTags(message, char, talker, optionaltags)
	if not (message and string.find(message,"[",1,true)) then return message end

	local gender="neutral"
	local function parse(str)
		local vars=split(str,"|")
		local tags={}
		local function SelectByCustomTags(CustomTags)
			if not CustomTags then return false end
			if type(CustomTags)=="string" then return tags[CustomTags] end
			for _,tag in ipairs(CustomTags) do
				if tags[tag] then return tags[tag] end
			end
			return false
		end
		local counter=0
		for i,v in pairs(vars) do
			local vars2=split(v,"=")
			if #vars2==1 then counter=counter+1 end
			local path=(#vars2==2) and vars2[1] or 
			        (((counter==1) and "he")
				or ((counter==2) and "she")
				or ((counter==3) and "it")
				or ((counter==4) and "plural")
				or ((counter==5) and "neutral")
				or ((counter>5) and nil))
			if path then
				local vars3=split(path,",")
				for _,vv in ipairs(vars3) do
					local c=vv and vv:match("^%s*(.*%S)")
					c=c and c:lower()
					if c=="they" or c=="pl" then c="plural"
					elseif c=="nog" or c=="nogender" then c="neutral"
					elseif c=="def" then c="default" end
					if c then tags[c]=(#vars2==2) and vars2[2] or v end
				end
			end
		end
		str=tags and (tags[char] --������� ���� �� �����
			or SelectByCustomTags(GLOBAL.CharacterInherentTags[char]) --����� �� ������ ����� ���������
			or tags[gender] --����� �������� ������� �� ���� ���������
			or SelectByCustomTags(optionaltags) --����� ����, ���� �� � ��������� �������������� ����
			or tags["default"] --��� ���� ��������� ���
			or tags["neutral"] --���� ������ �� �����, �������� ������� ����������� �������
			or tags["he"] --���� � ��� ���, �� ������� ��� (��� ��� �����������, �� �����, ��� ������)
			or "") or "" --�����, ������, ������ ������
		return str
	end
	local function search(part)
		part=string.sub(part,2,-2)
		if not string.find(part,"[",1,true) then
			part=parse(part)
		else
			part=parse(part:gsub("%b[]",search))
		end
		return part
	end

	--���������� ��� ��������� �����
	local CaseAdoptationNeeded
	message, CaseAdoptationNeeded = message:gsub("%[adoptcase]","<adoptcase>")
	--���� ����-�������, ������� ����� �������� � ������ optionaltags
	message=message:gsub("%[marker=(.-)]",function(marker)
		if not optionaltags then optionaltags={}
		elseif type(optionaltags)=="string" then optionaltags={optionaltags} end
		table.insert(optionaltags,marker)
		return ""
	end)

	if char then
		char=char:lower()
		if char=="generic" then char="wilson" end

		if GLOBAL.rawget(GLOBAL,"CHARACTER_GENDERS") then
			if GLOBAL.CHARACTER_GENDERS.MALE and table.contains(GLOBAL.CHARACTER_GENDERS.MALE, char) then gender="he"
			elseif GLOBAL.CHARACTER_GENDERS.FEMALE and table.contains(GLOBAL.CHARACTER_GENDERS.FEMALE, char) then gender="she"
			elseif GLOBAL.CHARACTER_GENDERS.ROBOT and table.contains(GLOBAL.CHARACTER_GENDERS.ROBOT, char) then gender="he"
			elseif GLOBAL.CHARACTER_GENDERS.IT and table.contains(GLOBAL.CHARACTER_GENDERS.IT, char) then gender="it"
			elseif GLOBAL.CHARACTER_GENDERS.NEUTRAL and table.contains(GLOBAL.CHARACTER_GENDERS.IT, char) then gender="neutral"
			elseif GLOBAL.CHARACTER_GENDERS.PLURAL and table.contains(GLOBAL.CHARACTER_GENDERS.PLURAL, char) then gender="plural" end
		end
		--���� ��� ������ � �� ������� ��� � ����, �� ��� ������������� �����
		if char=="webber" and (not talker or talker:lower()==char) then gender="plural" end
	end
	message=search("["..message.."]") or message
	if CaseAdoptationNeeded then
		message=message:gsub("([^.!? ]?)(%s*)<adoptcase>(.)",function(before, space, symbol)
			if not before or before=="" then symbol=firsttoupper(symbol) else symbol=firsttolower(symbol) end
			return((before or "")..(space or "")..(symbol or ""))
		end)
	end
	return message
end


--������� �������� ' � " �� ��
function FixQuotes(str)
	if not str then return end
	local opened=false
	str={string.byte(str,1,#str)}
	local endsymbols={	[string.byte(".")]=1,
				[string.byte(",")]=1,
				[string.byte("!")]=1,
				[string.byte("?")]=1,
				[string.byte("-")]=1,
				[string.byte(" ")]=1}
	for i,s in ipairs(str) do
		if s==string.byte("\"") then
			if not opened then
				str[i]=string.byte("�")
			else
				str[i]=string.byte("�")
			end
			opened=not opened                      
		end                             
		if s==string.byte("'") then
			if i==1 or (str[i-1] and (str[i-1]==string.byte(" ") or str[i-1]==string.byte(":"))) then
				opened=true
				str[i]=string.byte("�")
			elseif opened and i==#str or (str[i+1] and endsymbols[str[i+1]]) then
				opened=false
				str[i]=string.byte("�")
			end
		end
	end
	return(string.char(GLOBAL.unpack(str)))
end




for i,v in pairs(GLOBAL.LanguageTranslator.languages["ru"]) do
	GLOBAL.LanguageTranslator.languages["ru"][i]=FixQuotes(GLOBAL.LanguageTranslator.languages["ru"][i])
end

--[[	local f=io.open(MODROOT.."test.txt","w")
for i,v in pairs(GLOBAL.LanguageTranslator.languages["ru"]) do
	if string.sub(i,1,15)=="STRINGS.MAXWELL" then
		local a,b,c,d
		a=t.ParseTranslationTags(v, "wilson")
		b=t.ParseTranslationTags(v, "wickerbottom")
		c=t.ParseTranslationTags(v, "it")
		d=t.ParseTranslationTags(v, "plural")
		if v~=a or v~=b or v~=c or v~=d then
			f:write(v.."\n")
			f:write("He:   "..a.."\n")
			f:write("She:  "..b.."\n")
			f:write("It:   "..c.."\n")
			f:write("They: "..d.."\n\n")
		end
	end
end
f:close()]]

--������������ ��� ������������ �������, �������� �� ��� ����
AddClassPostConstruct("components/talker", function(self)
	if self.Say then
		self.OldSay=self.Say
		function self:Say(script, ...)
			local player=GetPlayer()
			player=player and player.prefab
			if type(script) == "string" then 
				script=(t.ParseTranslationTags(script, player, self.inst and self.inst.prefab)) or script
			else for i,v in pairs(script) do if v.message and type(v.message)=="string" then
				v.message=(t.ParseTranslationTags(v.message, player, self.inst and self.inst.prefab)) or v.message
			end end end
			self:OldSay(script, ...)
		end
	end
end)

--��������� ������������� �������� ��������
local mappresets={text={},desc={}}
for i,v in pairs(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS) do table.insert(mappresets.text,v) end
for i,v in pairs(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC) do table.insert(mappresets.desc,v) end

--��������� ������� ������ �����, ������� ����������� ������� ����������� �� Notabenoid
for i,v in pairs(GLOBAL.LanguageTranslator.languages["ru"]) do
	if v=="<�����>" then GLOBAL.LanguageTranslator.languages["ru"][i]="" end
end










--���������� ������� � STRINGS
GLOBAL.TranslateStringTable(GLOBAL.STRINGS)

t.LoadCappedNames() --��������� �����, ������� ������ ���������� ����������

t.LoadNamesGender() --��������� ������ ���, ��������������� �� ���� � �����

t.LoadFixedNames(false) --��������� ���������� ���������





















--������� ������ ��������� ��������������� prefix � ����������� �� ������, ���� � ����� ��������
function FixPrefix(prefix,act,item)
	if not t.NamesGender then return prefix end
--	prefix=prefix.." "
	local soft23={["�"]=1,["�"]=1,["�"]=1}
	
	local soft45={["�"]=1,["�"]=1,["�"]=1,["�"]=1,["�"]=1,["�"]=1,["�"]=1}
	local endings={}
	--������� ��������� � ����������� �� �������� � ����
	--case2 � case3, � ��� �� case4 � case5 � ������ � ������ ����
				--  �������    �����      ���������  �������    �������
	--���? ���?
	endings["NOACTION"]={	he={case1="��",case2="��",case3="��",case4="��",case5="��"},
				he2={case1="��",case2="��",case3="��",case4="��",case5="��"},
				she={case1="��",case2="��",case3="��",case4="��",case5="��"},
				it={case1="��",case2="��",case3="��",case4="��",case5="��"},
				plural={case1="��",case2="��",case3="��",case4="��",case5="��"},
				plural2={case1="��",case2="��",case3="��",case4="��",case5="��"}}
	--����? ���?
	endings["DEFAULTACTION"]={	he={case1="��",case2="��",case3="��",case4="��",case5="��"},
					he2={case1="���",case2="���",case3="���",case4="���",case5="���"},
					she={case1="��",case2="��",case3="��",case4="��",case5="��"},
					it={case1="��",case2="��",case3="��",case4="��",case5="��"},
					plural={case1="��",case2="��",case3="��",case4="��",case5="��"},
					plural2={case1="��",case2="��",case3="��",case4="��",case5="��"}}
	--����? ����?
	endings["WALKTO"]={	he={case1="���",case2="���",case3="���",case4="���",case5="���"},
				he2={case1="���",case2="���",case3="���",case4="���",case5="���"},
				she={case1="��",case2="��",case3="��",case4="��",case5="��"},                          
				it={case1="���",case2="���",case3="���",case4="���",case5="���"},
				plural={case1="��",case2="��",case3="��",case4="��",case5="��"},
				plural2={case1="��",case2="��",case3="��",case4="��",case5="��"}}
	--���? ׸�?
	endings["SLEEPIN"]={	he={case1="��",case2="��",case3="��",case4="��",case5="��"},
				he2={case1="��",case2="��",case3="��",case4="��",case5="��"},
				she={case1="��",case2="��",case3="��",case4="��",case5="��"},
				it={case1="��",case2="��",case3="��",case4="��",case5="��"},
				plural={case1="��",case2="��",case3="��",case4="��",case5="��"},
				plural2={case1="��",case2="��",case3="��",case4="��",case5="��"}}
	--��������� ���
	local gender="he"	
	if t.NamesGender["he2"][item] then gender="he2"
	elseif t.NamesGender["she"][item] then gender="she"
	elseif t.NamesGender["it"][item] then gender="it"
	elseif t.NamesGender["plural"][item] then gender="plural"
	elseif t.NamesGender["plural2"][item] then gender="plural2" end

	--������ ������. ��� �������� "�������" � ���� ���� ��� ������ � ��������� �������. ��� ���������� ������������� �����.
	if act=="PICK" and t.RussianNames[STRINGS.NAMES[string.upper(item)]] and t.RussianNames[STRINGS.NAMES[string.upper(item)]][act] then gender="plural" end
	--���� ���������� �������� � ������� ����

	local found=false
	for i,v in pairs(endings) do if act==i then found=true end end
	if not found then act="DEFAULTACTION" end
	
	local words=string.split(prefix," ") --��������� �� �����
	prefix=""
	for _,word in ipairs(words) do
		if isupper(word:sub(1,1)) and #word>3 then
			--�������� �� ���� ��������� ���������
			if string.sub(word,-2)=="��" then
				word=string.sub(word,1,#word-2)..endings[act][gender]["case1"]
			elseif string.sub(word,-2)=="��" then
				if soft23[string.sub(word,-3,-3)] then
					word=string.sub(word,1,#word-2)..endings[act][gender]["case3"]
				else
					word=string.sub(word,1,#word-2)..endings[act][gender]["case2"]
				end
			elseif string.sub(word,-2)=="��" then
				if soft45[string.sub(word,-3,-3)] then
					word=string.sub(word,1,#word-2)..endings[act][gender]["case5"]
				else
					word=string.sub(word,1,#word-2)..endings[act][gender]["case4"]
				end
			end
		end
		prefix=prefix..word.." "
	end
	prefix=string.sub(prefix,1,1)..russianlower(string.sub(prefix,2,-2))
	return prefix
end






local GetAdjectiveOld=GLOBAL.EntityScript["GetAdjective"]
--����� ������ �������, �������� �������� ��������
function GetAdjectiveNew(self)
	local str=GetAdjectiveOld(self)
	if str and self.prefab then
		local player = GetPlayer()
		local act=player.components.playercontroller:GetLeftMouseAction() --�������� ������� ��������
		if act then act=act.action.id or "NOACTION" else act="NOACTION" end
		str=FixPrefix(str,act,self.prefab) --�������� ��������� ��������
		if act~="NOACTION" then --���� ���� ��������, �� ����� ������� � ��������� �����
			str=firsttolower(str)
		end
	end
	return str
end
GLOBAL.EntityScript["GetAdjective"]=GetAdjectiveNew --��������� �������, ��������� �������� ���������



--���� ��� hoverer, ���������� � GetDisplayName ��������, ���� ��� ����
AddClassPostConstruct("widgets/hoverer", function(self)
	if not self.OnUpdate then return end
	local OldOnUpdate=self.OnUpdate
	function self:OnUpdate(...)
		local changed = false
		local OldlmbtargetGetDisplayName
        local lmb = self.owner and self.owner.components and self.owner.components.playercontroller and self.owner.components.playercontroller:GetLeftMouseAction()
		if lmb and lmb.target and lmb.target.GetDisplayName then
			changed = true
			OldlmbtargetGetDisplayName = lmb.target.GetDisplayName
			lmb.target.GetDisplayName = function(self)
				return OldlmbtargetGetDisplayName(self, lmb)
			end
		end
		OldOnUpdate(self, ...)
		if changed then
			lmb.target.GetDisplayName = OldlmbtargetGetDisplayName
		end
	end
end)

GLOBAL.a = ""

local GetDisplayNameOld=GLOBAL.EntityScript["GetDisplayName"] --��������� ������ �������, ��������� �������� ��������
function GetDisplayNameNew(self, act) --������� �������, ��������� �������� ��������. � ��� ����������� ��������� � ����������� �� �������� (���������� �ct)
	local name=GetDisplayNameOld(self)
	local player = GetPlayer()
	print("GetDisplayNameNew",name, act and act.action.id)
	GLOBAL.a = self
--	if not player then return name end --���� �� ������� �������� instance ������, �� ���������� ��� �� ����. � �������
	
--	local act=player.components.playercontroller:GetLeftMouseAction() --�������� ������� ��������

	if name=="Maxwell" then name = "��������" end --��� ���������, �������� �� �����

	if self:HasTag("player") then
		if STRINGS.NAMES[self.prefab:upper()] then
			act=act and act.action.id or "DEFAULT"
			name=(t.RussianNames[name] and (t.RussianNames[name][act] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"])) or rebuildname(name,act,self.prefab) or name
		end
		return name
	end

	local itisblueprint=false
	if name:sub(-10)==" Blueprint" then --������ �������������� ��������� ��� ��������
		name=name:sub(1,-11)
		itisblueprint=true
	end
	--��������, ���� �� ������� ��������, ������������ ��� ��������
	local Prefix=nil
	if STRINGS.WET_PREFIX then
		for i,v in pairs(STRINGS.WET_PREFIX) do
			if type(v)=="string" and v~="" and string.sub(name,1,#v)==v then Prefix=v break end
		end 
		if string.sub(name,1,#STRINGS.WITHEREDITEM)==STRINGS.WITHEREDITEM then Prefix=STRINGS.WITHEREDITEM 
		elseif string.sub(name,1,#STRINGS.SMOLDERINGITEM)==STRINGS.SMOLDERINGITEM then Prefix=STRINGS.SMOLDERINGITEM end
		if Prefix then --����� �������. ������ ��� � ������� �� ����� ��� ��� ���������� ���������� ���������
			name=string.sub(name,#Prefix+2)--������� ������� �� �����
			if act then
				Prefix=FixPrefix(Prefix,act.action.id or "NOACTION",self.prefab)
				--���� ���� ��������, ������ ����� ������� � ��������� �����
				Prefix=firsttolower(Prefix)
			else 
				Prefix=FixPrefix(Prefix,"NOACTION",self.prefab)
				if self:GetAdjective() then
					Prefix=firsttolower(Prefix)
				end				
			end
		end
	end
	if act then --���� ���� ��������
		act=act.action.id

		if itisblueprint then
			name="����� �������� \""..name.."\""		
		elseif self.prefab=="wreck" and self.components.named then
			--������� � ��������� �������
			name = self.components.named.nameformat
			name = t.RussianNames[name] and
				(t.RussianNames[name][act] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"])
				or rebuildname(name,act,self.prefab) or name
			name = string.format(name, self.components.named.name)
			name = t.ParseTranslationTags(name, nil, nil, act)
		 	name = firsttolower(name)
		else
			name = t.RussianNames[name] and
				(t.RussianNames[name][act] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"])
				or rebuildname(name,act,self.prefab) or name
			local animated = {pigman = true, pigguard = true, bunnyman = true, wildbore = true, wildboreguard = true, mermfisher = true}
			if not (self.prefab and animated[self.prefab])
			 and not t.ShouldBeCapped[self.prefab] and name and type(name)=="string" and #name>0 then
				--������ ������ ������ �������� �������� � ������ �������
			 	name=firsttolower(name)
			end
		end

	else	--���� ��� ��������
	    if itisblueprint then name="����� �������� \""..name.."\"" end
		if not t.ShouldBeCapped[self.prefab] and (self:GetAdjective() or Prefix) then
		 	name=firsttolower(name)
		end
	end
	if Prefix then
		name=Prefix.." "..name
	end
	if act and act=="SLEEPIN" and name then name="� "..name end --������ ������ ��� "����� � �������" � "����� � ������ ��� ������"
    return name
end
GLOBAL.EntityScript["GetDisplayName"]=GetDisplayNameNew --��������� �� �����



--�������������� �������, ��������� "������� ...", ����� ��������������� �� ����� �����-������� ���� �������.
local OldGetHoverTextOverride
function NewGetHoverTextOverride(self)
	if self.placer_recipe then
		local name=STRINGS.NAMES[string.upper(self.placer_recipe.name)]
		local act="BUILD"
		if name then
			if t.RussianNames[name] then
				name=t.RussianNames[name][act] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"] or rebuildname(name,act) or STRINGS.UI.HUD.HERE
			else
				name=rebuildname(name,act) or STRINGS.UI.HUD.HERE
			end
		else
			name=STRINGS.UI.HUD.HERE
		end
		if not t.ShouldBeCapped[self.placer_recipe.name] and name and type(name)=="string" and #name>0 then
			--������ ������ ������ �������� �������� � ������ �������
		 	name=firsttolower(name)
		end
		return STRINGS.UI.HUD.BUILD.. " " .. name
	end
end

AddClassPostConstruct("components/playercontroller", function(self)
	GetHoverTextOverride=self["GetHoverTextOverride"]
	self["GetHoverTextOverride"]=NewGetHoverTextOverride
end)



local oldSelectPortrait --������ ������� ������ �������� � ���� ������ ���������
local function newSelectPortrait(self,portrait)
	oldSelectPortrait(self,portrait) --��������� ������������ �������
	if self.heroportait and self.heroportait.texture then
		local list={["locked"]=1,["wickerbottom"]=1,["waxwell"]=1,["willow"]=1,["wilson"]=1,["woodie"]=1,["wes"]=1,["wolfgang"]=1,["wendy"]=1}
		if t.ROG_Installed or t.SW_Installed then
			list["wathgrithr"]=1
			list["webber"]=1
		end
		if t.SW_Installed then
			list["walani"]=1
		end
		local name=string.sub(self.heroportait.texture,1,-5)
		if list[name] then
			self.heroportait:SetTexture("images/rus_"..name..".xml", "rus_"..name..".tex")
		end
	end
end


--��������� ������� ������ �������� � ���� ������ ���������
AddClassPostConstruct("screens/characterselectscreen", function(self)
	oldSelectPortrait=self["SelectPortrait"]
	self["SelectPortrait"]=newSelectPortrait
	self:SelectPortrait(1) --�����, ����� �������� ��, ��� ��� ������ ����������
end)

--��������� ��������� Broadcasting Beta
if t.ROG_Installed or t.SW_Installed then
	AddGlobalClassPostConstruct("screens/broadcastingoptionsscreen", "BroadcastingOptionsScreen", function(self)
		for i,v in pairs(self.root.children) do
			if v["GetString"] and v:GetString()=="Broadcasting Beta" then v:SetString("�������� ����� ����������") end
		end
-- ������� �������� ������
		if self.grid then for i,v in pairs(self.grid.children) do
		if type(v)=="table" and v.name=="SpinnerGroup" then
			for ii,vv in pairs(v.children) do
				if type(vv)=="table" and vv.name=="Text" then
					vv:Nudge({x=25,y=0,z=0})
				end
			end
		end
	end end
	end)
end

local oldRefreshOptions --������ ������� ���������� ����� � ���� �������� �����
local function newRefreshOptions(self) --����� �������
	oldRefreshOptions(self) --��������� ������������ �������

	if not self.optionspanel then return end
	local list={	["day.tex"]=1,
			["season.tex"]=1,
			["season_start.tex"]=1,
			["world_size.tex"]=1,
			["world_branching.tex"]=1,
			["world_loop.tex"]=1,
			["winter.tex"]=1,
			["summer.tex"]=1,
			["autumn.tex"]=1,
			["spring.tex"]=1}
	for _,a in pairs({[1]=self.optionspanel:GetChildren()}) do
	for v in pairs(a) do --���������� ������
			if tostring(v)=="option" then
			for prefab in pairs(v:GetChildren()) do --���� �������� � ������� � ������
				
				if prefab.name and prefab.name:upper()=="IMAGE" then
					if list[prefab.texture] then
						prefab:SetTexture(MODROOT.."images/rus_mapgen.xml", "rus_"..prefab.texture)
					end
				elseif prefab.name and prefab.name:upper()=="SPINNER" and prefab.options then
					local shouldbeupdated=false
					for _,opt in ipairs(prefab.options) do --������� �����
						local words=string.split(opt.text," ") --��������� �� �����
						opt.text=words[1]
						if #words>1 then --���� ���� ���������
							if opt.text==STRINGS.UI.SANDBOXMENU.SLIDELONG then --������ ����-�����-����
								if words[2]==STRINGS.UI.SANDBOXMENU.DAY or words[2]==STRINGS.UI.SANDBOXMENU.DUSK then
									opt.text=opt.text:sub(1,-2).."��"
								elseif words[2]==STRINGS.UI.SANDBOXMENU.NIGHT or words[2]==STRINGS.UI.SANDBOXMENU.WINTER then
									opt.text=opt.text:sub(1,-2).."��"
								elseif words[2]==STRINGS.UI.SANDBOXMENU.SUMMER then
									opt.text=opt.text:sub(1,-2).."��"
								end
							elseif opt.text==STRINGS.UI.SANDBOXMENU.SLIDENEVER then --��� ���-������-����
								if words[2]==STRINGS.UI.SANDBOXMENU.DAY then
									words[2]="���"
								elseif words[2]==STRINGS.UI.SANDBOXMENU.NIGHT then
									words[2]="����"
								elseif words[2]==STRINGS.UI.SANDBOXMENU.DUSK then
									words[2]="������"
								end
							end
							for i=2,#words do --��� ����������� � ��������� �����
								opt.text=opt.text.." "..firsttolower(words[i])
							end
							shouldbeupdated=true
						end
					end
					if shouldbeupdated then prefab:UpdateText(prefab.options[prefab.selectedIndex].text) end
				end
			end
		end
	end end
end

--��������� ������� ���������� � ���������� ��������� ����� �����
AddClassPostConstruct("screens/customizationscreen", function(self)
	if self["savepresetbutton"] then --��������� ����� �� ������ ���������� �������
		self.savepresetbutton.text:SetSize(30)
	end
	oldRefreshOptions=self["RefreshOptions"]
	self["RefreshOptions"]=newRefreshOptions
	self:RefreshOptions() --�����, ����� �������� ��, ��� ��� ������ ����������
end)




--��� � ���������������� ������� Enabled � Disabled � ���������� ��� ����������� ������ ����

AddClassPostConstruct("screens/optionsscreen", function(self) 
	for _,v in pairs(self) do
		if type(v)=="table" and v.name=="SPINNER" then
			local shouldbeupdated=false
			for _,opt in ipairs(v.options) do --������� �����
				if opt.text=="Enabled" then
					opt.text=STRINGS.UI.OPTIONS.ENABLED
					shouldbeupdated=true
				elseif opt.text=="Disabled" then
					opt.text=STRINGS.UI.OPTIONS.DISABLED
					shouldbeupdated=true
				end
			end
			if v.selectedIndex and v.selectedIndex>0 and v.selectedIndex<=#v.options then v:UpdateText(v.options[v.selectedIndex].text) end
		end
	end
	--��������� ��� �������� ������
	-- � DS �� ����� 
	--[[if self.grid then for i,v in pairs(self.grid.children) do
		if type(v)=="table" and v.name=="SpinnerGroup" then
			for ii,vv in pairs(v.children) do
				if type(vv)=="table" and vv.name=="Text" then
				        vv:Nudge({x=40,y=0,z=0})
				end
			end
		end
	end end]]
end)



--���������� ����� ������� ������� �� ������� � ������ � ���������.
AddClassPostConstruct("widgets/containerwidget", function(self)
	self.oldOpen=self.Open
	local function newOpen(self, container, doer)
		self:oldOpen(container, doer)
		if self.button then
			if self.button:GetText()=="Cook" then self.button:SetText("��������") end
			if self.button:GetText()=="Activate" then self.button:SetText("���������") end
		end
	end
	self.Open=newOpen
end)

AddClassPostConstruct("widgets/recipepopup", function(self) --��������� ����� �������� ������� � ������ ��������
	if self.name and self.Refresh then --������������� ����� ��������, ���������, ��������� �� ���, � ���� �����, ������ ��� ������
		if not self.OldRefresh then
			self.OldRefresh=self.Refresh
			function self.Refresh(self,...)
				self:OldRefresh(...)
				if not self.name then return end
				local Text = require "widgets/text"
		    local tmp = self.contents:AddChild(Text(GLOBAL.UIFONT, 36))
			      tmp:SetPosition(320, 142, 0)
			      tmp:SetHAlign(GLOBAL.ANCHOR_MIDDLE)
			      tmp:Hide()
		        tmp:SetString(self.name:GetString())
			    local desiredw = self.name:GetRegionSize()
				local w = tmp:GetRegionSize()
				tmp:Kill()
				if w>desiredw then
					self.name:SetSize(36*desiredw/w)
				else
					self.name:SetSize(42)
				end
			end
		end
	end 
	if self.desc then
		self.desc:SetSize(28)
		self.desc:SetRegionSize(64*3+30,130)
	end
end)



--[[--������������� ����� "����" � ����������� ���� � ���� ������ ���������
AddClassPostConstruct("screens/deathscreen", function(self, days_survived)
	if self.t2 and days_survived then
		self.t2:SetString(StringTime(days_survived))
	end
	if self.rewardtext then
		self.rewardtext:Nudge({x=-20,y=0,z=0})
	end
	if self.leveltext then
		self.leveltext:Nudge({x=10,y=0,z=0})
	end
end)]]

	--����-���� ���������� ������� � ������� � ���� �������� ���
	AddClassPostConstruct("screens/loadgamescreen", function(self)
		self.oldMakeSaveTile=self.MakeSaveTile
		local function newMakeSaveTile(self,slotnum)
			local item=self:oldMakeSaveTile(slotnum)
			item.portraitbg:SetPosition(-130 + 40, 2, 0)	
			item.portrait:SetPosition(-130 + 40, 2, 0)	
			if item.portraitbg.shown then item.text:SetPosition(50,0,0) end
			return item
		end
		self.MakeSaveTile=newMakeSaveTile
	end)

	--��������� ������ ������ � ��������� ������� ������
	AddClassPostConstruct("screens/slotdetailsscreen", function(self)
		self.text:SetSize(45)
	end)

	--��������� ���� ����� � ���� ������ Twitch, ������� �� �����-�� ������� �� � STRINGS
	AddClassPostConstruct("screens/broadcastingloginscreen", function(self)
		if self.title and self.title:GetString()=="Twitch User Name" then
			self.title:SetString("��� ������������ � Twitch")
		end
		if self.password_title and self.password_title:GetString()=="Twitch Password" then
			self.password_title:SetString("������ � Twitch")
		end
	end)
	

	
--��������� ����� � ��������� �����
AddClassPostConstruct("screens/morguescreen", function(self)
	if self.obits_titles then
		for str in pairs(self.obits_titles:GetChildren()) do
			if type(str)=="table" and str.name and str.name=="Text" then
				str:SetSize(28)
			end
		end
	end
	if self.RefreshControls then
		local oldRefreshControls = self.RefreshControls
		function self.RefreshControls() -- � ������� �������� ���� �������� ����� � ������� ������ ��� ���� �������
			local Text = require "widgets/text"
			local oldTextSetString = Text.SetString
			function Text.SetString(slf, str, ...)
				if str == STRINGS.NAMES.DROWNING or str == STRINGS.NAMES.BURNT then
					local group = slf:GetParent()
					local children = group and group:GetChildren()
					if children then
						for child in pairs(children) do
							if child.name == "DECEASED" then
								local character = child.portrait.texture
								character = character and character:sub(1,-5)
								str = t.ParseTranslationTags(str, character)
								break
							end
						end
					end
				end
				oldTextSetString(slf, str, ...)
			end
			oldRefreshControls(self)
			Text.SetString = oldTextSetString
		end
		self:RefreshControls()
	end
end)

--���������� ������������������ ���� � ��������� ���� ��������� �����
AddClassPostConstruct("screens/modconfigurationscreen", function(self)
	for title,val in pairs(self.root.children) do
		if title.name and string.lower(title.name)=="text" then 
			local tmp=title:GetString()
			tmp=string.sub(tmp,1,#tmp-#STRINGS.UI.MODSSCREEN.CONFIGSCREENTITLESUFFIX-1)
			title:SetString(STRINGS.UI.MODSSCREEN.CONFIGSCREENTITLESUFFIX.." \""..tmp.."\"")
		end
	end
end)

--��������� �����, ������ ��� ��� ��� ����������������� ����������
AddClassPostConstruct("widgets/loadingwidget", function(self)
	local OldKeepAlive = self.KeepAlive
	function self:KeepAlive(...)
		local res = OldKeepAlive(self, ...)
		if self.loading_widget then
			self.loading_widget:SetFont(GLOBAL.UIFONT)
			if not self.loading_widget.RLPInitialized then
				self.loading_widget.RLPInitialized = true
				local OldSetString = self.loading_widget.SetString
				function self.loading_widget:SetString(str, ...)
					if str and type(str)=="string" then
						str = str:gsub("Loading", "��������")
					end
					local res = OldSetString(self, str, ...)
					return res
				end
				self.loading_widget:SetString(self.loading_widget:GetString())
			end
		end
		return res
	end
end)




--����������� ���� � ������� � ���������
AddClassPostConstruct("widgets/spinner", function(self, options, width, height, textinfo, ...) --��������� ������� ������ � �������� ��-�� ������ ������ �������� � ���� �������
	if textinfo then return end
	self.text:SetFont(GLOBAL.BUTTONFONT)
end)


--��� ���, ��� ���������� ps4 ��� NACL ������ ���� ����������� ��������� �� � ��� �����, � � ������.
--��� ����� ������������ ���������� ������������ ������ PlayerProfile
local function SetLocalizaitonValue(self,name,value) --�����, ����������� ����� � ������ name � ��������� value
    local USE_SETTINGS_FILE = GLOBAL.PLATFORM ~= "PS4" and GLOBAL.PLATFORM ~= "NACL"
 	if USE_SETTINGS_FILE then
		GLOBAL.TheSim:SetSetting("translation", tostring(name), tostring(value))
	else
		self:SetValue(tostring(name), tostring(value))
		self.dirty = true
		self:Save() --��������� �����, ��������� � ��� ��� ������ "���������"
	end
end
local function GetLocalizaitonValue(self,name) --�����, ������������ �������� ����� name
        local USE_SETTINGS_FILE = GLOBAL.PLATFORM ~= "PS4" and GLOBAL.PLATFORM ~= "NACL"
 	if USE_SETTINGS_FILE then
		return GLOBAL.TheSim:GetSetting("translation", tostring(name))
	else
		return self:GetValue(tostring(name))
	end
end

--��������� ���������� PlayerProfile �������������� �������������� ���� ������� � �������� ��������� �������� ����� ������ ��������.
AddGlobalClassPostConstruct("playerprofile", "PlayerProfile", function(self)
        local USE_SETTINGS_FILE = GLOBAL.PLATFORM ~= "PS4" and GLOBAL.PLATFORM ~= "NACL"
 	if not USE_SETTINGS_FILE then
	        self.persistdata.update_is_allowed = true --��������� ��������� ���������� �� ���������
	        self.persistdata.update_frequency = GLOBAL.RusUpdatePeriod[3] --��� � ������ �� ���������
		local date=GLOBAL.os.date("*t")
		self.persistdata.last_update_date = tostring(date.day.."."..date.month.."."..date.year) --������� ���� �� ���������
	end
	self["SetLocalizaitonValue"]=SetLocalizaitonValue --����� ������ �������� �����
	self["GetLocalizaitonValue"]=GetLocalizaitonValue --����� ��������� �������� �����
end)



--���������� ������ �������� � ������ ����
function AddSettingsButton()
	-- ���������, ������ ��� � ���� ������ ��� �����
	--[[local OldShowMenu --������ ������� ������ ���� ��� mainscreen
	function NewShowMenu(self,menu_items) --����� �������
		for i,v in ipairs(menu_items) do --���� ������ "����������", � ��������� ����� �� "�����������"
			if v.text==STRINGS.UI.MAINSCREEN.CONTROLS then
				local LanguageOptions = require "screens/LanguageOptions"
				table.insert( menu_items, i+1, {text="�����������", cb= function() GLOBAL.TheFrontEnd:PushScreen(LanguageOptions()) end})
			end
		end
		OldShowMenu(self,menu_items) --��������� ������������ �������
	end ]]
	AddClassPostConstruct("screens/mainscreen", function(self) --��������� �������, ����� ������������ ������ "�����������"
		--OldShowMenu=self["ShowMenu"]
		--self["ShowMenu"]=NewShowMenu
		--��������� ������� � ��������� ������� �� ���� ����
		if self.motd then
			self.motd.showwiki=GLOBAL.os.time()%5<3 --�������� � ������������ 3/5=0.6
			self.motd.OldShow=self.motdShow
			
			function motdShow(self)
				if self.OldShow then self:OldShow() end
				local titlelist={
				["Beefalo Plush!"]="�������� ������!",
				["Don't Starve Figures!"]="������� Don't Starve",
				["New Curator Page!"]="����� �������� ��������!",
				["Halloween Mod Challenge"]="������������ �������",
				["Technical Difficulties"]="����������� ���������",
				["Chester Plush Is Back!"]="������ ��������!",
				["KLEI STORE SALE!"]="���������� � ��������"}
				local textlist={
				["Today, we welcome 2 million new players into the Don't Starve Together community."]="������� �� ����������\n2 �������� ����� ������� � ���� ����������\nDon't Starve Together.",
				["Don't Starve collectable figures are available now at the Klei Store!"]="���������� �������\nDon't Starve ��� ����� ������ � �������� Klei!",
				["Don't Starve collectable figures are available now in the Klei Store!"]="���������� �������\nDon't Starve ��� ����� ������ � �������� Klei!",
				["Check out the new \"Rhymes with Play\" Curator page on Steam!"]="�������� ����� �������� �������� \"Rhymes with Play\" � Steam!",
				["Beefalo Plush are available now in the Klei Store!"]="������ � �������� Klei ����� ������ ��������� ������!",
				["If you want to participate in our Halloween Mod Challenge click the link below!"]="���� ������ ������� ������� � ������������ �������� �����, ������� �� ������ ����!",
				["We are experiencing lobby server issues. We will have things fixed up as soon as possible."]="� ��� ��������� �������� � ���������. ����������� ��������� ��� ����� �������.",
				["The Multiplayer Expansion is Now Available on Steam Early-Access!"]="����������\n� ��������������������� ������� ����� � ������ ������ �� Steam!",
				["Big Klei Store update! Chester is back along with winter hats, spiders and new figs!"]="������� ���������� �������� Klei!\n������ �������� ������ � ������� �������, ������� � ������ ���������!",
				["Krampus Sale is happening now! Save up to 25% on Don't Starve figs and more! "]="������� ������� ����������! ����������\n�� 25% �� �������� \nDon't Starve!"}
				local buttonlist={
				["Read more"]="���������",
				["Klei Store"]="������� Klei",
				["Follow Us"]="��������",
				["Join Us"]="��������",
				["More Info"]="���������",
				["Check it out"]="����������",
				["GO TO SALE"]="��� ����"}
			        if self.showwiki then
					self.motdtitle:SetString("������������� ����")
					self.motdtext:SetString("�������� ��������� �������� ����� � ���� �� ������ �� ������������� ����.")
					self.button:SetText("��� ���?")
					self.button:SetOnClick( function() GLOBAL.VisitURL("http://ru.dont-starve.wikia.com/wiki/Don%27t_Starve_wiki") end )
				else
					self.motdtitle:SetString(titlelist[self.motdtitle:GetString()] or self.motdtitle:GetString())
					self.motdtext:SetString(textlist[self.motdtext:GetString()] or self.motdtext:GetString())
					self.button:SetText(buttonlist[self.button:GetText()] or self.button:GetText())
				end
			end
			self.motd.Show=motdShow
			self.motd:Show()
		end
	end)
end
  
--���������� ������ �������� ���� ����� ��� ��������� �� ������� ���
if GLOBAL.KnownModIndex and GLOBAL.KnownModIndex.HasModConfigurationOptions then
	local OldHasModConfigurationOptions = GLOBAL.KnownModIndex.HasModConfigurationOptions
	function GLOBAL.KnownModIndex:HasModConfigurationOptions(modname, ...)
		local res = OldHasModConfigurationOptions(self, modname, ...)
		if self:GetModInfo(modname).name==modinfo.name then res = true end
		return res
	end
end

--�������������� �������� ������
AddGlobalClassPostConstruct("screens/modsscreen", "ModsScreen", function(self)
	if self.detailwarning and self.CreateDetailPanel then
		self.detailwarning:SetSize(22)
		local OldCreateDetailPanel=self.CreateDetailPanel
		function self:CreateDetailPanel(...)
			OldCreateDetailPanel(self,...)
			self.detailwarning:SetSize(22)
			print(modname, self.modnames[self.currentmod])
			if self.modlinkbutton then
--				self.modlinkbutton:Nudge({x=100,y=0,z=0})
				
				local TextButton = require "widgets/textbutton"
				self.modlinkbutton2 = self.detailpanel:AddChild(TextButton("images/ui.xml", "blank.tex","blank.tex","blank.tex","blank.tex" ))
				self.modlinkbutton2:Hide()
				self.modlinkbutton2:SetPosition(5-78, -119, 0)
				self.modlinkbutton2:SetFont(GLOBAL.BUTTONFONT)
				self.modlinkbutton2:SetTextSize(30)
				self.modlinkbutton2:SetTextColour(0.9,0.8,0.6,1)
				self.modlinkbutton2:SetTextFocusColour(1,1,1,1)
				self.modlinkbutton2:SetText("��� � SteamWorkshop")
				self.modlinkbutton2:SetOnClick( function() GLOBAL.VisitURL(t.SteamURL) end )
			end
		end
	end
	if self.ShowModDetails and self.modlinkbutton then
		local OldShowModDetails = self.ShowModDetails
		function self:ShowModDetails(idx, ...)
			local res = OldShowModDetails(self, idx, ...)
			if idx and self.modnames[idx] then
				if modname==self.modnames[idx] then
					if self.modlinkbutton2 then self.modlinkbutton2:Show() end
					self.modlinkbutton:SetPosition(5+90, -119, 0)
					self.modlinkbutton:SetText("��� �� ������ Klei")
				else
					if self.modlinkbutton2 then self.modlinkbutton2:Hide() end
					self.modlinkbutton:SetPosition(5, -119, 0)
					self.modlinkbutton:SetText(STRINGS.UI.MODSSCREEN.MODLINK)
				end
			end
			return res
		end
	end
	local OldConfigureSelectedMod = self.ConfigureSelectedMod
	if OldConfigureSelectedMod then
		function self:ConfigureSelectedMod(...)
			local res = nil
			local modname = self.modnames[self.currentmod]
			if GLOBAL.KnownModIndex:GetModInfo(modname).name==modinfo.name then
				local LanguageOptions = require "screens/LanguageOptions"
				GLOBAL.TheFrontEnd:PushScreen(LanguageOptions())
			else
				res = OldConfigureSelectedMod(self, ...)
			end
			return res
		end
	end
end)


--��������� ����� �� �����������
local function DownloadNotabenoidChapters()
--[[	�������� ���������. ���������� �� ��������!
	if GLOBAL.RUN_GLOBAL_INIT then --������ ����������� ������ ��� ������ �������� ����
		local UpdateRussianDialog = require "screens/UpdateRussianDialog"
		GLOBAL.TheFrontEnd:PushScreen(UpdateRussianDialog())
	end
]]
end


local OldStart = GLOBAL.Start
function Start() --����� ���������� ���� ������� ��� ����� ���������� �������.


	AddSettingsButton() --��������� ������ ��������. ������ ���� �����, ����� �� ������������� � RPGHud � ���������� ������� ������
	OldStart() --������� ��������� ������ �������


	--���� ������� ���� �� DLC, �� ����� ��������� ����������� ������ ���������� ���
	if t.ROG_Installed or t.SW_Installed then
		GLOBAL.TranslateStringTable(GLOBAL.STRINGS)
	end

	local a=GLOBAL.Profile:GetLocalizaitonValue("update_is_allowed")
	
	if not a or a=="true" or a==true then --���� � ini ����� ���� ������, ����������� ��������� ���������� ��� � ������ ���
		local period=GLOBAL.Profile:GetLocalizaitonValue("update_frequency")
		if not period then --���� ��� ������ � �������, �� ������ �� ��������� ��� � ������
			period=GLOBAL.RusUpdatePeriod[3]
			GLOBAL.Profile:SetLocalizaitonValue("update_frequency",period)
		end
		if period==GLOBAL.RusUpdatePeriod[1] then --��� ������ �������
			DownloadNotabenoidChapters()
		end
		if period~=GLOBAL.RusUpdatePeriod[5] then --���� �� ������� "������� �� ���������"
			local date=GLOBAL.os.date("*t")
			local date2=GLOBAL.Profile:GetLocalizaitonValue("last_update_date")
			if date2 then --�������� ��� ����. ���������� � ����������� �� ������������� ������� ����������
				date2=string.split(date2,".")
				if period==GLOBAL.RusUpdatePeriod[2] then --��� � ����
					if date2[1]~=tostring(date.day) then
						DownloadNotabenoidChapters()
					end
				else
					local a=28
					if date.year%4==0 then a=29 end
					local DaystoMonth={0,31,31+a,31+a+31,31+a+31+30,31+a+31+30+31,31+a+31+30+31+30,31+a+31+30+31+30+31,31+a+31+30+31+30+31+31,31+a+31+30+31+30+31+31+30,31+a+31+30+31+30+31+31+30+31,31+a+31+30+31+30+31+31+30+31+30}
					local DaysperMonth={31,a,31,30,31,30,31,31,30,31,30,31}
					local datedaysum=tonumber(date.year)*365+DaystoMonth[tonumber(date.month)]+tonumber(date.day)
					local date2daysum=tonumber(date2[3])*365+DaystoMonth[tonumber(date2[2])]+tonumber(date2[1])
					if period==GLOBAL.RusUpdatePeriod[3] then --��� � ������
						if datedaysum-7>=date2daysum then
							DownloadNotabenoidChapters()
						end
					elseif period==GLOBAL.RusUpdatePeriod[4] then --��� � �����
						if datedaysum-DaysperMonth[tonumber(date2[2])]>=date2daysum then
							DownloadNotabenoidChapters()
						end
					end
				
				end
			else --��� ������ � ����. ������ ��� ������ ����� ������ ����������.
				DownloadNotabenoidChapters() 
			end
		end
	end
end
GLOBAL.Start=Start



--������������� ������� �������� ���� ��� ������ � ��� ���� ������ � ���, ��� ����� �����������
local oldshutdown=GLOBAL.Shutdown
function newShutdown()
	GLOBAL.Profile:SetLocalizaitonValue("update_is_allowed", "true") --���� ���� ��������� � ���������� �����, �������� � ��������� ��� ��������� ����������
	oldshutdown()
end
GLOBAL.Shutdown=newShutdown










--������������ � ��������� ������� ���� ���������� russian ��� �������� ����������� (��� ������� ������ ����).
if GLOBAL.ModIndex.InitializeModInfoEnv then
    --���� PeterA ������� ������, �� ��������� �������������.
    local old_InitializeModInfoEnv = GLOBAL.ModIndex.InitializeModInfoEnv
    GLOBAL.ModIndex.InitializeModInfoEnv = function(self,...)
        local env = old_InitializeModInfoEnv(self,...)
		env.language = "ru"
		env.russian = true -- !!! ���������� ������. ����� ��������� ����� ����� ������� !!!
        return env
    end
else --����� �����������, ��� ������.
    local temp_mark = false --��������� �����, ����������, ��� � ��������� ����� RunInEnvironment ���� �������� russian=true
   
    --������������� "kleiloadlua", ����� ���������� ��������� ����� � ������ �������� "modinfo.lua"
    local old_kleiloadlua = GLOBAL.kleiloadlua
    GLOBAL.kleiloadlua = function(path,...)
        local fn = old_kleiloadlua(path,...)
        if fn and type(fn) ~= "string" and path:sub(-12) == "/modinfo.lua" then
			temp_mark = true
        end
        return fn
    end
   
    --������������� RunInEnvironment, ����� ������������ �� ����� (������ �������� ��)
    local old_RunInEnvironment = GLOBAL.RunInEnvironment
    GLOBAL.RunInEnvironment = function(fn, env, ...)
		if env and temp_mark then
			env.language = "ru"
			env.russian = true -- !!! ���������� ������. ����� ��������� ����� ����� ������� !!!
			temp_mark = false
		end
		return old_RunInEnvironment(fn, env, ...)
    end
end






local genders_reg={"he","he2","she","it","plural","plural2", --numbers
	he="he",he2="he2",she="she",it="it",plural="plural",plural2="plural2"};
--[[������� ������������ ����� ��� �������� �� ����� �������, ������������ ��� ��� ����������� ���������.

    key - ���� �������. ��������, MYITEM (�� GLOBAL.STRINGS.NAMES.MYITEM).
    val - ������� ������� �������� �������.
    gender - ��� �������. ��������: he, he2, she, it, plural, plural2. ��� ����� ��� ��������� ��������� ���� � ���������.
	     "he" � "he2" - ��� ������� ���, �� �� ���� � �� ��, ��������: ������� ������� ������ ��������� (he),
	     �� ������� �������� ����� (he2). plural2 � ����������� �� ������������� ����� (���� �����, ��������, "�����",
	     �� ���� ����� ������ ���������� �������� �������� �� ������������� �����).
    walkto - ��������� ��� ����������� �� ����� "���� �" (����? ����?). ��������� ����� � ������� �����.
    defaultaction - ������������� �� ���� ��������� � ����, ��� ������� �� ������ ������ ���������. �������� "���������" (����? ���?).
    capitalized - ����� �� ������ ��� � ������� �����. ��������� ����� � �������� �� ������ �������.
	          �� ���� �� ������� true, �� ������� ������ ��������� � ������, ��� ���� ����� �����. ��������: "��������� ��������".
    killaction - ������������ ������ � DST �� ���� ���������, ������� �������� ����� ���������. � ���� ��� ����� ���������� � ����������
		 ���� "��� ���� (���? ���?)", �� ���� ��� ������������ �����.
	������ ��������� �������� ���� ����� ������������ �� ������: 1) he, 2) he2, 3) she, 4) it, 5) plural, 6) plural2.
	������ walkto, defaultaction � killaction ����� ������������ 0 ��� 1.
	0 �������� ������� ���������. �� ��, ��� �� ������� �������� �����. �������� �� ����������������. ������������ �������� �� testname.
	1 �������� "�� ��, ��� � ������� �����", �.�. val. ����� �� ����������� ���� � �� �� ������ (val) ����� ������ ������� ��������.
	
	��������: 
	RegisterRussianName("RESEARCHLAB2","������������ ���������",1,"������������� ���������",1)
	������ ���� ������� 1, ��� �������� "he".
	������ defaultaction ������� 1, ��� �������� ���������� val, �.�. "������������ ���������".
]]
function GLOBAL.RegisterRussianName(key,val,gender,walkto,defaultaction,capitalized,killaction)
	local oldval=STRINGS.NAMES[string.upper(key)]
	STRINGS.NAMES[string.upper(key)]=val
	GLOBAL.LanguageTranslator.languages.ru["STRINGS.NAMES."..string.upper(key)] = val
	if gender and gender~=0 then 
		if (genders_reg[gender]) then
			t.NamesGender[genders_reg[gender]][string.lower(key)]=true
		--else
		--	print error............
		end
	end
	if walkto or defaultaction or killaction then
		if (walkto==1) then walkto=val end
		if (defaultaction==1) then defaultaction=val end
		if (killaction==1) then killaction=val end
		t.RussianNames[val]={}
		if walkto and walkto~=0 then t.RussianNames[val]["WALKTO"]=walkto end
		if defaultaction and defaultaction~=0 then t.RussianNames[val]["DEFAULTACTION"]=defaultaction end
		if killaction and killaction~=0 then t.RussianNames[val]["KILL"]=killaction end
	end
	if capitalized then t.ShouldBeCapped[string.lower(key)]=true end
end

