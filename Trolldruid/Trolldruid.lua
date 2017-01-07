--Variables

local ClockRunning = false
local UpdateTime = 0.5
local LastUpdate = 0
local DuelVar = 0
local PingVar = 1
local TrolldruidMessage = '\124cffdaa520\124Hitem:19:0:0:0:0:0:0:0\124hTrolldruid:\124h\124r'
local StoppedTime = 0

-- functions here

function SlashCmdList.MOUSEOVER(msg, editbox) 
if GetMouseFocus().unit then 
	if UnitIsEnemy("target", GetMouseFocus().unit) then
		if UnitIsUnit("target", GetMouseFocus().unit) then
			CastSpellByName(msg)
		else
			TargetUnit(GetMouseFocus().unit)
			CastSpellByName(msg)
			TargetLastTarget()
		end
	else
		if UnitIsUnit("target", GetMouseFocus().unit) then
			CastSpellByName(msg)
		else
			TargetUnit(GetMouseFocus().unit)
			CastSpellByName(msg)
			TargetLastTarget()
		end
	end
else
	CastSpellByName(msg)
end
end

function Troll_Duel()
	TrollTarget = GetUnitName("target")
	if(DuelVar == 0) then StartDuel(TrollTarget);
		DuelVar = 1;
	elseif(DuelVar == 1) then CancelDuel();
		DuelVar = 0
	end;
end

function Troll_Ping()
	if(PingVar == 0) then
	DEFAULT_CHAT_FRAME:AddMessage(TrolldruidMessage.. " Ping on Minimap")
	end
end;

function SlashCmdList.TROLL_PING_TOGGLE(msg, editbox)
	if(PingVar == 0) 
		then PingVar = 1
		DEFAULT_CHAT_FRAME:AddMessage(TrolldruidMessage.. " Ping Disabled")
	elseif(PingVar == 1)
		then PingVar = 0
		DEFAULT_CHAT_FRAME:AddMessage(TrolldruidMessage.. " Ping Enabled")
	end;
end

function Troll_Start()
	DEFAULT_CHAT_FRAME:AddMessage(TrolldruidMessage .." \124cff49ff00\124Hitem:19:0:0:0:0:0:0:0\124hRunning Version 0.3\124h\124r")
end

function SlashCmdList.TROLL_CLOCK_SHOW(msg, editbox)
	local Frame_Clock = getglobal("Clock_Frame")
	if (Frame_Clock) then
		if(Frame_Clock:IsVisible()) then
			Frame_Clock:Hide();
		else
			Frame_Clock:Show();
		end	
	end	
end

function SlashCmdList.TROLL_WARDROBE_SHOW(msg, editbox)
	local Frame_Wardrobe = getglobal("Wardrobe_Frame")
	if (Frame_Wardrobe) then
		if(Frame_Wardrobe:IsVisible()) then
			Frame_Wardrobe:Hide();
		else
			Frame_Wardrobe:Show();
		end
	end
end

function Clock_Update()
	if(GetTime() - LastUpdate > UpdateTime) and (ClockRunning == true) then
		LastUpdate = GetTime()

		local Troll_Seconds = (StartTime and floor(GetTime() - StartTime) or 0) + StoppedTime
		local Troll_Hours = floor(Troll_Seconds / 3600)
		local Troll_Seconds = Troll_Seconds - Troll_Hours * 3600
		local Troll_Minutes = floor(Troll_Seconds / 60)
		local Troll_Seconds = Troll_Seconds - Troll_Minutes * 60

		Clock_Display_Seconds(Troll_Seconds)
		Clock_Display_Minutes(Troll_Minutes)
		Clock_Display_Hours(Troll_Hours)
	end
end

function Clock_Display_Hours(Troll_Hours)
	local Frame_Clock = getglobal("Clock_Frame")
	Frame_Clock:CreateFontString("Clock_Font_Hours", "", "GameFontNormal")
	Clock_Font_Hours:SetText(Troll_Hours)
	Clock_Font_Hours:SetPoint("CENTER",-20,5)
end

function Clock_Display_Minutes(Troll_Minutes)
	local Frame_Clock = getglobal("Clock_Frame")
	Frame_Clock:CreateFontString("Clock_Font_Minutes", "", "GameFontNormal")
	Clock_Font_Minutes:SetText(Troll_Minutes)
	Clock_Font_Minutes:SetPoint("CENTER",0,5)
end

function Clock_Display_Seconds(Troll_Seconds)
	local Frame_Clock = getglobal("Clock_Frame")
	Frame_Clock:CreateFontString("Clock_Font_Seconds", "", "GameFontNormal")
	Clock_Font_Seconds:SetText(Troll_Seconds)
	Clock_Font_Seconds:SetPoint("CENTER",20,5)
end

