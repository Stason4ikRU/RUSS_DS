local t = mods.RussianLanguagePack


require("constants")
local Widget = require "widgets/widget"
local Screen = require "widgets/screen"
local ImageButton = require "widgets/imagebutton"
local Spinner = require "widgets/spinner"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UpdateRussianDialog = require "screens/UpdateRussianDialog"

local TranslationTypeSave=nil

local LanguageOptions = Class(Screen, function(self)
    Widget._ctor(self, "LanguageOptions")
	self.bg = self:AddChild(Image("images/ui.xml", "bg_plain.tex"))
	if rawget(_G,"TintBackground") then TintBackground(self.bg) else
		if t.ROG_Installed and not t.SW_Installed then
			self.bg:SetTint(BGCOLOURS.PURPLE[1],BGCOLOURS.PURPLE[2],BGCOLOURS.PURPLE[3], 1)
		elseif t.SW_Installed then
			self.bg:SetTint(BGCOLOURS.TEAL[1],BGCOLOURS.TEAL[2],BGCOLOURS.TEAL[3], 1)
		else
			self.bg:SetTint(BGCOLOURS.RED[1],BGCOLOURS.RED[2],BGCOLOURS.RED[3], 1)
		end
	end

	self.bg:SetVRegPoint(ANCHOR_MIDDLE)
	self.bg:SetHRegPoint(ANCHOR_MIDDLE)
	self.bg:SetVAnchor(ANCHOR_MIDDLE)
	self.bg:SetHAnchor(ANCHOR_MIDDLE)
	self.bg:SetScaleMode(SCALEMODE_FILLSCREEN)
    
	self.scaleroot = self:AddChild(Widget("scaleroot"))
	self.scaleroot:SetVAnchor(ANCHOR_MIDDLE)
	self.scaleroot:SetHAnchor(ANCHOR_MIDDLE)
	self.scaleroot:SetPosition(0,0,0)
	self.scaleroot:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.root = self.scaleroot:AddChild(Widget("root"))
	self.root:SetScale(.9)


	local left_col =-RESOLUTION_X*.25 - 70
	local right_col = RESOLUTION_X*.25 - 130
	local buttonshift=30

	self.ControlButtonPressed=false
    
	self.backbutton = self.root:AddChild(ImageButton("images/ui.xml", "button_long.tex", "button_long_over.tex", "button_long_disabled.tex"))
	self.backbutton:SetPosition(left_col, -280-buttonshift, 0)
	self.backbutton:SetText("�����")
	self.backbutton:SetOnClick( function() self:Cancel() end )
	self.backbutton:SetTextSize(36)


	self.UpdateNowButton = self.root:AddChild(ImageButton("images/ui.xml", "button_long.tex", "button_long_over.tex", "button_long_disabled.tex"))
	self.UpdateNowButton:SetPosition(left_col, -210-buttonshift, 0)
	self.UpdateNowButton:SetText("�������� ������")
	self.UpdateNowButton.text:SetColour(0,0,0,1)
	self.UpdateNowButton:Disable()

	local function UpdateLogonupdate()
		local tmp1,tmp2
		if self.HistoryButton:GetText()~="������� ���������" then --������ ������ ������������ ��� ���������.
			tmp1=self.CurrentLogRecord
			tmp2=self.logpage
		end
		self.UpdateLog={}
		self.logtextlines=0 --���������� ��������� �����, � ������� ������������ ��� (�� ���� ��������� ������)
		self:LoadUpdateLog() --�������� ��� ������ � UpdateLog
		if self.HistoryButton:GetText()~="������� ���������" then --������ ������ ������������ ��� ���������.
			self.CurrentLogRecord=self.OldLogRecord or #self.UpdateLog
			self.OldLogRecord=tmp1
			self.logpage=self.Oldlogpage or 1
			self.Oldlogpage=tmp2
			self.HistoryButton:SetText("������� ���������")
		end
		self:ChangeLogRecord(0)
		self:UpdatePageNumbers()
	end

	self.UpdateNowButton:SetOnClick( function()
		TheFrontEnd:PushScreen(UpdateRussianDialog(UpdateLogonupdate,true))
	end )
	self.UpdateNowButton:SetFont(BUTTONFONT)
	self.UpdateNowButton:SetTextSize(36)

	self.OldLogRecord=nil
	self.Oldlogpage=nil
	self.HistoryButton = self.root:AddChild(ImageButton("images/ui.xml", "button_long.tex", "button_long_over.tex", "button_long_disabled.tex"))
	self.HistoryButton:SetPosition(left_col, -140-buttonshift, 0)
--	self.HistoryButton:SetText("������� ���")
	self.HistoryButton:SetText("������� ���������")
	self.HistoryButton:Disable()
	local function HistoryButtonClick()
		if self.HistoryButton:GetText()=="������� ���������" then
			local tmp1=self.CurrentLogRecord
			local tmp2=self.logpage

			self.UpdateLog={}
			self.logtextlines=0 --���������� ��������� �����, � ������� ������������ ��� (�� ���� ��������� ������)
			self:LoadHistory()
			self.CurrentLogRecord=self.OldLogRecord or #self.UpdateLog
			self.OldLogRecord=tmp1
			self.logpage=self.Oldlogpage or 1
			self.Oldlogpage=tmp2
			self:ChangeLogRecord(0)
			self:UpdatePageNumbers()
			self.HistoryButton:SetText("������� ���")
		else
			local tmp1=self.CurrentLogRecord
			local tmp2=self.logpage
			self.UpdateLog={}
			self.logtextlines=0 --���������� ��������� �����, � ������� ������������ ��� (�� ���� ��������� ������)
			self:LoadUpdateLog() --�������� ��� ������ � UpdateLog
			self.CurrentLogRecord=self.OldLogRecord or #self.UpdateLog
			self.OldLogRecord=tmp1
			self.logpage=self.Oldlogpage or 1
			self.Oldlogpage=tmp2
			self:ChangeLogRecord(0)
			self:UpdatePageNumbers()
			self.HistoryButton:SetText("������� ���������")
		end
	end
	self.HistoryButton:SetOnClick( HistoryButtonClick )
	self.HistoryButton:SetTextSize(36)


	self.URLButton = self.root:AddChild(ImageButton("images/ui.xml", "button_long.tex", "button_long_over.tex", "button_long_disabled.tex"))
	self.URLButton:SetPosition(left_col, -70-buttonshift, 0)
	self.URLButton:SetText("�������� �������")
	self.URLButton:SetOnClick( function() VisitURL(t.SteamURL) end )
	self.URLButton:SetTextSize(36)


	--set up the device spinner
    self.updateoptionspanel = self.root:AddChild(Widget("updateoptionspanel"))
    self.updateoptionspanel:SetPosition(left_col,135,0)
    self.updateoptionspanelbg = self.updateoptionspanel:AddChild(Image("images/globalpanels.xml", "panel.tex"))

   	self.updateoptionspanelbg:SetPosition(0,5)
	self.updateoptionspanelbg:SetScale(0.8,-0.80, 1)

    self.updateoptionstitle = self.updateoptionspanel:AddChild(Text(TITLEFONT, 50))
    self.updateoptionstitle:SetHAlign(ANCHOR_MIDDLE)
    self.updateoptionstitle:SetPosition(0, 140, 0)
    self.updateoptionstitle:SetRegionSize( 400, 70 )
    self.updateoptionstitle:SetString("�����������")

    self.version = self.updateoptionspanel:AddChild(Text(UIFONT, 25))
    self.version:SetPosition(0, 100, 0)
    self.version:SetString("������: "..t.modinfo.version)

    self.updateoptionstext = self.updateoptionspanel:AddChild(Text(UIFONT, 34))
    self.updateoptionstext:SetHAlign(ANCHOR_LEFT)
    self.updateoptionstext:SetRegionSize( 320, 70 )
    self.updateoptionstext:SetPosition(7, 55, 0)
    self.updateoptionstext:SetString("������������� ����������")


	local period=Profile:GetLocalizaitonValue("update_frequency")
	if not period then --���� ��� ������ � �������, �� ������ �� ��������� ��� � ������
		period=RusUpdatePeriod and RusUpdatePeriod[3] or "OncePerWeek"
		Profile:SetLocalizaitonValue("update_frequency",period)
	end

	

	self.updateoptions={	{text="��� ������ �������",data=0,description="������������ �� ������������� ������������, ���� �� �� ����������� ��������� ����."},
				{text="��� � �����",data=1,description="�� ������������� ������������, ���� �� �� ����������� ��������� ����."},
				{text="��� � ������",data=2,description="� ����� ���, ���� ������� ������� �����������. ��������� ���� ������ ������������."},
				{text="��� � �����",data=3,description="����� ��������� ���� �������, ���� ��� ���������� ������������ ��� �������� ���� ������ ���������� �����������."},
				{text="�� ���������",data=4,description="�� ������ ������� �������� ������� ��������������, ����� �� ������ \"�������� ������\" ����."}}
	


	self.updateoptionsspinner = self.updateoptionspanel:AddChild(Spinner( self.updateoptions, 350 ))
	for i,v in ipairs(RusUpdatePeriod) do
		if v==period then
			self.updateoptionsspinner:SetSelectedIndex(i)
		end
	end
	self.updateoptionsspinner:SetPosition(0, 5, 0)
	self.updateoptionsspinner:SetTextColour(0,0,0,1)
	self.updateoptionsspinner.OnChanged =
		function( _, data )
			self.UpdateOptionsDescriptionText:SetString(self.updateoptions[self.updateoptionsspinner:GetSelectedIndex()].description)
			Profile:SetLocalizaitonValue("update_frequency",RusUpdatePeriod[self.updateoptionsspinner:GetSelectedIndex()])
		end
	self.updateoptionsspinner:SetWrapEnabled(true)
	self.updateoptionsspinner:Disable()

                                                 


	self.UpdateOptionsDescriptionText = self.updateoptionspanel:AddChild(Text(BODYTEXTFONT, 25))
	self.UpdateOptionsDescriptionText:SetColour(.6,.6,.6,1)
	self.UpdateOptionsDescriptionText:SetVAlign(ANCHOR_TOP)
	self.UpdateOptionsDescriptionText:SetHAlign(ANCHOR_LEFT)
	self.UpdateOptionsDescriptionText:SetPosition(7, -240, 0)
	self.UpdateOptionsDescriptionText:SetRegionSize(320, 400)
	self.UpdateOptionsDescriptionText:EnableWordWrap(true)
	self.UpdateOptionsDescriptionText:SetString(self.updateoptions[self.updateoptionsspinner:GetSelectedIndex()].description)

	
	--������� ������� ������������ ������ ��� ������� ������
--[[	self.updateoptionsspinner:SetFocusChangeDir(MOVE_DOWN, self.URLButton)
	self.URLButton:SetFocusChangeDir(MOVE_UP, self.updateoptionsspinner)
	self.UpdateNowButton:SetFocusChangeDir(MOVE_DOWN, self.backbutton)
	self.backbutton:SetFocusChangeDir(MOVE_UP, self.UpdateNowButton)
	if not kleifileexists(t.StorePath.."history.txt") then
		self.HistoryButton:Disable()
		self.URLButton:SetFocusChangeDir(MOVE_DOWN, self.UpdateNowButton)
		self.UpdateNowButton:SetFocusChangeDir(MOVE_UP, self.URLButton)
	else
		self.URLButton:SetFocusChangeDir(MOVE_DOWN, self.HistoryButton)
		self.UpdateNowButton:SetFocusChangeDir(MOVE_UP, self.HistoryButton)
		self.HistoryButton:SetFocusChangeDir(MOVE_DOWN, self.UpdateNowButton)
		self.HistoryButton:SetFocusChangeDir(MOVE_UP, self.URLButton)
	end]]
	self.updateoptionsspinner:SetFocusChangeDir(MOVE_DOWN, self.URLButton)
	self.URLButton:SetFocusChangeDir(MOVE_DOWN, self.backbutton)
	self.backbutton:SetFocusChangeDir(MOVE_UP, self.URLButton)
	
	self.logspanel = self.root:AddChild(Widget("logspanel"))
	self.logspanel:SetPosition(right_col,0,0)
	self.logspanelbg = self.logspanel:AddChild(Image("images/fepanels.xml", "panel_controls.tex"))
	self.logspanelbg:SetScale(1,1.07,1)
	self.logspanelbg:SetPosition(0,5,1)


	self.logstitle = self.logspanel:AddChild(Text(TITLEFONT, 50))
	self.logstitle:Hide()	
	self.logstitle:SetHAlign(ANCHOR_MIDDLE)
	self.logstitle1 = self.logspanel:AddChild(Text(TITLEFONT, 30))
	self.logstitle1:Hide()	
	self.logstitle2 = self.logspanel:AddChild(Text(TITLEFONT, 30))
	self.logstitle2:Hide()	


	self.UpdateLog={} --���� ��� �������� ����
	self.logtextlines=0 --���������� ��������� �����, � ������� ������������ ��� (�� ���� ��������� ������)
	self.logtext={} --������ �����-��������, ��������� ������ ��������
	self.logtextbg={}
	self.logpage=1 --������� �������� � ������� ������ ����
	self.logpages=0 --���������� ������� � ������� ������ ����


	self:LoadUpdateLog() --�������� ��� ������ � UpdateLog
	self.CurrentLogRecord=#self.UpdateLog --������� ���������� ����� ���� - ���������
	self:UpdateLogsTitle()




	self.tf3 = Widget("tf3")
	self.tf3:SetVAnchor(ANCHOR_MIDDLE)
	self.tf3:SetHAnchor(ANCHOR_MIDDLE)
	self.tf3:SetPosition(0,0,0)
	self.tf3:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.tf2 = self.tf3:AddChild(Widget("tf2"))
	self.tf2:SetScale(.9)
	self.tf1 = self.tf2:AddChild(Widget("tf1"))
	self.tf1:SetPosition(right_col,0,0)
	self.textfade = self.tf1:AddChild(Image("images/gradient.xml", "gradient.tex")) --���������� ������ ��� ������ ������� �����
	self.textfade:ScaleToSize(90,480,1)
	self.textfade:SetPosition(245,-25)


	self.logtextpagenumber={}
	for i=1,4 do
		self.logtextpagenumber[i]=self.logspanel:AddChild(Text(NUMBERFONT, 8+i*5))
		self.logtextpagenumber[i]:Hide()
		self.logtextpagenumber[i]:SetPosition(-205+i*(30), -295, 0)
		self.logtextpagenumber[i]:SetColour(0.4+i/10,0.4+i/10,0.4+i/10,1)
		self.logtextpagenumber[10-i]=self.logspanel:AddChild(Text(NUMBERFONT, 8+i*5))
		self.logtextpagenumber[10-i]:Hide()
		self.logtextpagenumber[10-i]:SetPosition(215-i*(30), -295, 0)
		self.logtextpagenumber[10-i]:SetColour(0.4+i/10,0.4+i/10,0.4+i/10,1)
	end
	self.logtextpagenumber[5]=self.logspanel:AddChild(Text(NUMBERFONT, 60))
	self.logtextpagenumber[5]:Hide()
	self.logtextpagenumber[5]:SetPosition(10, -295, 0)


	self.nextpage = self.logspanel:AddChild(ImageButton("images/ui.xml", "scroll_arrow.tex", "scroll_arrow_over.tex", "scroll_arrow_disabled.tex"))
	self.nextpage:Hide()
	self.nextpage:SetPosition(50, -295, 0)
	self.nextpage:SetOnClick( function() self:ChangeLogPage(1) end)
	self.nextpage:SetScale(0.5,0.35,1)
	
	self.prevpage = self.logspanel:AddChild(ImageButton("images/ui.xml", "scroll_arrow.tex", "scroll_arrow_over.tex", "scroll_arrow_disabled.tex"))
	self.prevpage:Hide()
	self.prevpage:SetPosition(-50, -295, 0)
	self.prevpage:SetScale(-0.5,0.35,1)
	self.prevpage:SetOnClick( function() self:ChangeLogPage(-1) end)	


	self:UpdateLogText() --������� ���� �����
	self:UpdatePageNumbers() --��������� ������ �������


	self.rightbutton = self.logspanel:AddChild(ImageButton("images/ui.xml", "scroll_arrow.tex", "scroll_arrow_over.tex", "scroll_arrow_disabled.tex"))
	self.rightbutton:Hide()
	self.rightbutton:SetPosition(340, 0, 0)
	self.rightbutton:SetOnClick( function() self:ChangeLogRecord(1) self:UpdatePageNumbers() end)
	
	self.leftbutton = self.logspanel:AddChild(ImageButton("images/ui.xml", "scroll_arrow.tex", "scroll_arrow_over.tex", "scroll_arrow_disabled.tex"))
	self.leftbutton:Hide()
	self.leftbutton:SetPosition(-340, 0, 0)
	self.leftbutton:SetScale(-1,1,1)
	self.leftbutton:SetOnClick( function() self:ChangeLogRecord(-1) self:UpdatePageNumbers() end)	
	
    
	self:ChangeLogRecord(0)

--	self.updateoptionsspinner:SetFocus()
--	self.default_focus = self.updateoptionsspinner
	self.default_focus = self.backbutton
	self.backbutton:SetFocus()

	self.urlbutton=ImageButton("images/eyebutton.xml", "eyebutton1.tex", "eyebutton2.tex", "eyebutton3.tex")
	self.urlbutton:SetPosition(-265,-12)
	self.urlbutton:SetScale(0.4)
	self.urlbutton:Hide()
	HistoryButtonClick()
end)


