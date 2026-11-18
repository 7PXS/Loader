-- Dirty Fucking Skid
if LPH_OBFUSCATED == nil then
	LPH_JIT = function(Fn) return Fn end
end

local cloneref = cloneref or clonereference or function(Item) return Item end

local Players          = cloneref(game:GetService("Players"))
local CoreGui          = cloneref(game:GetService("CoreGui"))
local UserInputService = cloneref(game:GetService("UserInputService"))

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local ProtectGui  = protectgui or (syn and syn.protect_gui) or function() end
local GetHUI      = gethui or function() return CoreGui end
local Env         = (getgenv and getgenv()) or _G

local Theme = {
	Background  = Color3.fromRGB(17, 17, 22),
	Section     = Color3.fromRGB(20, 20, 26),
	Element     = Color3.fromRGB(27, 27, 35),
	Line        = Color3.fromRGB(33, 33, 38),
	Text        = Color3.fromRGB(255, 255, 255),
	DimText     = Color3.fromRGB(103, 104, 126),
	DimIcon     = Color3.fromRGB(120, 120, 126),
	Accent      = Color3.fromRGB(255, 137, 125),
	AccentHover = Color3.fromRGB(255, 162, 148),
	OnAccent    = Color3.new(0, 0, 0),
	Success     = Color3.fromRGB(80, 200, 120),
	Warning     = Color3.fromRGB(255, 180, 50),
	Error       = Color3.fromRGB(255, 80, 80),
}

local Icons = {
	error   = "rbxassetid://77236530693648",
	warning = "rbxassetid://72204937258553",
	success = "rbxassetid://138308485898114",
	info    = "rbxassetid://86340411818675",
	spin    = "rbxassetid://83038105385445",
	eyeOff  = "rbxassetid://101937481624072",
	eyeOn   = "rbxassetid://111545834461192",
}

local UIFont = Font.fromEnum(Enum.Font.ArimoBold)

local function Create(ClassName, Properties, Parent)
	local Element = Instance.new(ClassName)
	for Key, Value in pairs(Properties) do Element[Key] = Value end
	Element.Parent = Parent
	return Element
end

local function Round(Element, Radius)
	Create("UICorner", { CornerRadius = UDim.new(0, Radius) }, Element)
end