function Clock_Stop()
	if(ClockRunning == true) then
	StoppedTime = floor(StoppedTime + GetTime() - StartTime)
	StartTime = nil
	ClockRunning = false
	end
end

function Clock_Start()
	if(ClockRunning == false) then 
		ClockRunning = true
		StartTime = GetTime()
	end
end

function Clock_Reset()
	StartTime = 0
	Troll_Hours = 0
	Troll_Minutes = 0
	Troll_Seconds = 0
	StoppedTime = 0
	ClockRunning = false
	Clock_Font_Hours:SetText('0')
	Clock_Font_Minutes:SetText('0')
	Clock_Font_Seconds:SetText('0')
end

function Clock_Toggle()
	local Frame_Clock = getglobal("Clock_Frame")
	StartTime = 0
	Troll_Hours = 0
	Troll_Minutes = 0
	Troll_Seconds = 0
	StoppedTime = 0
	ClockRunning = false
	Clock_Font_Hours:SetText('0')
	Clock_Font_Minutes:SetText('0')
	Clock_Font_Seconds:SetText('0')
	Frame_Clock:Hide()
end

-- slash commands here
SLASH_MOUSEOVER1, SLASH_MOUSEOVER2 = '/mocast', '/mouseovercast' 
SLASH_TROLL_PING_TOGGLE1 = '/ping'
SLASH_TROLL_CLOCK_SHOW1 = '/clockshow'
SLASH_TROLL_WARDROBE_SHOW1 = '/trolldruid'

-- Frames
-- Frame for buttons 
local Frame_Wardrobe = CreateFrame("Frame", "Wardrobe_Frame", UIParent, "GameMenuButtonTemplate")
	Frame_Wardrobe:SetWidth(54)
	Frame_Wardrobe:SetHeight(78)
	Frame_Wardrobe:SetPoint("CENTER",UIParent)
	Frame_Wardrobe:EnableMouse(true)
	Frame_Wardrobe:SetMovable(true)
	Frame_Wardrobe:RegisterForDrag("LeftButton")
	Frame_Wardrobe:SetScript("OnDragStart", function(self) Frame_Wardrobe:StartMoving() end)
	Frame_Wardrobe:SetScript("OnDragStop", function(self) Frame_Wardrobe:StopMovingOrSizing() end)
	Frame_Wardrobe:SetBackdrop({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
			edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
			edgeSize = 10,
			tileSize = 32,
			insets = {
				left = 2,
				right = 2,
				top = 2,
				bottom = 2,
				}
			})
	Frame_Wardrobe:Show()

local Troll_Ping_Frame_1 = CreateFrame("Frame", "Frame_Troll_Ping_1")
	Troll_Ping_Frame_1:RegisterEvent("MINIMAP_PING")
	Troll_Ping_Frame_1:SetScript("OnEvent", Troll_Ping)

 local Spell_Frame_1 = CreateFrame("Frame", "Frame_Spell_1")
	Frame_Spell_1:RegisterEvent("PLAYER_LOGIN")
	Frame_Spell_1:SetScript("OnEvent", Troll_Start)

local Frame_Clock = CreateFrame("Frame", "Clock_Frame", UIParent, "GameMenuButtonTemplate")
	Frame_Clock:SetWidth(104)
	Frame_Clock:SetHeight(58)
	Frame_Clock:SetPoint("CENTER",0,68,UIParent)
	Frame_Clock:EnableMouse(true)
	Frame_Clock:SetMovable(true)
	Frame_Clock:RegisterForDrag("LeftButton")
	Frame_Clock:SetScript("OnDragStart", function(self) Frame_Clock:StartMoving() end)
	Frame_Clock:SetScript("OnDragStop", function(self) Frame_Clock:StopMovingOrSizing() end)
	Frame_Clock:SetScript("OnUpdate", function(self) Clock_Update() end)
	Frame_Clock:SetBackdrop({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
			edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
			edgeSize = 10,
			tileSize = 32,
			insets = {
				left = 2,
				right = 2,
				top = 2,
				bottom = 2,
				}
			})
	Frame_Clock:Show()

-- Buttons
-- Showing Helm and Cloak, Thanks to zork @wowinterface.com for posting an example
local Button_Cloak = CreateFrame("Button", "Wardrobe_Button", Frame_Wardrobe, 'UIPanelButtonTemplate')
	Button_Cloak:SetWidth(50)
	Button_Cloak:SetHeight(20)
	Button_Cloak:SetPoint("CENTER",0,-25)
	Button_Cloak:SetText('Cloak')
	Button_Cloak:RegisterForClicks("LeftButtonUp")
	Button_Cloak:SetScript("OnClick", function(self) if ShowingCloak(1) then
			ShowCloak(false)
			DEFAULT_CHAT_FRAME:AddMessage(TrolldruidMessage.." Cloak Disabled")
		else
			ShowCloak(true)
			DEFAULT_CHAT_FRAME:AddMessage(TrolldruidMessage.." Cloak Enabled")
		end
	end)
	Button_Cloak:SetAlpha(0.7)