--��������� ������ ������� � ������ ��������� �� ���
function LanguageOptions:UpdatePageNumbers()
	if self.logpages>1 then
		self.logtextpagenumber[5]:SetString(tostring(self.logpage))
		if not self.logtextpagenumber[5].shown then self.logtextpagenumber[5]:Show() end
		for i=1,4 do
			if self.logpage-i>=1 then
				self.logtextpagenumber[5-i]:SetString(tostring(self.logpage-i))
				if not self.logtextpagenumber[5-i].shown then self.logtextpagenumber[5-i]:Show() end
			else
				if self.logtextpagenumber[5-i].shown then self.logtextpagenumber[5-i]:Hide() end
			end
			if self.logpage+i<=self.logpages then
				self.logtextpagenumber[5+i]:SetString(tostring(self.logpage+i))
				if not self.logtextpagenumber[5+i].shown then self.logtextpagenumber[5+i]:Show() end
			else
				if self.logtextpagenumber[5+i].shown then self.logtextpagenumber[5+i]:Hide() end
			end
		end
		if not self.nextpage.shown and self.logpage<self.logpages then self.nextpage:Show() end
		if not self.prevpage.shown and self.logpage>1 then self.prevpage:Show() end
	else
		for _,v in pairs(self.logtextpagenumber) do
			if v.shown then v:Hide() end
		end
		if self.nextpage.shown then self.nextpage:Hide() end
		if self.prevpage.shown then self.prevpage:Hide() end
	end