local function AddStroke(Element, Color)
	return Create("UIStroke", { Color = Color or Theme.Line, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, Element)
end

local function CreateLabel(Properties, Parent)
	Properties.BackgroundTransparency = 1
	Properties.FontFace = UIFont
	Properties.TextColor3 = Properties.TextColor3 or Theme.Text
	Properties.TextSize = Properties.TextSize or 13
	Properties.TextXAlignment = Properties.TextXAlignment or Enum.TextXAlignment.Left
	return Create("TextLabel", Properties, Parent)
end

local function PlayTween(Element, Properties, Duration, Style, Direction)
	local TweenInstance = cloneref(game:GetService("TweenService")):Create(Element, TweenInfo.new(Duration or 0.2, Style or Enum.EasingStyle.Quart, Direction or Enum.EasingDirection.Out), Properties)
	TweenInstance:Play()
	return TweenInstance
end

local function MountGui(ScreenGui)
	pcall(ProtectGui, ScreenGui)
	for _, Parent in ipairs({ GetHUI(), CoreGui }) do
		if pcall(function() ScreenGui.Parent = Parent end) then return end
	end
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function CreateScreenGui(Name, DisplayOrder)
	return Create("ScreenGui", {
		Name = Name, DisplayOrder = DisplayOrder, ResetOnSpawn = false, IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
end

for _, Parent in ipairs({ GetHUI(), CoreGui, LocalPlayer:FindFirstChild("PlayerGui") }) do
	pcall(function()
		for _, Child in ipairs(Parent:GetChildren()) do
			if Child.Name == "SiliconKeyUI" or Child.Name == "SiliconPopup" or Child.Name == "SiliconNotif" then Child:Destroy() end
		end
	end)
end

local function DeleteSaved()
	pcall(function()
		if isfile("Silicon/key.txt") then (delfile or function(FilePath) writefile(FilePath, "") end)("Silicon/key.txt") end
	end)
end

local function SaveKey(Key)
	pcall(function()
		if not isfolder("Silicon") then makefolder("Silicon") end
		writefile("Silicon/key.txt", Key)
	end)
end

local function ReadSaved()
	local DidRead, SavedKey = pcall(function() return isfile("Silicon/key.txt") and readfile("Silicon/key.txt") or nil end)
	return DidRead and SavedKey and SavedKey:match("^%s*([^|%s]+)") or nil
end

-- The user's loadstring may supply lp_key (or script_key) and RemoveData.
local PresetKey = rawget(Env, "lp_key") or rawget(Env, "script_key")
PresetKey = PresetKey ~= nil and PresetKey ~= "" and tostring(PresetKey) or nil
Env.lp_key, Env.script_key = nil, nil

local ShouldRemoveData = tostring(rawget(Env, "RemoveData")):lower() == "true"
Env.RemoveData = nil

local KeyGui = CreateScreenGui("SiliconKeyUI", 999)
MountGui(KeyGui)

local DimOverlay = Create("Frame", {
	Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(), BackgroundTransparency = 1, BorderSizePixel = 0,
}, KeyGui)

local KeyCard = Create("CanvasGroup", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(340, 372),
	BackgroundColor3 = Theme.Section, BorderSizePixel = 0, GroupTransparency = 1, Active = true,
}, KeyGui)
Round(KeyCard, 6)
AddStroke(KeyCard)
local KeyCardScale = Create("UIScale", { Scale = 0.95 }, KeyCard)

local TitleBar = Create("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1 }, KeyCard)
local TitleHolder = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, TitleBar)
Create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8),
}, TitleHolder)
Create("ImageLabel", { Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, Image = "rbxassetid://106687191737423", LayoutOrder = 1 }, TitleHolder)
CreateLabel({ Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X, Text = "Silicon", TextSize = 16, LayoutOrder = 2 }, TitleHolder)
Create("Frame", {
	Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromScale(0, 1), BackgroundColor3 = Theme.Line, BorderSizePixel = 0,
}, TitleBar)

local CloseUiButton = Create("ImageButton", {
	Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -15, 0, 15),
	BackgroundTransparency = 1, Image = Icons.error, ImageColor3 = Theme.DimIcon,
}, TitleBar)
CloseUiButton.MouseEnter:Connect(function() PlayTween(CloseUiButton, { ImageColor3 = Theme.Error }, 0.15) end)
CloseUiButton.MouseLeave:Connect(function() PlayTween(CloseUiButton, { ImageColor3 = Theme.DimIcon }, 0.15) end)

do
	local DragStart, StartCardPosition
	TitleBar.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			DragStart, StartCardPosition = Input.Position, KeyCard.Position
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then DragStart = nil end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(Input)
		if DragStart and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			local DragDelta = Input.Position - DragStart
			KeyCard.Position = UDim2.new(StartCardPosition.X.Scale, StartCardPosition.X.Offset + DragDelta.X, StartCardPosition.Y.Scale, StartCardPosition.Y.Offset + DragDelta.Y)
		end
	end)
end

local Content = Create("Frame", {
	Size = UDim2.new(1, -28, 1, -68), Position = UDim2.fromOffset(14, 56), BackgroundTransparency = 1,
}, KeyCard)
Create("UIListLayout", {
	HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10),
}, Content)

local FadeRows = {}

local function CreateRow(Height, Order, Properties)
	Properties = Properties or {}
	Properties.Size = UDim2.new(1, 0, 0, Height)
	Properties.LayoutOrder = Order
	Properties.BorderSizePixel = 0
	Properties.GroupTransparency = 1
	Properties.BackgroundTransparency = Properties.BackgroundTransparency or 1
	local Row = Create("CanvasGroup", Properties, Content)
	table.insert(FadeRows, Row)
	return Row
