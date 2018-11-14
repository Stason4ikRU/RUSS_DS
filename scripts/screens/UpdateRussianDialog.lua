local t = mods.RussianLanguagePack


local Screen = require "widgets/screen"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"



local UpdateRussianDialog = Class(Screen, function(self,postfn,calledfromoptions)
	Screen._ctor(self, "UpdateRussianDialog")
	self.postfunction=postfn
	
	self:DoInit(calledfromoptions)
end)

--��������� ��� ���������� ������ �� t.ChaptersList � STRINGS
local function DoTranslateSTRINGStoRussian()
	for _,chapter in ipairs(t.ChaptersList) do if chapter.data then
		for _,record in ipairs(chapter.data) do if record.isupdated then
			local tags=string.split(record.tag,".")
			local str=STRINGS
			for i=2,#tags-1 do
				if str[tags[i]] then
					str=str[tags[i]]
				else
					str=nil
					break
				end
			end
			if str and str[tags[#tags]] then
				local tmp=record.rus:gsub("\\\"","\"")
				local tmp=tmp:gsub("\\n","\n")
				local tmp=tmp:gsub("\\r","")
				str[tags[#tags]]=tmp
				record.isupdated=false
			end
		end end
	end end
end


local function BuildNewPO(filename,potype)
	local poheader="# "..t.SteamURL.."\n".."# ������ "..t.modinfo.version..[[


msgid ""
msgstr ""
"Project-Id-Version: ������� ���� Don't Starve\n"
"Last-Translator: Some1 <Some1@email.ua>\n"
"POT Version: 2.0\n"

]]
		
	local f = assert(io.open(t.StorePath..filename,"w"))
	f:write(poheader.."\n\n")
	for i,chapter in ipairs(t.ChaptersList) do
		if potype==chapter.potype then --������ 18 ���� - ��� ��������� PO, ��� ����� ��� ROG
			if chapter.data then
				f:write("\n\n# ------------------------------------------------------------------------------ ����� "..chapter.name.."\n\n")
				for _,record in ipairs(chapter.data) do
					local adder=""
					if record.disabled or record.rus==record.eng then
						adder="~"
					end
					f:write(adder.."#. "..record.tag.."\n")
					f:write(adder.."msgctxt \""..record.tag.."\"\n")
					f:write(adder.."msgid \""..record.eng.."\"\n")
					f:write(adder.."msgstr \""..record.rus.."\"\n\n")
				end
			end
		end
	end
	if potype=="main" then --������ ��� ��������� PO �����
		if t.ShouldBeCapped then --������� ����, ������������ � ��������� ����
			f:write("\n\n\n# ------------------------------------------------------------------------------ ������ ���������� � ��������� �����\n\n")
			for v,i in pairs(t.ShouldBeCapped) do
				f:write("#"..v:upper().."\n")
			end
			f:write("\n\n")
		end

		if t.NamesGender then --������� ���, ��������������� �� �����.
			f:write("\n\n\n# ------------------------------------------------------------------------------ ��� � ����� ���������\n")
			f:write("\n# �������:\n") --���, ��� ���� ��� - ������� ������
			for v,i in pairs(t.NamesGender["he"]) do
				f:write("#"..v:upper().."\n")
			end
			f:write("\n# ������� 2 �����:\n") --���, ��� ���� ��� - �������� �������
			for v,i in pairs(t.NamesGender["he2"]) do
				f:write("#"..v:upper().."\n")
			end
			f:write("\n# �������:\n")
			for v,i in pairs(t.NamesGender["she"]) do
				f:write("#"..v:upper().."\n")
			end
			f:write("\n# �������:\n")
			for v,i in pairs(t.NamesGender["it"]) do
				f:write("#"..v:upper().."\n")
			end
			f:write("\n# ������������� �����:\n")
			for v,i in pairs(t.NamesGender["plural"]) do
				f:write("#"..v:upper().."\n")
			end
			f:write("\n# ������������� ����� 2 �����:\n")
			for v,i in pairs(t.NamesGender["plural2"]) do
				f:write("#"..v:upper().."\n")
			end
		end

		for action,actiontable in pairs(t.ActionsToSave) do --������� ������� ��������

			f:write("\n\n\n# ------------------------------------------------------------------------------ �������� "..string.lower(action).."\n\n")
			for _,record in pairs(actiontable) do
				local s1
				if action=="DEFAULTACTION" then
					s1="#������� "
				elseif action=="WALKTO" then
					s1="#���� � "
				elseif action=="KILL" then
					s1="#�� ��� ���� "
				else
					s1="#"..(STRINGS.ACTIONS[action] or "").." "
				end
				s1=s1..record.trans
				local len=#s1
				while len<56 do
					s1=s1.."\t"
					len=len+8
				end
				s1=s1..tostring(record.orig)--STRINGS.NAMES[item]
				len=#tostring(record.orig)--STRINGS.NAMES[item]
				while len<48 do
					s1=s1.."\t"
					len=len+8
				end
				s1=s1..record.pth.."\n"
				f:write(s1)
			end
		end
	end
	f:close()
end


function UpdateRussianDialog:DoInit(calledfromoptions)

	--darken everything behind the dialog
    self.black = self:AddChild(Image("images/global.xml", "square.tex"))
    self.black:SetVRegPoint(ANCHOR_MIDDLE)
    self.black:SetHRegPoint(ANCHOR_MIDDLE)
    self.black:SetVAnchor(ANCHOR_MIDDLE)
    self.black:SetHAnchor(ANCHOR_MIDDLE)
    self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
    self.black:SetTint(0,0,0,.75)	
    
    self.root = self:AddChild(Widget("ROOT"))--self.root = self.scaleroot:AddChild(Widget("root"))
    self.root:SetScale(0.9)
    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0,0,0)
    self.bg = self.root:AddChild(Image("images/fepanels.xml", "panel_saveslots.tex"))
    self.bg:SetScale(1.1,1)

	
	--title	
    self.title = self.root:AddChild(Text(TITLEFONT, 40))
    self.title:SetPosition(0, 212, 0)
    self.title:SetString("���������� �������� �����������")

    self.counttext = self.root:AddChild(Text(BODYTEXTFONT, 23))
    self.counttext:SetPosition(0, 172-5, 0)
    self.counttext:SetString("����� ���������� ���������: 0")

	--text

	self.text={}

	t.ChaptersList=t.ChaptersListInit()
	local linescount=14
	
	for i=1,linescount do
		table.insert(self.text,self.root:AddChild(Text(BODYTEXTFONT, 23)))
		self.text[i]:SetPosition(75, 145-i*25, 0)
		self.text[i]:SetVAlign(ANCHOR_TOP)
		self.text[i]:SetHAlign(ANCHOR_LEFT)
		self.text[i]:SetString("")
		self.text[i]:EnableWordWrap(true)
		self.text[i]:SetRegionSize(500, 30)
		self.text[i]:SetColour(.7,.7,.7,1-1/linescount/linescount*i*i*0.9)
	end
	self.text[1]:SetColour(1,1,1,1)

--[[	for i=1,#t.ChaptersList do
		table.insert(self.text,self.root:AddChild(Text(BODYTEXTFONT, 23)))
		self.text[i]:SetPosition(75, 205-i*22, 0)
		self.text[i]:SetVAlign(ANCHOR_TOP)
		self.text[i]:SetHAlign(ANCHOR_LEFT)
		self.text[i]:SetString(t.ChaptersList[i].text)
		self.text[i]:EnableWordWrap(true)
		self.text[i]:SetRegionSize(500, 30)
		if i>1 then
			self.text[i]:SetColour(.5,.5,.5,1)
		else
			self.text[i]:SetColour(1,.5,.5,1)
		end
	end]]
  
	self.wasclosed=false

	self.cb = function()
		self.wasclosed=true
		TheFrontEnd:PopScreen()
	end

	self.CloseButton = self.root:AddChild(ImageButton())
	self.CloseButton:SetPosition(2, -250) 
	self.CloseButton:SetScale(0.8) 
	self.CloseButton:SetText("��������")
	self.CloseButton:SetOnClick(self.cb)

	self.default_focus = self.CloseButton

	self.Info = self.root:AddChild(ImageButton("images/ui.xml", "button_long.tex", "button_long_over.tex", "button_long_disabled.tex"))
	self.Info:SetPosition(-132, -241)
	self.Info:SetText("� ���������")
	self.Info:SetScale(0.6)
	self.Info:SetOnClick( function()
		local PopupDialogScreen = require "screens/popupdialog"
	        TheFrontEnd:PushScreen(PopupDialogScreen("����������� ���� "..t.modinfo.version, russianmoddescription,
			{{text="�������� ����", cb = function() VisitURL(t.SteamURL) end},
			 {text=STRINGS.UI.CONTROLSSCREEN.CLOSE, cb = function() TheFrontEnd:PopScreen() end}}))
	end )

	self.ToSettings = self.root:AddChild(ImageButton("images/ui.xml", "button_long.tex", "button_long_over.tex", "button_long_disabled.tex"))
	if calledfromoptions then
		self.ToSettings:Disable()
	end
	self.ToSettings:SetPosition(132, -241)
	self.ToSettings:SetText("���������")
	self.ToSettings:SetScale(0.6)
	self.ToSettings:SetOnClick( function()
		local LanguageOptions=require "screens/LanguageOptions"
		TheFrontEnd:PushScreen(LanguageOptions())
	end )

	--���������� � ����������
	self.Info:SetFocusChangeDir(MOVE_RIGHT, self.CloseButton)
	self.CloseButton:SetFocusChangeDir(MOVE_LEFT, self.Info)
	self.CloseButton:SetFocusChangeDir(MOVE_RIGHT, self.ToSettings)
	self.ToSettings:SetFocusChangeDir(MOVE_LEFT, self.CloseButton)


	local step=0
	local downloadlog=""


	--��������� ����� �� PO �����
	local function loadPO(pofilename)
		local CurrentChapter=nil
		local f=io.open(t.StorePath..pofilename,"r")
		if f then for line in f:lines() do
			line=escapeR(line)
			if CurrentChapter then
				if string.sub(line,1,10)=="#. STRINGS" then --��������� ��������� ������
					t.ChaptersList[CurrentChapter].data=t.ChaptersList[CurrentChapter].data or {}
					local tmp=string.sub(line,4)
					if tmp then
						tmp=escapeR(tmp)
						table.insert(t.ChaptersList[CurrentChapter].data,{tag=tmp})
					end

				elseif  string.sub(line,1,11)=="~#. STRINGS" then --���������� �� �������������� ������
					t.ChaptersList[CurrentChapter].data=t.ChaptersList[CurrentChapter].data or {}
					local tmp=string.sub(line,5)
					if tmp then
						tmp=escapeR(tmp)
						table.insert(t.ChaptersList[CurrentChapter].data,{tag=tmp,disabled=true})
					end
				end
				if string.sub(line,1,6)=="msgstr" or string.sub(line,1,7)=="~msgstr" then --��� ������� ����� ��� ����� ��������� �������� � ������� ����� ������
					local tmp=string.match(line,"\"(.*)\"")
					if tmp and t.ChaptersList[CurrentChapter].data then
						t.ChaptersList[CurrentChapter].data[#t.ChaptersList[CurrentChapter].data].rus=tmp
					end
				end
				if string.sub(line,1,5)=="msgid" or string.sub(line,1,6)=="~msgid" then --��� ���������� ����� ��� ����� ��������� �������� � ������� ����� ������
					local tmp=string.match(line,"\"(.*)\"")
					if tmp and t.ChaptersList[CurrentChapter].data then
						t.ChaptersList[CurrentChapter].data[#t.ChaptersList[CurrentChapter].data].eng=tmp
					end
				end
			end
			if string.sub(line,1,7)=="# -----" and string.find(line,"�����") then --���������� ����� �����
				local tmp=string.match(line,"����� (.+)$")
				if tmp and tmp~="" then
					CurrentChapter=nil
					for i,v in ipairs(t.ChaptersList) do
						if v.name==tmp then
							CurrentChapter=i
							break
						end
					end
				end
			end
		end f:close() end
	end
	loadPO(t.MainPOfilename)	--���������� ������� �� �������� PO
	if IsDLCEnabled and IsDLCEnabled(REIGN_OF_GIANTS) then
		loadPO(t.ROG_POfilename)		--���������� ������� PO ��� ROG
	end

	local _utf8=require "1251"
	local function convertfromutf8(data, donotmaskquotes)
		local translations={}
		local isutf8=true
		local isfirst=true
		local data1=string.split(data,"\r\n")
		for _,line in ipairs(data1) do
			if isutf8 then
				local line2=""
				for uchar in string.gfind(line, "([%z\1-\127\194-\244][\128-\191]*)") do
					if isfirst and uchar~="\239\187\191" then
						isutf8=false
						line2=line
						break
					end
					isfirst=false
				
		        		if #uchar==1 then
						line2=line2..uchar
					elseif #uchar==2 then
						local res=(uchar:byte(1)-0xC0)*0x40+uchar:byte(2)-0x80
						if _utf8[res] then line2=line2..string.char(_utf8[res]) end
--					else poheader=poheader.."*"--"["..uchar.." - "..line.."]"
					end
				end
				line=line2
		        end
			if line~="" and line~="��������! ���� �������, ��������, ��� �� �����." then
				if not donotmaskquotes then
					line=line:gsub("([^\\])\"","%1\\\"") --���������� ������� � ������� ������
				end
				table.insert(translations,line) --��������� ������
			elseif line=="��������! ���� �������, ��������, ��� �� �����." then
				break
			end
		end		
		return translations
	end

	--����������� ����������� ���������
	local function changestext(num) 
		local str="�"
		while num>100 do num=num-100 end
		if num>20 then while num>10 do num=num%10 end end
		if num==1 then str="�" elseif num==2 or num==3 or num==4 then str="�" end
		return " ��������"..str
	end
	--��������� ���� ������, ������������ ��� ������ ��������� � �������� ��������� � �.�.
	local function deepcompare(t1,t2,ignore_mt)
		local ty1 = type(t1)
		local ty2 = type(t2)
		if ty1 ~= ty2 then return false end
		-- non-table types can be directly compared
		if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
		-- as well as tables which have the metamethod __eq
		local mt = getmetatable(t1)
		if not ignore_mt and mt and mt.__eq then return t1 == t2 end
		for k1,v1 in pairs(t1) do
			local v2 = t2[k1]
			if v2 == nil or not deepcompare(v1,v2) then return false end
		end
		for k2,v2 in pairs(t2) do
			local v1 = t1[k2]
			if v1 == nil or not deepcompare(v1,v2) then return false end
		end
		return true
	end

	local ChangesCounter=0
	local FoundSomeDifference=false
	--�������, � ������� ������� ���������� ��� �������� �� �����������
	local function DoDownload(...)
		if self.wasclosed then
			return nil
		end
		local url=t.SteamURL
		local params="/download?format=t&enc=UTF-8"
		if ... and t.ChaptersList[step].id=="192218" then --��������� �������������� ����� � ����������� � �.�.
			local CurrentTitle="���������� �������� �����������"
			if t.ChaptersList[step].potype=="ROG" then CurrentTitle="���������� ����������� ROG" end
			if self.title:GetString()~=CurrentTitle then self.title:SetString(CurrentTitle) end
			--������� ����� � �������� ����
			for i=#self.text,2,-1 do
				self.text[i]:SetString(self.text[i-1]:GetString())
			end
			self.text[1]:SetString(t.ChaptersList[step].text)

			local tbl={...}
			if tbl and #tbl==3 and tbl[3]==200 then --�������� ����� �� ������� � �� �����������
				local data=convertfromutf8(tbl[1],true)
				--������ ������ ��� ������������ ����������
				local oldshouldbecapped=t.ShouldBeCapped
				local oldrussiannames=t.RussianNames

				t.LoadCappedNames(data) --��������� �����, ������� ������ ���������� ����������. ������ ���� ����� ����������� �������� � STRINGS
				t.LoadNamesGender(data) --��������� ������ ���, ��������������� �� ���� � �����
				t.LoadFixedNames(false,data) --��������� ���������� ���������

				if not deepcompare(oldshouldbecapped,t.ShouldBeCapped) then FoundSomeDifference=true end
				if not deepcompare(oldrussiannames,t.RussianNames) then FoundSomeDifference=true end
			end
		elseif ... then --������ ��� ����� ���� ������ �� ����� ������ ��� � ����� ������ ���
			downloadlog=downloadlog.."\n����� "..t.ChaptersList[step].name.." ("..t.ChaptersList[step].text..")\n"
			local CurrentTitle="���������� �������� �����������"
			if t.ChaptersList[step].potype=="ROG" then CurrentTitle="���������� ����������� ROG" end
			if self.title:GetString()~=CurrentTitle then self.title:SetString(CurrentTitle) end
			--������� ����� � �������� ����
			for i=#self.text,2,-1 do
				self.text[i]:SetString(self.text[i-1]:GetString())
			end
			self.text[1]:SetString(t.ChaptersList[step].text)

			local tbl={...}
			if tbl and #tbl==3 and tbl[3]==200 and step>0 and step<=#t.ChaptersList then --�������� ����� �� ������� � �� �����������
				local translations=convertfromutf8(tbl[1])
				if translations then --������� ������������� � ������ ansi
--					downloadlog=downloadlog.."�������: "..#translations.."\n"
					if #translations~=#t.ChaptersList[step].data then --������ ���������� �������
						self.text[1]:SetString(t.ChaptersList[step].text.."  ~  �� ��������� ���-�� �������")
						--[[if false then --���������� ��� ������ ���� � �������, � ������� �� ���������
							local f=io.open(t.StorePath.."error_"..t.ChaptersList[step].name..".txt","w")
							for i=1,#translations do
								f:write(translations[i].."\n")
								if t.ChaptersList[step].data[i] and translations[i]==t.ChaptersList[step].data[i].rus then f:write("OK") else f:write("������") end
								f:write("\n\n")
							end
							f:close()
						end --]]
					else --���������� ���������� �������
						local DifferenceCounter=0
						for i=1,#translations do --���� ���������� ������������ � ��������
							translations[i]=string.gsub(translations[i],"\\(%d%d?%d?)",function(val)
								return string.char(tonumber(val))
							end)
							if translations[i]~=t.ChaptersList[step].data[i].rus then
								downloadlog=downloadlog.."\t"..t.ChaptersList[step].data[i].tag.."\n\t\tpo: "..t.ChaptersList[step].data[i].rus.."\n\t\t����: "..translations[i].."\n"
								DifferenceCounter=DifferenceCounter+1
								t.ChaptersList[step].data[i].rus=translations[i]
								t.ChaptersList[step].data[i].disabled=translations[i]==t.ChaptersList[step].data[i].eng
								t.ChaptersList[step].data[i].isupdated=true
							end
						end
						if DifferenceCounter~=0 then --���� ������������
							self.text[1]:SetString(t.ChaptersList[step].text.."  ~  "..DifferenceCounter..changestext(DifferenceCounter))
							FoundSomeDifference=true
							ChangesCounter=ChangesCounter+DifferenceCounter
							self.counttext:SetString("����� ���������� ���������: "..tostring(ChangesCounter))
						else -- �� ���������
--							self.text[1]:SetString(t.ChaptersList[step].text.." � ��� ���������")
							downloadlog=downloadlog.."��� ���������\n"

						end
					end
				else --��������� ������������� � ������ ansi
					self.text[1]:SetString(t.ChaptersList[step].text.."  ~  ������")
				end
			else  --������ ������ ������ ��� �� ������ ������ ������.
				self.text[1]:SetString(t.ChaptersList[step].text.."  ~  ������")
				downloadlog=downloadlog.."������ �������\n"
			end 
		end
		step=step+1
		if step<=#t.ChaptersList then
			TheSim:QueryServer( url..t.ChaptersList[step].id..params, DoDownload, "GET" )
--		elseif step==#t.ChaptersList+1 then --��������� �������������� ������� ����� � ����������� � �.�.
--			TheSim:QueryServer( url.."192218"..params, DoDownload, "GET" )
		else
			Profile:SetLocalizaitonValue("update_is_allowed", "false")
			local date=os.date("*t")
			Profile:SetLocalizaitonValue("last_update_date", tostring(date.day.."."..date.month.."."..date.year))
			if FoundSomeDifference then
				DoTranslateSTRINGStoRussian()
				BuildNewPO(t.MainPOfilename,"main")
				if IsDLCEnabled and IsDLCEnabled(REIGN_OF_GIANTS) then
					BuildNewPO(t.ROG_POfilename,"ROG")
				end
			end
			local datestring=date.day.."."..date.month.."."..date.year.." "..date.hour..":"..date.min..":"..date.sec
			self.CloseButton:SetText("����������")
			local f=io.open(t.StorePath..t.UpdateLogFileName,"r") --������ ��, ��� ���� � ����
			local olddata={}
			if f then
				for line in f:lines() do
					table.insert(olddata,escapeR(line).."\n")
				end
				f:close()
			end
			f=assert(io.open(t.StorePath..t.UpdateLogFileName,"w")) --����� ��, ��� ���� � ����� ������
			for _,line in ipairs(olddata) do
				f:write(line)
			end
			f:write("\n\n\n\n\n------------------------------------------------------------------------------------------\n")
			f:write("-------------------------------------"..datestring.."----------------------------------\n")
			f:write("------------------------------------------------------------------------------------------\n\n")
			f:write(downloadlog)
			f:close()
			if self.postfunction and type(self.postfunction)=="function" then self.postfunction() end
		end			
	end
	DoDownload() --�������� �������� �� �����������
end



function UpdateRussianDialog:OnControl(control, down)

    if UpdateRussianDialog._base.OnControl(self,control, down) then return true end
    
    if control == CONTROL_CANCEL and not down then    
            self.cb()
            return true
    end
end


function UpdateRussianDialog:Close()
	self.wasclosed=true
	TheFrontEnd:PopScreen(self)
end

function UpdateRussianDialog:GetHelpText()
	local controller_id = TheInput:GetControllerID()
	local t = {}
--	if #self.buttons > 1 and self.buttons[#self.buttons] then
        table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.OPTIONS.CLOSE)	
  --  end
	return table.concat(t, "  ")
end

return UpdateRussianDialog