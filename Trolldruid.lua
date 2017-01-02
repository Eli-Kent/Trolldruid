-- thanks to jaaroy at wow-one.com for providing a guide
-- functions here
-- \124cffFF0000\124Hitem:19:0:0:0:0:0:0:0\124h____\124h\124r

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
	DEFAULT_CHAT_FRAME:AddMessage(Trolldruid_Message.. " Ping on Minimap")
	end
end;

function SlashCmdList.TROLL_PING_TOGGLE(msg, editbox)
	if(PingVar == 0) 
		then PingVar = 1
		DEFAULT_CHAT_FRAME:AddMessage(Trolldruid_Message.. " Ping Disabled")
	elseif(PingVar == 1)
		then PingVar = 0
		DEFAULT_CHAT_FRAME:AddMessage(Trolldruid_Message.. " Ping Enabled")
	end;
end
-- slash commands here
SLASH_MOUSEOVER1, SLASH_MOUSEOVER2 = '/mocast', '/mouseovercast' 
SLASH_TROLL_PING_TOGGLE1 = '/ping'

-- variables here 
DuelVar = 0
PingVar = 1
Trolldruid_Message = '\124cffdaa520\124Hitem:19:0:0:0:0:0:0:0\124hTrolldruid:\124h\124r'
-- Frames
-- Frame for buttons 
local Frame_Wardrobe = CreateFrame("Frame", "Wardrobe_Frame", UIParent, "GameMenuButtonTemplate")
	Frame_Wardrobe:SetWidth(84)
	Frame_Wardrobe:SetHeight(68)
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
	Frame_Spell_1:RegisterEvent("SPELLCAST_START")
	Frame_Spell_1:SetScript("OnEvent", Troll_Ping)

-- Buttons
-- Showing Helm and Cloak, Thanks to zork @wowinterface.com for posting an example
local Button_Cloak = CreateFrame("Button", "Wardrobe_Button", Frame_Wardrobe, 'UIPanelButtonTemplate')
	Button_Cloak:SetWidth(80)
	Button_Cloak:SetHeight(20)
	Button_Cloak:SetPoint("CENTER",0,-20)
	Button_Cloak:SetText('Cloak')
	Button_Cloak:RegisterForClicks("LeftButtonUp")
	Button_Cloak:SetScript("OnClick", function(self) if ShowingCloak(1) then
			ShowCloak(false)
			DEFAULT_CHAT_FRAME:AddMessage(Trolldruid_Message.." Cloak Disabled")
		else
			ShowCloak(true)
			DEFAULT_CHAT_FRAME:AddMessage(Trolldruid_Message.." Cloak Enabled")
		end
	end)
	Button_Cloak:SetAlpha(0.7)

local Button_Helm = CreateFrame("Button", "Wardrobe_Button", Frame_Wardrobe, 'UIPanelButtonTemplate')
	Button_Helm:SetWidth(80)
	Button_Helm:SetHeight(20)
	Button_Helm:SetPoint("CENTER",0,0)
	Button_Helm:SetText('Helm')
	Button_Helm:RegisterForClicks("LeftButtonUp")
	Button_Helm:SetScript("OnClick", function(self) if ShowingHelm(1) then
			ShowHelm(false)
			DEFAULT_CHAT_FRAME:AddMessage(Trolldruid_Message.."Helm Disabled")
		else
			ShowHelm(true)
			DEFAULT_CHAT_FRAME:AddMessage(Trolldruid_Message.."Helm Enabled")
		end
	end)
	Button_Helm:SetAlpha(0.7)

local Button_Duel = CreateFrame("Button", "Duel_Button", Frame_Wardrobe, 'UIPanelButtonTemplate')
	Button_Duel:SetWidth(80)
	Button_Duel:SetHeight(20)
	Button_Duel:SetPoint("CENTER",0,20)
	Button_Duel:SetText('Duel/Concede')
	Button_Duel:RegisterForClicks("LeftButtonUp")
	Button_Duel:SetScript("OnClick", function(self) Troll_Duel() end)
	Button_Duel:SetAlpha(0.7)