end

-- Rows are CanvasGroups so each section can fade in separately. Elements with
-- a border stroke are inset 1px so the group's clipping doesn't eat it.
local InputRow = CreateRow(52, 1)
CreateLabel({ Size = UDim2.new(1, 0, 0, 18), Text = "Enter Key", TextColor3 = Theme.DimText }, InputRow)
local KeyInputFrame = Create("Frame", {
	Size = UDim2.new(1, -2, 0, 30), Position = UDim2.fromOffset(1, 21), BackgroundColor3 = Theme.Element, BorderSizePixel = 0,
}, InputRow)
Round(KeyInputFrame, 3)
local KeyInputStroke = AddStroke(KeyInputFrame)

local KeyInput = Create("TextBox", {
	Size = UDim2.new(1, -40, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Text = "",
	PlaceholderText = "Enter your key here...", PlaceholderColor3 = Theme.DimText, TextColor3 = Theme.Text,
	TextSize = 14, FontFace = UIFont, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
}, KeyInputFrame)
local KeyMaskLabel = CreateLabel({
	Size = UDim2.new(1, -40, 1, 0), Position = UDim2.fromOffset(10, 0), TextSize = 14, Visible = false, Active = false,
}, KeyInputFrame)
local KeyEyeButton = Create("ImageButton", {
	Size = UDim2.fromOffset(18, 18), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
	BackgroundTransparency = 1, Image = Icons.eyeOff, ImageColor3 = Theme.DimIcon,
}, KeyInputFrame)

local RememberRow = CreateRow(20, 2)
CreateLabel({ Size = UDim2.new(1, -40, 1, 0), Text = "Remember Key", TextColor3 = Theme.DimText }, RememberRow)
local RememberTrack = Create("Frame", {
	Size = UDim2.fromOffset(27, 16), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(1, 0.5),
	BackgroundColor3 = Theme.Element, BorderSizePixel = 0,
}, RememberRow)
Round(RememberTrack, 8)
local RememberKnob = Create("Frame", {
	Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(3, 3), BackgroundColor3 = Theme.DimText, BorderSizePixel = 0,
}, RememberTrack)
Round(RememberKnob, 5)
local RememberGlow = Create("ImageLabel", {
	Size = UDim2.fromOffset(20, 20), Position = UDim2.fromOffset(9, -2), BackgroundTransparency = 1,
	Image = "rbxassetid://118035861931517", ImageColor3 = Theme.Accent, ImageTransparency = 1,
}, RememberTrack)
local RememberHit = Create("TextButton", {
	Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 2,
}, RememberRow)

CreateRow(1, 3, { BackgroundColor3 = Theme.Line, BackgroundTransparency = 0 })

local KeyInfoRow = CreateRow(40, 4)
local TimeLeftLabel = CreateLabel({ Size = UDim2.new(1, 0, 0, 18), Text = "Time Left:  --", TextColor3 = Theme.DimText }, KeyInfoRow)
local KeyTypeLabel = CreateLabel({
	Size = UDim2.new(1, 0, 0, 18), Position = UDim2.fromOffset(0, 22), Text = "Key Type:  --", TextColor3 = Theme.DimText,
}, KeyInfoRow)

local ButtonRow = CreateRow(30, 5)
Create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8),
}, ButtonRow)

local function CreateButton(Text, Width, Order, Color, TextColor)
	local Button = Create("TextButton", {
		Size = UDim2.new(Width, -4, 1, 0), BackgroundColor3 = Color, BorderSizePixel = 0, Text = Text,
		TextColor3 = TextColor, TextSize = 14, FontFace = UIFont, AutoButtonColor = false, LayoutOrder = Order,
	}, ButtonRow)
	Round(Button, 3)
	local Flash = Create("Frame", {
		Size = UDim2.fromScale(1, 1), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 1, BorderSizePixel = 0,
	}, Button)
	Round(Flash, 3)
	Button.MouseButton1Click:Connect(function()
		PlayTween(Flash, { BackgroundTransparency = 0.75 }, 0.12)
		task.delay(0.13, function() PlayTween(Flash, { BackgroundTransparency = 1 }, 0.38) end)
	end)
	return Button