end


--������ ������ �������
function LanguageOptions:ChangeLogPage(dir)
	if #self.UpdateLog==0 then
		return nil
	end
	self.logpage=self.logpage+dir
	self:UpdatePageNumbers()
	if dir>0 then -- ������� �����
		if not self.prevpage.shown then
			self.prevpage:Show()
		end
		if self.logpage==self.logpages then
			self.nextpage:Hide()
		end
		self:UpdateLogText()
		self:UpdatePageNumbers()
	elseif dir<0 then-- ������� �����
		if not self.nextpage.shown then
			self.nextpage:Show()
		end
		if self.logpage==1 then
			self.prevpage:Hide()
		end
		self:UpdateLogText()
		self:UpdatePageNumbers()
	else
		if self.logpage>1 and not self.prevpage.shown then self.prevpage:Show() end
		if self.logpage<self.logpages and not self.nextpage.shown then self.nextpage:Show() end
	end

end




--��������� ������ � ���� �����
function LanguageOptions:UpdateLogText()
	local function clean_logtextbg(i)
		self.logtextbg[i]:SetSize(0,0)
		self.logtextbg[i]:SetTint(1,1,1,0)
		self.logtextbg[i].OnGainFocus=nil
		self.logtextbg[i].OnLoseFocus=nil
	end
	local function DoDownload(...)
		self.urlbutton:Enable()
		if ... then --������ ��� ����� ���� ������ �� ����� ������ ��� � ����� ������ ���
			local tbl={...}
			if tbl and #tbl==3 and tbl[3]==200 then --�������� ����� �� ������� � �� �����������
				local id=string.match(tbl[1],"<tr id='o(.-)'")
				local head=string.match(tbl[1],"action=\"/book/45556/(%d+)")
				if id and head then
					VisitURL(t.SteamURL..head.."/"..id)
				end
			end
		end
	end

	if #self.UpdateLog==0 then
		for i,text in ipairs(self.logtext) do
			if text.shown then
				clean_logtextbg(i)
				text:Hide()
			end
		end
		self.logpages=0
		return
	end
	if self.urlbutton and self.urlbutton.shown then self.urlbutton:Hide() end

	local starty=200 --��������� ���������� ������� �� ���������
	local endy=-260 --�������� ���������� ������� �� ���������
	local y=starty
	local linespacingbefore={22,12,10,12}
	local linespacingafter={12,12,10,12}
	local lineindent={-18,2,22,22}
	local logtextbgheight=linespacingafter[2]+linespacingafter[3]+linespacingafter[4]+linespacingbefore[3]+linespacingbefore[4]+11

	local colors={{.8,.8,1},{.7,.7,.7},{1,1,1},{1,1,1}}
	local i=1
	local log=self.UpdateLog[self.CurrentLogRecord]
	local s_chapter,s_tag,s_old,s_new,s_none=1,2,3,4,5
	local currentstringtype=s_chapter
	local currenttag=1

	local currentchapter=1 --������ �������� �� ������� ��������
	local page=1

	while i<=self.logtextlines do
		if y<=endy then
			y=starty
			page=page+1
		end
		if currentstringtype==s_chapter then
			if self.logstitle1:GetString()=="���������� ��" then --��� ����� ����������
				if page~=self.logpage and self.logtext[i].shown then
					self.logtext[i]:Hide()
					clean_logtextbg(i)
				elseif page==self.logpage then
					self.logtextbg[i]:SetPosition(lineindent[currentstringtype], y, 0)
					clean_logtextbg(i)
					self.logtext[i]:SetPosition(0, 0)
					self.logtext[i]:SetColour(colors[currentstringtype][1],colors[currentstringtype][2],colors[currentstringtype][3],1)
					self.logtext[i]:SetString(log.chapters[currentchapter].textname.." ("..log.chapters[currentchapter].name..")")
					if not self.logtext[i].shown then self.logtext[i]:Show() end
				end
				y=y-linespacingafter[currentstringtype]
				currentstringtype=s_tag
				y=y-linespacingbefore[currentstringtype]
			else  --��� ������ ������� ��������
				if page~=self.logpage and self.logtext[i].shown then
					self.logtext[i]:Hide()
					clean_logtextbg(i)
				elseif page==self.logpage then
					self.logtextbg[i]:SetPosition(0, y, 0)
					clean_logtextbg(i)
					self.logtext[i]:SetPosition(0, 0)
					self.logtext[i]:SetColour(.8,.8,.8,1)
					self.logtext[i]:SetString(log.chapters[currentchapter].firstline)
					if not self.logtext[i].shown then self.logtext[i]:Show() end
				end
				if #log.chapters[currentchapter].nextlines>0 then --���� � ������� ������ ������������
					y=y-23
					currentstringtype=s_tag
					currenttag=1
				else --���� ��� �����������
					if currentchapter<#log.chapters then --���� ���� ��� ������
						currentchapter=currentchapter+1
						y=y-35
					else
						currentstringtype=s_none
					end
				end
			end
		elseif currentstringtype==s_tag and self.logstitle1:GetString()=="������" then --��� ��������� ������ ������� ��������
			if page~=self.logpage and self.logtext[i].shown then
				self.logtext[i]:Hide()
				clean_logtextbg(i)
			elseif page==self.logpage then
				self.logtextbg[i]:SetPosition(12, y, 0)
				clean_logtextbg(i)
				self.logtext[i]:SetPosition(0, 0)
				self.logtext[i]:SetColour(.8,.8,.8,1)
				self.logtext[i]:SetString(log.chapters[currentchapter].nextlines[currenttag])
				if not self.logtext[i].shown then self.logtext[i]:Show() end
			end
			if currenttag<#log.chapters[currentchapter].nextlines then --���� ���� ��� ������ ������������
				y=y-23
				currenttag=currenttag+1
			else --��������� ������ ������������
				if currentchapter<#log.chapters then --���� ���� ��� ������
					currentchapter=currentchapter+1
					currentstringtype=s_chapter
					currenttag=1
					y=y-35
				else
					currentstringtype=s_none
				end
			end
		elseif currentstringtype==s_tag and self.logstitle1:GetString()=="���������� ��" then --��� ����� ����������
			if y-(logtextbgheight/2)<=endy then
				y=starty
				page=page+1
			end
			if page~=self.logpage and self.logtext[i].shown then
				self.logtext[i]:Hide()
				clean_logtextbg(i)
			elseif page==self.logpage then
				self.logtextbg[i]:SetPosition(0, y+11-logtextbgheight/2, 0)
				self.logtextbg[i]:SetSize(570, logtextbgheight)
				self.logtextbg[i]:SetTint(1,1,1,0)	                                    
				self.logtext[i]:SetPosition(lineindent[currentstringtype], -11+logtextbgheight/2, 0)
				self.logtext[i]:SetColour(colors[currentstringtype][1],colors[currentstringtype][2],colors[currentstringtype][3],1)
				self.logtext[i]:SetString(log.chapters[currentchapter].log[currenttag].tag)
				self.logtextbg[i]["tag"]=log.chapters[currentchapter].log[currenttag].tag
				self.logtextbg[i]["chapter"]=log.chapters[currentchapter].index
				self.logtextbg[i].OnGainFocus=function(self2)
					Widget.OnGainFocus(self2)
					self2:SetTint(1,1,1,.1)	
					if self.urlbutton then

						if self.urlbutton.parent then
							self.urlbutton.parent.children[self.urlbutton] = nil
						end
						self2:AddChild(self.urlbutton)
						if not self.ControlButtonPressed then
							self.urlbutton:SetOnClick( function() VisitURL(t.SteamURL..t.ChaptersList[self2.chapter].id.."?show=5&to="..self2.tag) end )
						else
							self.urlbutton:SetOnClick( function()
								TheSim:QueryServer( t.SteamURL..t.ChaptersList[self2.chapter].id.."?show=5&to="..self2.tag, DoDownload, "GET" )
								self.urlbutton:Disable()
							end )
						end
						if not self.urlbutton.shown then self.urlbutton:Show() end
					end
				end
				self.logtextbg[i].OnLoseFocus=function(self2)
					Widget.OnLoseFocus(self2)
					self2:SetTint(1,1,1,0)	
					if self.urlbutton then
						if self.urlbutton.parent==self2 then
							self.urlbutton.parent.children[self.urlbutton] = nil
							if self.urlbutton.shown then self.urlbutton:Hide() end
						end
					end
				end
				if not self.logtext[i].shown then self.logtext[i]:Show() end
			end
			y=y-linespacingafter[currentstringtype]
			currentstringtype=s_old
			y=y-linespacingbefore[currentstringtype]
		elseif currentstringtype==s_old then
			if page~=self.logpage and self.logtext[i].shown then
				self.logtext[i]:Hide()
				clean_logtextbg(i)
			elseif page==self.logpage then
				self.logtextbg[i]:SetPosition(lineindent[currentstringtype], y, 0)
				clean_logtextbg(i)
				self.logtext[i]:SetPosition(0, 0)
				self.logtext[i]:SetColour(colors[currentstringtype][1],colors[currentstringtype][2],colors[currentstringtype][3],1)
				self.logtext[i]:SetString(log.chapters[currentchapter].log[currenttag].orig)
				if not self.logtext[i].shown then self.logtext[i]:Show() end
			end
			y=y-linespacingafter[currentstringtype]
			currentstringtype=s_new
			y=y-linespacingbefore[currentstringtype]
		elseif currentstringtype==s_new then
			if page~=self.logpage and self.logtext[i].shown then
				self.logtext[i]:Hide()
				clean_logtextbg(i)
			elseif page==self.logpage then
				self.logtextbg[i]:SetPosition(lineindent[currentstringtype], y, 0)
				clean_logtextbg(i)
				self.logtext[i]:SetPosition(0, 0)
				self.logtext[i]:SetColour(colors[currentstringtype][1],colors[currentstringtype][2],colors[currentstringtype][3],1)
				self.logtext[i]:SetString(log.chapters[currentchapter].log[currenttag].new)
				if not self.logtext[i].shown then self.logtext[i]:Show() end
			end
			y=y-linespacingafter[currentstringtype]
			if currenttag<#log.chapters[currentchapter].log then
				currenttag=currenttag+1
				currentstringtype=s_tag
				y=y-linespacingbefore[currentstringtype]
			else
				if currentchapter<#log.chapters then
					currentchapter=currentchapter+1
					currentstringtype=s_chapter
					y=y-linespacingbefore[currentstringtype]
					currenttag=1
				else
					currentstringtype=s_none
				end
			end
		elseif currentstringtype==s_none then
			for k=i,self.logtextlines do
				self.logtext[k]:SetString("")
				if self.logtext[k].shown then self.logtext[k]:Hide() clean_logtextbg(k) end
			end
			i=self.logtextlines
			if y==starty then page=page-1 end --���� �� ���� �������� ��� �� ����� ������, �� ��� �������� ������
		end
		i=i+1
	end
	self.logpages=page