local Button_Helm = CreateFrame("Button", "Wardrobe_Button", Frame_Wardrobe, 'UIPanelButtonTemplate')
	Button_Helm:SetWidth(50)
	Button_Helm:SetHeight(20)
	Button_Helm:SetPoint("CENTER",0,-5)
	Button_Helm:SetText('Helm')
	Button_Helm:RegisterForClicks("LeftButtonUp")
	Button_Helm:SetScript("OnClick", function(self) if ShowingHelm(1) then
			ShowHelm(false)
			DEFAULT_CHAT_FRAME:AddMessage(TrolldruidMessage.."Helm Disabled")
		else
			ShowHelm(true)
			DEFAULT_CHAT_FRAME:AddMessage(TrolldruidMessage.."Helm Enabled")
		end
	end)
	Button_Helm:SetAlpha(0.7)

local Button_Duel = CreateFrame("Button", "Duel_Button", Frame_Wardrobe, 'UIPanelButtonTemplate')
	Button_Duel:SetWidth(50)
	Button_Duel:SetHeight(20)
	Button_Duel:SetPoint("CENTER",0,15)
	Button_Duel:SetText('Duel')
	Button_Duel:RegisterForClicks("LeftButtonUp")
	Button_Duel:SetScript("OnClick", function(self) Troll_Duel() end)
	Button_Duel:SetAlpha(0.7)

local Button_Clock_Toggle = CreateFrame("Button", "Clock_Toggle_Button", Frame_Clock, 'UIPanelButtonTemplate')
	Button_Clock_Toggle:SetWidth(10)
	Button_Clock_Toggle:SetHeight(10)
	Button_Clock_Toggle:SetPoint("TOPRIGHT",-5,-5)
	Button_Clock_Toggle:SetText('X')
	Button_Clock_Toggle:RegisterForClicks("LeftButtonUp")
	Button_Clock_Toggle:SetScript("OnClick", function(self) Clock_Toggle() end)
	Button_Clock_Toggle:SetAlpha(0.7)

local Button_Wardrobe_Toggle = CreateFrame("Button", "Wardrobe_Toggle_Button", Frame_Wardrobe, 'UIPanelButtonTemplate')
	Button_Wardrobe_Toggle:SetWidth(10)
	Button_Wardrobe_Toggle:SetHeight(10)
	Button_Wardrobe_Toggle:SetPoint("TOPRIGHT",-5,-5)
	Button_Wardrobe_Toggle:SetText('X')
	Button_Wardrobe_Toggle:RegisterForClicks("LeftButtonUp")
	Button_Wardrobe_Toggle:SetScript("OnClick", function(self) Frame_Wardrobe:Hide() end)
	Button_Wardrobe_Toggle:SetAlpha(0.7)

local Button_Clock_Start = CreateFrame("Button", "Clock_Start_Button", Frame_Clock, 'UIPanelButtonTemplate')
	Button_Clock_Start:SetWidth(30)
	Button_Clock_Start:SetHeight(20)
	Button_Clock_Start:SetPoint("BOTTOM",0,5)
	Button_Clock_Start:SetText('Start')
	Button_Clock_Start:RegisterForClicks("LeftButtonUp")
	Button_Clock_Start:SetScript("OnClick", function(self) Clock_Start() end)
	Button_Clock_Start:SetAlpha(0.7)

local Button_Clock_Stop = CreateFrame("Button", "Clock_Stop_Button", Frame_Clock, 'UIPanelButtonTemplate')
	Button_Clock_Stop:SetWidth(30)
	Button_Clock_Stop:SetHeight(20)
	Button_Clock_Stop:SetPoint("BOTTOM",-30,5)
	Button_Clock_Stop:SetText('Stop')
	Button_Clock_Stop:RegisterForClicks("LeftButtonUp")
	Button_Clock_Stop:SetScript("OnClick", function(self) Clock_Stop() end)
	Button_Clock_Stop:SetAlpha(0.7)

local Button_Clock_Reset = CreateFrame("Button", "Clock_Reset_Button", Frame_Clock, 'UIPanelButtonTemplate')
	Button_Clock_Reset:SetWidth(30)
	Button_Clock_Reset:SetHeight(20)
	Button_Clock_Reset:SetPoint("BOTTOM",30,5)
	Button_Clock_Reset:SetText('Reset')
	Button_Clock_Reset:RegisterForClicks("LeftButtonUp")
	Button_Clock_Reset:SetScript("OnClick", function(self) Clock_Reset() end)
	Button_Clock_Reset:SetAlpha(0.7)