end

local GetKeyButton = CreateButton("Get Key", 0.42, 1, Theme.Element, Theme.Text)
local VerifyButton = CreateButton("Verify Key", 0.58, 2, Theme.Accent, Theme.OnAccent)
GetKeyButton.MouseEnter:Connect(function() PlayTween(GetKeyButton, { BackgroundColor3 = Theme.Line }, 0.15) end)
GetKeyButton.MouseLeave:Connect(function() PlayTween(GetKeyButton, { BackgroundColor3 = Theme.Element }, 0.15) end)

local StatusRow = CreateRow(36, 6)
local StatusText = CreateLabel({ Size = UDim2.new(1, 0, 0, 14), TextSize = 11 }, StatusRow)
local StatusBar = Create("Frame", {
	Size = UDim2.new(1, -2, 0, 16), Position = UDim2.fromOffset(1, 19), BackgroundColor3 = Theme.Element,
	BorderSizePixel = 0, ClipsDescendants = true,
}, StatusRow)
Round(StatusBar, 8)
AddStroke(StatusBar)
local StatusBarFill = Create("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0 }, StatusBar)
Round(StatusBarFill, 8)
local StatusPulse = Create("Frame", {
	Size = UDim2.fromScale(0.3, 1), Position = UDim2.fromScale(-0.3, 0), BackgroundColor3 = Theme.Accent,
	BackgroundTransparency = 0.6, BorderSizePixel = 0,
}, StatusBar)
Round(StatusPulse, 8)
Create("UIGradient", {
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.4),
		NumberSequenceKeypoint.new(0.7, 0.4), NumberSequenceKeypoint.new(1, 1),
	}),
}, StatusPulse)
local StatusBarIcon = Create("ImageLabel", {
	Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -4, 0.5, 0),
	BackgroundTransparency = 1, ZIndex = 2, Visible = false,
}, StatusBar)