end


--��������� ��������� � ����� � ������������ � ��������� ������� � �����
function LanguageOptions:UpdateLogsTitle()
	if #self.UpdateLog~=0 then
		self.logstitle:SetString(" "..self.UpdateLog[self.CurrentLogRecord].date.." ")
		self.logstitle2:SetString(self.UpdateLog[self.CurrentLogRecord].time)
		local w,_=self.logstitle:GetRegionSize()
		local w1,_=self.logstitle1:GetRegionSize()
		local w2,_=self.logstitle2:GetRegionSize()
		local pos=(w+w1+w2)/2
		self.logstitle1:SetPosition(-pos+w1/2, 240, 0)
		self.logstitle2:SetPosition(pos-w2/2, 240, 0)
		self.logstitle:SetPosition(-pos+w1+w/2, 245, 0)
		if not self.logstitle.shown then
			self.logstitle:Show()	
			self.logstitle1:Show()
			self.logstitle2:Show()	
		end
	else
		if self.logstitle.shown then
			self.logstitle:Hide()	
			self.logstitle1:Hide()	
			self.logstitle2:Hide()	
		end
	end
end

local function parsedate(dat)
	local months={"������","�������","�����","������","���","����","����","�������","��������","�������","������","�������"}
	local t=string.split(dat," ")
	local date=t[1]
	local time=t[2]
	date=string.split(date,".")
	local t1,t2,t3=string.match(time,"(%d+)%D+(%d+)%D+(%d+)")
	if #t1==1 then t1="0"..t1 end
	if #t2==1 then t2="0"..t2 end
	if #t3==1 then t3="0"..t3 end
	return date[1].." "..months[tonumber(date[2])].." "..date[3],t1..":"..t2..":"..t3
end

--��������� � ������ ���� ������� ���������
function LanguageOptions:LoadHistory()
	if self.textfade then self.textfade:Hide() end
	local maxlinewidth=560

	local function fittext(line) --���������� ������ �����, ������� �������������� �������
		if not line or #line==0 then return {""} end
		local t=Text(BODYTEXTFONT, 25)
		t:SetString(line)
		local w0 = t:GetRegionSize()
		local approxlen=math.floor(#line*maxlinewidth/w0+0.5)
		local lines={}

		local function findpartlen() --���� �� ���������� �������� �� ������ ������, ������� ������
			local function ShiftOneWordForward()
				approxlen=approxlen+1
				while approxlen<#line and string.sub(line.." ",approxlen+1,approxlen+1)~=" " do approxlen=approxlen+1 end
			end
			local function ShiftOneWordBackward()
				approxlen=approxlen-1
				while approxlen>1 and string.sub(line,approxlen,approxlen)~=" " do approxlen=approxlen-1 end
			end
			local maxlinewidth=maxlinewidth
			t:SetString(string.sub(line,1,approxlen))
			local w = t:GetRegionSize()
			local wasfit = w<maxlinewidth
			while true do
				t:SetString(string.sub(line,1,approxlen))
				w = t:GetRegionSize()
				if w>=maxlinewidth then --�� ���������
					ShiftOneWordBackward()
					if wasfit then break end
					wasfit=false
				end
				if w<maxlinewidth then --���������
					if not wasfit or #line<=approxlen then break end
					ShiftOneWordForward()
					wasfit=true
				end
			end
			return approxlen
		end
		while line and #line>0 do
			local len=findpartlen()
			table.insert(lines,string.sub(line,1,len))
			line=string.sub(line,len+1)
		end
		t:Kill()
		return lines
	end
	self.logstitle1:SetString("������")
	if self.urlbutton then
		if self.urlbutton.parent then
			self.urlbutton.parent.children[self.urlbutton] = nil
			if self.urlbutton.shown then self.urlbutton:Hide() end
		end
	end
	for i=1,#self.logtext do --������� �������-������, ���� ��� ����
		self.logtext[i]:Hide()
		self.logtext[i]:Kill()
	end
	for i=1,#self.logtextbg do
		self.logtextbg[i]:Kill()
	end
	self.logpages=0
	self.UpdateLog={}
	self.logtextlines=0
	local lines=0
	local f=io.open(t.StorePath.."history.txt","r")
	if f then for line in f:lines() do 
		line=escapeR(line) --����������� �� \r ��� ����� ������
		if string.sub(line,1,6)=="������" then --������� �������� ����� ������
			if lines~=0 then --�� ����� ��� �������� ������ ������
				if self.logtextlines<lines then self.logtextlines=lines end
			end
			lines=0
			local ver,dat=string.match(line,"������ ([^%(]*) %((.*)%)")
			dat=parsedate(dat.." 11:11:11")
			table.insert(self.UpdateLog,{date=ver,time="�� "..dat,chapters={}})
		else --���� ��� �� �������� ����� ������, ������ ���� �� ��������� ������
			line=string.gsub(line,"[\150\151]","-")
			for i,data in ipairs(fittext(line)) do
				if i==1 then
					table.insert(self.UpdateLog[#self.UpdateLog].chapters,{firstline=data,nextlines={}})
				else
					table.insert(self.UpdateLog[#self.UpdateLog].chapters[#self.UpdateLog[#self.UpdateLog].chapters].nextlines,data)
				end
				lines=lines+1
			end
		end
		
	end f:close() end

	local function ReverseTable(t)
		local reversedTable = {}
		local itemCount = #t
		for k, v in ipairs(t) do
			reversedTable[itemCount + 1 - k] = v
		end
		return reversedTable
	end
	self.UpdateLog=ReverseTable(self.UpdateLog)
	self.logtext={}
	self.logtextbg={}
	for i=1,self.logtextlines do --������ ��������� ������� ������ � ������������ � ������ �����������.
		table.insert(self.logtextbg,self.logspanel:AddChild(Image("images/global.xml", "square.tex")))
		self.logtextbg[#self.logtextbg]:SetSize(0, 0)
		self.logtextbg[#self.logtextbg]:SetTint(1,1,1,0)	
		table.insert(self.logtext,self.logtextbg[#self.logtextbg]:AddChild(Text(BODYTEXTFONT, 25)))
		self.logtext[#self.logtext]:Hide()
		self.logtext[#self.logtext]:SetRegionSize(maxlinewidth, 40)
		self.logtext[#self.logtext]:SetHAlign(ANCHOR_LEFT)
		self.logtext[#self.logtext]:SetVAlign(ANCHOR_MIDDLE)
	end
	self.CurrentLogRecord=#self.UpdateLog

end

--��������� ������ �� ���� ���������� ��� �������.
function LanguageOptions:LoadUpdateLog()
	if self.urlbutton then
		if self.urlbutton.parent then
			self.urlbutton.parent.children[self.urlbutton] = nil
			if self.urlbutton.shown then self.urlbutton:Hide() end
		end
	end
	for i=1,#self.logtext do --������� �������-������, ���� ��� ����
		self.logtext[i]:Hide()
		self.logtext[i]:Kill()
	end
	for i=1,#self.logtextbg do
		self.logtextbg[i]:Kill()
	end
	self.logpages=0
	self.logtext={}
	self.logtextbg={}
	self.logstitle1:SetString("���������� ��")
	self.UpdateLog={}
	if not kleifileexists(t.StorePath..t.UpdateLogFileName) then
		return nil
	end
	if self.textfade then self.textfade:Show() end
	local UpdateLog={}
	local logdata={}

	local f=io.open(t.StorePath..t.UpdateLogFileName,"r")
	if f then for line in f:lines() do 
		table.insert(logdata,escapeR(line))
	end f:close() end
	local i=1
	local record=nil
	local chapter=nil
	while i<#logdata do
		if logdata[i]=="------------------------------------------------------------------------------------------" then
			local dat=string.match(logdata[i+1],"%-([^%-]+)%-")
			table.insert(UpdateLog,{date=dat,chapters={}})
			record=#UpdateLog
			chapter=nil
			i=i+4
		end
		if record then
			if string.sub(logdata[i],1,5)=="�����" then
				local chapt,txt=string.match(logdata[i],"^�����%s([%S]+)%s%((.+)%)$")
				table.insert(UpdateLog[record].chapters,{name=chapt,textname=txt,log={}})
				chapter=#UpdateLog[record].chapters
				for i,v in ipairs(t.ChaptersList) do
					if v.name==chapt then
						UpdateLog[record].chapters[chapter]["index"]=i
						break
					end
				end
			elseif chapter and string.sub(logdata[i],1,1)=="\t" then
				local tag1=string.sub(logdata[i],2)
				local orig1=string.gsub(string.sub(logdata[i+1],7),"\\\"","\"")
				local new1=string.gsub(string.sub(logdata[i+2],9),"\\\"","\"")
				table.insert(UpdateLog[record].chapters[chapter].log,{tag=tag1,orig=orig1,new=new1})
				i=i+2
			end
		end
		i=i+1
	end

	--���������� ������ ��, � ������� ��� ������ ����.
	for _,record in ipairs(UpdateLog) do
		if record.chapters and #record.chapters~=0 then
			local tempchapters={}
			for _,chapter in ipairs(record.chapters) do
				if chapter.log and #chapter.log~=0 then
					table.insert(tempchapters,chapter)
				end
			end
			if #tempchapters~=0 then
				local dat,tim=parsedate(record.date)
				table.insert(self.UpdateLog,{date=dat,time=tim,chapters=tempchapters})
			end
		end

	end

	self.logtextlines=0 --���������� ����������� ���������� �����
	for _,v in ipairs(self.UpdateLog) do
		local lines=1
		for _,i in ipairs(v.chapters) do
			lines=lines+1
			for _,p in ipairs(i.log) do
				lines=lines+3
			end
		end
		if lines>self.logtextlines then --���� ����� � ����� ������� ����������� �����
			self.logtextlines=lines
		end
	end
	--�������������� ������ ���� ����
	for i=1,self.logtextlines do --������ ��������� ������� ������ � ������������ � ������ �����������.
		table.insert(self.logtextbg,self.logspanel:AddChild(Image("images/global.xml", "square.tex")))
		self.logtextbg[#self.logtextbg]:SetSize(0, 0)
		self.logtextbg[#self.logtextbg]:SetTint(1,1,1,0)	
		table.insert(self.logtext,self.logtextbg[#self.logtextbg]:AddChild(Text(BODYTEXTFONT, 25)))
		self.logtext[#self.logtext]:Hide()
		self.logtext[#self.logtext]:SetRegionSize(530, 40)
		self.logtext[#self.logtext]:SetHAlign(ANCHOR_LEFT)
		self.logtext[#self.logtext]:SetVAlign(ANCHOR_MIDDLE)
	end

	if self.urlbutton then
		self.urlbutton:Hide()
		self.urlbutton.image:Hide()
		self.urlbutton:Kill()
		self.urlbutton=ImageButton("images/eyebutton.xml", "eyebutton1.tex", "eyebutton2.tex", "eyebutton3.tex")
		self.urlbutton:SetPosition(-265,-12)
		self.urlbutton:SetScale(0.4)
		self.urlbutton:Hide()
	end

end



--������ ������� ������ ����
function LanguageOptions:ChangeLogRecord(dir)
	if #self.UpdateLog==0 then
		if self.rightbutton.shown then self.rightbutton:Hide() end
		if self.leftbutton.shown then self.leftbutton:Hide() end
		self:UpdateLogsTitle()
		return nil
	end
	self.CurrentLogRecord=self.CurrentLogRecord+dir

	if self.CurrentLogRecord==0 then --���� ����� �� ��������, ��������� ������, � ����� ������ ������� �������
		self.CurrentLogRecord=1
	end
	self:UpdateLogsTitle()
	if dir>0 then -- ������� �����
		if not self.leftbutton.shown then
			self.leftbutton:Show()
		end
		if self.CurrentLogRecord==#self.UpdateLog then
			self.rightbutton:Hide()
		end
		self.logpage=1
		self.logpages=0
		self:UpdateLogText()
	elseif dir<0 then -- ������� �����
		if not self.rightbutton.shown then
			self.rightbutton:Show()
		end
		if self.CurrentLogRecord==1 then
			self.leftbutton:Hide()
		end
		self.logpage=1
		self.logpages=0
		self:UpdateLogText()
	else
		if self.CurrentLogRecord<#self.UpdateLog and not self.rightbutton.shown then
			self.rightbutton:Show()
		elseif self.CurrentLogRecord==#self.UpdateLog and self.rightbutton.shown then
			self.rightbutton:Hide()
		end
		if self.CurrentLogRecord>1 and not self.leftbutton.shown then
			self.leftbutton:Show()
		elseif self.CurrentLogRecord==1 and self.leftbutton.shown then
			self.leftbutton:Hide()
		end
		self:UpdateLogText()
	end
end


function LanguageOptions:Cancel()
	if self.urlbutton then self.urlbutton:Kill() end
	self.tf3:Kill()
	TheFrontEnd:PopScreen()
end


function LanguageOptions:OnRawKey(key, down)
	if down and key == KEY_LCTRL then self.ControlButtonPressed=true end
	if not down and key == KEY_LCTRL then self.ControlButtonPressed=false end
end


function LanguageOptions:OnControl(control, down)
    if LanguageOptions._base.OnControl(self, control, down) then return true end
    
    if down then
    	if (rawget(_G,"CONTROL_PAGERIGHT") and control == CONTROL_PAGERIGHT) or
		   (rawget(_G,"CONTROL_SCROLLFWD") and control == CONTROL_SCROLLFWD) then
    		if self.nextpage.shown then
    			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:ChangeLogPage(1)
    		end
    	elseif (rawget(_G,"CONTROL_PAGELEFT") and control == CONTROL_PAGELEFT) or
    		   (rawget(_G,"CONTROL_SCROLLBACK") and control == CONTROL_SCROLLBACK) then
    		if self.prevpage.shown then
    			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:ChangeLogPage(-1)
    		end
		elseif control == CONTROL_ACTION then
			if self.updateoptionsspinner.focus then
				TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
				self.updateoptionsspinner:Next(true)
			end
		elseif control == CONTROL_FOCUS_LEFT and self.CurrentLogRecord>1 then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:ChangeLogRecord(-1)
			self:UpdatePageNumbers()
		elseif control == CONTROL_FOCUS_RIGHT and self.CurrentLogRecord<#self.UpdateLog then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:ChangeLogRecord(1)
			self:UpdatePageNumbers()
    	end

    end

    if not down then
	if control == CONTROL_CANCEL then
		self:Cancel()
		return true
	end
    end
end



function LanguageOptions:GetHelpText()
	local t = {}
	local controller_id = TheInput:GetControllerID()

	if self.prevpage.shown then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_PAGELEFT) .. " " .. STRINGS.UI.HELP.SCROLLBACK)
	end
	if self.nextpage.shown then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_PAGERIGHT) .. " " .. STRINGS.UI.HELP.SCROLLFWD)
	end
	if self.leftbutton.shown then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_FOCUS_LEFT) .. " ���������� ������")
	end
	if self.rightbutton.shown then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_FOCUS_RIGHT) .. " ��������� ������")
	end

	table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)
	return table.concat(t, "  ")
end

return LanguageOptions