local GameRow = Create("Frame", {
	Size = UDim2.new(1, -2, 1, -2), Position = UDim2.fromOffset(1, 1), BackgroundColor3 = Theme.Element, BorderSizePixel = 0,
}, CreateRow(44, 7))
Round(GameRow, 4)
AddStroke(GameRow)
Round(Create("ImageLabel", {
	Size = UDim2.fromOffset(32, 32), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = Theme.Section,
	BorderSizePixel = 0, Image = ("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(game.GameId),
}, GameRow), 4)
local GameNameLabel = CreateLabel({
	Size = UDim2.new(1, -52, 0, 18), Position = UDim2.fromOffset(46, 5), Text = game.Name, TextSize = 13,
	TextTruncate = Enum.TextTruncate.AtEnd,
}, GameRow)
local PlayerCountLabel = CreateLabel({
	Size = UDim2.new(1, -52, 0, 14), Position = UDim2.fromOffset(46, 23), TextSize = 11, TextColor3 = Theme.DimText,
}, GameRow)

task.spawn(function()
	local DidFetchInfo, GameInfo = pcall(function() return cloneref(game:GetService("MarketplaceService")):GetProductInfo(game.PlaceId) end)
	if DidFetchInfo and GameInfo.Name then GameNameLabel.Text = GameInfo.Name end
end)

task.spawn(function()
	while KeyGui.Parent do
		PlayerCountLabel.Text = ("%d / %d players"):format(#Players:GetPlayers(), Players.MaxPlayers)
		task.wait(2)
	end
end)

local IsIdle = false

task.spawn(function()
	while KeyGui.Parent do
		if IsIdle then
			StatusPulse.Position = UDim2.fromScale(-0.3, 0)
			PlayTween(StatusPulse, { Position = UDim2.fromScale(1, 0) }, 1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
		end
		task.wait(0.3)
	end
end)

cloneref(game:GetService("RunService")).RenderStepped:Connect(function(DeltaTime)
	if StatusBarIcon.Visible and StatusBarIcon.Image == Icons.spin then StatusBarIcon.Rotation = StatusBarIcon.Rotation + DeltaTime * 360 end
end)

local function SetStatus(StatusMessage, StatusColor, FillFraction, StatusIcon)
	IsIdle = FillFraction == 0
	StatusPulse.Visible = IsIdle
	StatusText.Text, StatusText.TextColor3 = StatusMessage, StatusColor
	StatusBarIcon.Visible = StatusIcon ~= nil
	if StatusIcon then
		StatusBarIcon.Image = Icons[StatusIcon]
		StatusBarIcon.ImageColor3 = StatusIcon == "spin" and (IsIdle and Theme.DimIcon or Theme.Accent) or StatusColor
	end
	PlayTween(StatusBarFill, { Size = UDim2.fromScale(FillFraction, 1), BackgroundColor3 = StatusColor }, 0.4)
end

local NoticeGui

local function Notify(NoticeTitle, NoticeBody, Kind)
	if NoticeGui then NoticeGui:Destroy() end
	NoticeGui = CreateScreenGui("SiliconNotif", 1000)
	MountGui(NoticeGui)

	local NoticeFrame = Create("Frame", {
		Size = UDim2.fromOffset(0, 52), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.fromOffset(-450, 60),
		BackgroundColor3 = Theme.Background, BorderSizePixel = 0,
	}, NoticeGui)
	Round(NoticeFrame, 9)
	AddStroke(NoticeFrame)
	Create("UIPadding", { PaddingRight = UDim.new(0, 18) }, NoticeFrame)
	Create("ImageLabel", {
		Size = UDim2.fromOffset(20, 20), Position = UDim2.fromOffset(15, 16), BackgroundTransparency = 1,
		Image = Icons[Kind], ImageColor3 = ({ error = Theme.Error, warning = Theme.Warning, success = Theme.Success, info = Theme.Accent })[Kind],
	}, NoticeFrame)
	Create("Frame", {
		Size = UDim2.fromOffset(1, 26), Position = UDim2.fromOffset(48, 13), BackgroundColor3 = Theme.Line, BorderSizePixel = 0,
	}, NoticeFrame)
	CreateLabel({
		Size = UDim2.fromOffset(0, 16), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.fromOffset(60, 8),
		Text = NoticeTitle, TextSize = 14,
	}, NoticeFrame)
	CreateLabel({
		Size = UDim2.fromOffset(0, 14), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.fromOffset(60, 27),
		Text = NoticeBody, TextSize = 11, TextColor3 = Theme.DimText,
	}, NoticeFrame)

	PlayTween(NoticeFrame, { Position = UDim2.fromOffset(15, 60) }, 0.5, Enum.EasingStyle.Exponential)
	local NoticeInstance = NoticeGui
	task.delay(4, function()
		if NoticeGui ~= NoticeInstance then return end
		PlayTween(NoticeFrame, { Position = UDim2.fromOffset(-450, 60) }, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		task.wait(0.45)
		NoticeInstance:Destroy()
	end)
end

local EnteredKey, IsKeyVisible = "", false

local function RefreshKey()
	local IsMasked = not IsKeyVisible and #EnteredKey > 0
	KeyMaskLabel.Visible = IsMasked
	KeyMaskLabel.Text = ("●"):rep(#EnteredKey)
	KeyInput.TextTransparency = IsMasked and 1 or 0
	KeyEyeButton.Image = IsKeyVisible and Icons.eyeOn or Icons.eyeOff
	PlayTween(KeyEyeButton, { ImageColor3 = IsKeyVisible and Theme.Text or Theme.DimIcon }, 0.15)
end

local ShouldRememberKey = false

local function SetRemember(IsEnabled)
	ShouldRememberKey = IsEnabled
	PlayTween(RememberTrack, { BackgroundColor3 = IsEnabled and Theme.Accent:Lerp(Theme.Background, 0.78) or Theme.Element }, 0.2)
	PlayTween(RememberKnob, {
		BackgroundColor3 = IsEnabled and Theme.Accent or Theme.DimText,
		Position = UDim2.fromOffset(IsEnabled and 14 or 3, 3),
	}, 0.2)
	PlayTween(RememberGlow, { ImageTransparency = IsEnabled and 0.2 or 1 }, 0.2)
end

local function CloseUi(Duration)
	PlayTween(DimOverlay, { BackgroundTransparency = 1 }, Duration)
	PlayTween(KeyCard, { GroupTransparency = 1 }, Duration)
	PlayTween(KeyCardScale, { Scale = 0.95 }, Duration)
	task.wait(Duration + 0.05)
	KeyGui:Destroy()
end

local IsVerified = false

local function VerifyKey()
	if IsVerified then return end
	local Key = EnteredKey:match("^%s*(.-)%s*$")

	if Key == "" then
		SetStatus("Please enter a key!", Theme.Warning, 1, "warning")
		task.delay(1.5, function() if not IsVerified then SetStatus("Awaiting key input...", Theme.DimText, 0, "spin") end end)
		return
	end

	SetStatus("Verifying key...", Theme.Accent, 0.4, "spin")
	VerifyButton.Text = "Checking..."
	PlayTween(VerifyButton, { BackgroundColor3 = Theme.DimIcon }, 0.15)

	task.spawn(function()
		local IsKeyValid, KeyInfo, KeyError
		do
			local IsSdkLoaded, Sdk = pcall(function() return loadstring(game:HttpGet("https://sdk.luaprot.net/"))() end)
			if not IsSdkLoaded or type(Sdk) ~= "table" then
				KeyError = "Request failed"
			else
				local LastError, FailedChecks = nil, 0
				for _, Script in ipairs({ { id = "59659604850775143067", tier = "Paid" }, { id = "95270992519924057191", tier = "Free" } }) do
					Sdk.scriptId = Script.id
					local DidSucceed, CheckResult = pcall(Sdk.checkKey, Sdk, Key)
					if not (DidSucceed and type(CheckResult) == "table") then
						FailedChecks = FailedChecks + 1
					elseif CheckResult.status == "VALID" then
						local CheckData = CheckResult.data or {}
						local SecondsLeft = tonumber(CheckData.expire) or 0
						IsKeyValid = true
						KeyInfo = {
							timeLeft = SecondsLeft > 0 and ("%dd %dh %dm"):format(math.floor(SecondsLeft / 86400), math.floor(SecondsLeft % 86400 / 3600), math.floor(SecondsLeft % 3600 / 60)) or "Lifetime",
							keyType = CheckData.premium == false and "Free" or Script.tier,
							scriptId = Script.id,
						}
						break
					elseif CheckResult.status == "EXPIRED" then
						KeyError = "Key has expired"
						break
					elseif type(CheckResult.status) == "string" and CheckResult.status:find("HWID") then
						LastError = "Key locked to a different HWID. Reset it via the Discord bot."
					elseif type(CheckResult.status) == "string" and CheckResult.status:find("BLACKLIST") then
						LastError = "Key is blacklisted"
					elseif CheckResult.status == "INVALID_EXECUTOR" then
						LastError = "Executor not supported"
					elseif type(CheckResult.message) == "string" and CheckResult.message ~= "" and CheckResult.status ~= "INVALID" then
						LastError = CheckResult.message
					end
				end
				if not IsKeyValid and not KeyError then
					KeyError = FailedChecks == 2 and "Request failed" or (LastError or "Invalid Key")
				end
			end
		end

		if not IsKeyValid then
			if Key == ReadSaved() and KeyError ~= "Request failed" then
				DeleteSaved()
				Notify("Saved Data Removed", "Your saved key was invalid and has been cleared.", "warning")
			end
			SetStatus(KeyError, Theme.Error, 1, "error")
			VerifyButton.Text = "Verify Key"
			PlayTween(VerifyButton, { BackgroundColor3 = Theme.Accent }, 0.15)
			task.delay(1.5, function() if not IsVerified then SetStatus("Awaiting key input...", Theme.DimText, 0, "spin") end end)
			do
				local PopupGui = CreateScreenGui("SiliconPopup", 1000)
				MountGui(PopupGui)

				local PopupDim = Create("TextButton", {
					Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(), BackgroundTransparency = 1,
					Text = "", AutoButtonColor = false,
				}, PopupGui)

				local PopupCard = Create("CanvasGroup", {
					AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(320, 200),
					BackgroundColor3 = Theme.Section, BorderSizePixel = 0, GroupTransparency = 1, Active = true,
				}, PopupGui)
				Round(PopupCard, 8)
				AddStroke(PopupCard)
				local PopupScale = Create("UIScale", { Scale = 0.92 }, PopupCard)

				local IconCircle = Create("Frame", {
					Size = UDim2.fromOffset(44, 44), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 18),
					BackgroundColor3 = Theme.Error:Lerp(Theme.Section, 0.82), BorderSizePixel = 0,
				}, PopupCard)
				Round(IconCircle, 22)
				Create("ImageLabel", {
					Size = UDim2.fromOffset(22, 22), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1, Image = Icons.error, ImageColor3 = Theme.Error,
				}, IconCircle)

				CreateLabel({
					Size = UDim2.new(1, -40, 0, 20), Position = UDim2.fromOffset(20, 72), Text = "Access Denied",
					TextSize = 16, TextXAlignment = Enum.TextXAlignment.Center,
				}, PopupCard)
				CreateLabel({
					Size = UDim2.new(1, -40, 0, 40), Position = UDim2.fromOffset(20, 96), Text = KeyError,
					TextColor3 = Theme.DimText, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
					TextXAlignment = Enum.TextXAlignment.Center,
				}, PopupCard)

				local PopupClose = Create("TextButton", {
					Size = UDim2.new(1, -28, 0, 30), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -14),
					BackgroundColor3 = Theme.Element, BorderSizePixel = 0, Text = "Close", TextColor3 = Theme.Text,
					TextSize = 14, FontFace = UIFont, AutoButtonColor = false,
				}, PopupCard)
				Round(PopupClose, 4)
				PopupClose.MouseEnter:Connect(function() PlayTween(PopupClose, { BackgroundColor3 = Theme.Line }, 0.15) end)
				PopupClose.MouseLeave:Connect(function() PlayTween(PopupClose, { BackgroundColor3 = Theme.Element }, 0.15) end)

				local EscapeConn
				local function DismissPopup()
					EscapeConn:Disconnect()
					PlayTween(PopupDim, { BackgroundTransparency = 1 }, 0.25)
					PlayTween(PopupCard, { GroupTransparency = 1 }, 0.25)
					PlayTween(PopupScale, { Scale = 0.95 }, 0.25)
					task.delay(0.3, function() PopupGui:Destroy() end)
				end
				EscapeConn = UserInputService.InputBegan:Connect(function(Input, Processed)
					if not Processed and Input.KeyCode == Enum.KeyCode.Escape then DismissPopup() end
				end)
				PopupDim.MouseButton1Click:Connect(DismissPopup)
				PopupClose.MouseButton1Click:Connect(DismissPopup)

				PlayTween(PopupDim, { BackgroundTransparency = 0.65 }, 0.3)
				PlayTween(PopupCard, { GroupTransparency = 0 }, 0.3)
				PlayTween(PopupScale, { Scale = 1 }, 0.35, Enum.EasingStyle.Back)
			end
			return
		end

		IsVerified = true
		if ShouldRememberKey then SaveKey(Key) else DeleteSaved() end

		SetStatus("Key verified successfully!", Theme.Success, 1, "success")
		TimeLeftLabel.Text = "Time Left:  " .. KeyInfo.timeLeft
		KeyTypeLabel.Text = "Key Type:  " .. KeyInfo.keyType
		VerifyButton.Text = "Verified!"
		PlayTween(VerifyButton, { BackgroundColor3 = Theme.Success }, 0.2)
		PlayTween(KeyInputStroke, { Color = Theme.Success }, 0.2)

		task.wait(2)
		CloseUi(0.4)

		Env.lp_key, Env.script_key = Key, Key
		pcall(function()
			local Sdk = loadstring(game:HttpGet("https://sdk.luaprot.net/"))()
			Sdk.scriptId = KeyInfo.scriptId
			Sdk:loadScript()
		end)
		Env.lp_key, Env.script_key = nil, nil
	end)
end

KeyInput:GetPropertyChangedSignal("Text"):Connect(function()
	EnteredKey = KeyInput.Text
	RefreshKey()
end)
KeyInput.Focused:Connect(function() PlayTween(KeyInputStroke, { Color = Theme.Accent }, 0.15) end)
KeyInput.FocusLost:Connect(function()
	if not IsVerified then PlayTween(KeyInputStroke, { Color = Theme.Line }, 0.15) end
end)

KeyEyeButton.MouseButton1Click:Connect(function()
	IsKeyVisible = not IsKeyVisible
	RefreshKey()
end)

RememberHit.MouseButton1Click:Connect(function()
	SetRemember(not ShouldRememberKey)
	if not ShouldRememberKey then DeleteSaved() end
end)

CloseUiButton.MouseButton1Click:Connect(function()
	if not ShouldRememberKey then DeleteSaved() end
	CloseUi(0.3)
end)

GetKeyButton.MouseButton1Click:Connect(function()
	local CopyToClipboard = setclipboard or toclipboard
	if CopyToClipboard then pcall(CopyToClipboard, "https://getsilicon.lol/getkey") end
	local OpenUrl = (syn and syn.open_browser_for) or open_browser_for
	if OpenUrl then pcall(OpenUrl, "https://getsilicon.lol/getkey") end
	Notify("Get Key", "Opened key website & copied URL to clipboard.", "info")
end)

VerifyButton.MouseEnter:Connect(function()
	if not IsVerified then PlayTween(VerifyButton, { BackgroundColor3 = Theme.AccentHover }, 0.15) end
end)
VerifyButton.MouseLeave:Connect(function()
	if not IsVerified and VerifyButton.Text == "Verify Key" then PlayTween(VerifyButton, { BackgroundColor3 = Theme.Accent }, 0.15) end
end)
VerifyButton.MouseButton1Click:Connect(VerifyKey)

SetStatus("Awaiting key input...", Theme.DimText, 0, "spin")
SetRemember(false)
PlayTween(DimOverlay, { BackgroundTransparency = 0.65 }, 0.35)
PlayTween(KeyCard, { GroupTransparency = 0 }, 0.3)
PlayTween(KeyCardScale, { Scale = 1 }, 0.35, Enum.EasingStyle.Back)
for RowIndex, Row in ipairs(FadeRows) do
	task.delay(0.15 + RowIndex * 0.05, function() PlayTween(Row, { GroupTransparency = 0 }, 0.25) end)
end

task.defer(function()
	if ShouldRemoveData then DeleteSaved() end

	local SavedKey = not ShouldRemoveData and ReadSaved() or nil
	local KeyToFill = PresetKey or SavedKey
	if not KeyToFill then return end

	-- A saved key only exists when Remember was on at verify time, so a
	-- restore means the toggle is enabled and the key auto-verifies.
	if SavedKey and not PresetKey then SetRemember(true) end
	KeyInput.Text = KeyToFill
	task.wait(0.9)
	VerifyKey()
end)
