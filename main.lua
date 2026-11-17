--[[
    febrysurya v2 - UI untuk Delta Executor (TAMPILAN SAJA)
    Elemen : Toggle, Button, Slider, Dropdown, Input, Label, Section, Notifikasi
    Fitur  : draggable (mouse & sentuh), minimize, tombol buka/tutup melayang, animasi
    Semua callback masih kosong -> isi sendiri di bagian "TODO".
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local function getParent()
    local ok, ui = pcall(function() return gethui and gethui() end)
    if ok and ui then return ui end
    if pcall(function() return CoreGui.Name end) then return CoreGui end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local parent = getParent()
if parent:FindFirstChild("febrysurya") then parent.febrysurya:Destroy() end

-- ========== Tema ==========
local T = {
    Background = Color3.fromRGB(12, 16, 14),
    Topbar     = Color3.fromRGB(18, 25, 21),
    Sidebar    = Color3.fromRGB(15, 21, 18),
    Element    = Color3.fromRGB(24, 33, 28),
    Hover      = Color3.fromRGB(32, 44, 38),
    Accent     = Color3.fromRGB(0, 210, 130),
    AccentDark = Color3.fromRGB(0, 140, 95),
    Text       = Color3.fromRGB(235, 248, 241),
    SubText    = Color3.fromRGB(125, 155, 140),
    Off        = Color3.fromRGB(50, 66, 58),
    Danger     = Color3.fromRGB(230, 80, 80),
}

-- ========== Helper ==========
local function new(class, props, children)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = o end
    return o
end
local function round(r) return new("UICorner", { CornerRadius = UDim.new(0, r or 8) }) end
local function stroke(c, th, tr)
    return new("UIStroke", {
        Color = c or T.Accent, Thickness = th or 1, Transparency = tr or 0.7,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end
local function pad(l, t, r, b)
    return new("UIPadding", {
        PaddingLeft = UDim.new(0, l or 0), PaddingTop = UDim.new(0, t or 0),
        PaddingRight = UDim.new(0, r or 0), PaddingBottom = UDim.new(0, b or 0),
    })
end
local function tween(o, p, t)
    TweenService:Create(o, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad), p):Play()
end
local function label(props)
    props.BackgroundTransparency = 1
    props.TextColor3 = props.TextColor3 or T.Text
    props.Font = props.Font or Enum.Font.GothamMedium
    props.TextSize = props.TextSize or 13
    props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    return new("TextLabel", props)
end
local function draggable(handle, target)
    local dragging, start, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, start, startPos = true, i.Position, target.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ========== ScreenGui ==========
local gui = new("ScreenGui", { Name = "febrysurya", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
gui.Parent = parent

local W, H, TOP = 520, 330, 40

local main = new("Frame", {
    Name = "Main", Size = UDim2.fromOffset(W, H),
    Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2),
    BackgroundColor3 = T.Background, BorderSizePixel = 0, ClipsDescendants = true, Parent = gui,
}, { round(12), stroke(T.Accent, 1, 0.6) })

-- ========== Topbar ==========
local topbar = new("Frame", {
    Size = UDim2.new(1, 0, 0, TOP), BackgroundColor3 = T.Topbar, BorderSizePixel = 0, Parent = main,
})
new("Frame", { -- garis aksen bawah topbar
    Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2),
    BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = topbar,
}, { new("UIGradient", {
    Color = ColorSequence.new(T.Accent, T.AccentDark),
    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }),
}) })
new("Frame", {
    Size = UDim2.fromOffset(8, 8), Position = UDim2.fromOffset(14, 16),
    BackgroundColor3 = T.Accent, Parent = topbar,
}, { round(4) })
label({ Text = "febrysurya", Font = Enum.Font.GothamBold, TextSize = 15,
    Size = UDim2.fromOffset(110, TOP), Position = UDim2.fromOffset(28, 0), Parent = topbar })
label({ Text = "v2.0  •  Delta", TextSize = 11, TextColor3 = T.SubText,
    Size = UDim2.fromOffset(100, TOP), Position = UDim2.fromOffset(122, 1), Parent = topbar })

local function topBtn(text, x, bg)
    return new("TextButton", {
        Size = UDim2.fromOffset(28, 24), Position = UDim2.new(1, x, 0, 8),
        BackgroundColor3 = bg, Text = text, TextColor3 = T.Text,
        Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = true, Parent = topbar,
    }, { round(7) })
end
local closeBtn = topBtn("X", -36, T.Danger)
local minBtn = topBtn("-", -70, T.Element)
draggable(topbar, main)

-- ========== Body ==========
local body = new("Frame", {
    Size = UDim2.new(1, 0, 1, -TOP), Position = UDim2.fromOffset(0, TOP), BackgroundTransparency = 1, Parent = main,
})
local sidebar = new("ScrollingFrame", {
    Size = UDim2.new(0, 118, 1, 0), BackgroundColor3 = T.Sidebar, BorderSizePixel = 0,
    ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = body,
}, { new("UIListLayout", { Padding = UDim.new(0, 4) }), pad(8, 10, 8, 10) })
local pages = new("Frame", {
    Size = UDim2.new(1, -118, 1, 0), Position = UDim2.fromOffset(118, 0), BackgroundTransparency = 1, Parent = body,
})

-- ========== Notifikasi ==========
local toastHolder = new("Frame", {
    Size = UDim2.new(0, 240, 1, -24), Position = UDim2.new(1, -252, 0, 12),
    BackgroundTransparency = 1, Parent = gui,
}, { new("UIListLayout", { Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Top }) })

local function notify(title, text, secs)
    local toast = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = T.Topbar, ClipsDescendants = true, Parent = toastHolder,
    }, { round(9), stroke(T.Accent, 1, 0.5) })
    new("Frame", { Size = UDim2.new(0, 3, 1, 0), BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = toast })
    label({ Text = title, Font = Enum.Font.GothamBold, TextSize = 13,
        Size = UDim2.new(1, -20, 0, 18), Position = UDim2.fromOffset(14, 7), Parent = toast })
    label({ Text = text, TextSize = 12, TextColor3 = T.SubText, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
        Size = UDim2.new(1, -20, 0, 28), Position = UDim2.fromOffset(14, 25), Parent = toast })
    tween(toast, { Size = UDim2.new(1, 0, 0, 58) }, 0.25)
    task.delay(secs or 3, function()
        if toast.Parent then
            tween(toast, { Size = UDim2.new(1, 0, 0, 0) }, 0.25)
            task.wait(0.3)
            toast:Destroy()
        end
    end)
end

-- ========== Library ==========
local Library = { Notify = notify }
local tabs = {}

function Library:AddTab(icon, name)
    local page = new("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, -16), Position = UDim2.fromOffset(8, 8),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = T.Accent,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = pages,
    }, { new("UIListLayout", { Padding = UDim.new(0, 7) }), pad(0, 0, 5, 0) })

    local btn = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = T.Sidebar, Text = "", AutoButtonColor = false, Parent = sidebar,
    }, { round(8) })
    local bar = new("Frame", {
        Size = UDim2.fromOffset(3, 16), Position = UDim2.new(0, 0, 0.5, -8),
        BackgroundColor3 = T.Accent, Visible = false, Parent = btn,
    }, { round(2) })
    label({ Text = icon, TextSize = 15, Size = UDim2.fromOffset(26, 34), Position = UDim2.fromOffset(8, 0),
        TextXAlignment = Enum.TextXAlignment.Center, Parent = btn })
    local txt = label({ Text = name, TextColor3 = T.SubText, TextSize = 12,
        Size = UDim2.new(1, -40, 1, 0), Position = UDim2.fromOffset(36, 0), Parent = btn })

    local tab = { Page = page, Button = btn, Bar = bar, Txt = txt }
    table.insert(tabs, tab)

    local function select()
        for _, t in ipairs(tabs) do
            t.Page.Visible = false
            t.Bar.Visible = false
            tween(t.Button, { BackgroundColor3 = T.Sidebar })
            tween(t.Txt, { TextColor3 = T.SubText })
        end
        page.Visible = true
        bar.Visible = true
        tween(btn, { BackgroundColor3 = T.Element })
        tween(txt, { TextColor3 = T.Accent })
    end
    tab.Select = select
    btn.MouseButton1Click:Connect(select)

    local function row(h)
        return new("Frame", { Size = UDim2.new(1, 0, 0, h or 36), BackgroundColor3 = T.Element, Parent = page },
            { round(8), stroke(T.Accent, 1, 0.88) })
    end

    function tab:AddSection(text)
        local f = new("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = page })
        label({ Text = string.upper(text), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = T.Accent,
            Size = UDim2.new(1, 0, 1, 0), Parent = f })
        return f
    end

    function tab:AddLabel(text)
        local r = row(30)
        local l = label({ Text = text, TextColor3 = T.SubText, TextSize = 12,
            Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(10, 0), Parent = r })
        return { Set = function(_, s) l.Text = s end }
    end

    function tab:AddButton(text, callback)
        local b = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = T.Element, Text = text, TextColor3 = T.Text,
            Font = Enum.Font.GothamMedium, TextSize = 13, AutoButtonColor = false, Parent = page,
        }, { round(8), stroke(T.Accent, 1, 0.6) })
        b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = T.Hover }) end)
        b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = T.Element }) end)
        b.MouseButton1Click:Connect(function()
            tween(b, { BackgroundColor3 = T.AccentDark }, 0.08)
            task.delay(0.1, function() tween(b, { BackgroundColor3 = T.Element }) end)
            if callback then callback() end
        end)
        return b
    end

    function tab:AddToggle(text, default, callback)
        local state = default or false
        local r = row(36)
        label({ Text = text, Size = UDim2.new(1, -64, 1, 0), Position = UDim2.fromOffset(12, 0), Parent = r })
        local track = new("TextButton", {
            Size = UDim2.fromOffset(40, 20), Position = UDim2.new(1, -52, 0.5, -10),
            BackgroundColor3 = state and T.Accent or T.Off, Text = "", AutoButtonColor = false, Parent = r,
        }, { round(10) })
        local knob = new("Frame", {
            Size = UDim2.fromOffset(16, 16), Position = state and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2),
            BackgroundColor3 = Color3.new(1, 1, 1), Parent = track,
        }, { round(8) })
        local function apply(s, fire)
            state = s
            tween(track, { BackgroundColor3 = s and T.Accent or T.Off })
            tween(knob, { Position = s and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2) })
            if fire and callback then callback(s) end
        end
        track.MouseButton1Click:Connect(function() apply(not state, true) end)
        return { Set = function(_, s) apply(s, false) end, Get = function() return state end }
    end

    function tab:AddSlider(text, min, max, default, callback, suffix)
        local value = default or min
        suffix = suffix or ""
        local r = row(50)
        label({ Text = text, Size = UDim2.new(1, -90, 0, 24), Position = UDim2.fromOffset(12, 2), Parent = r })
        local val = label({ Text = value .. suffix, TextColor3 = T.Accent, Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Right, Size = UDim2.fromOffset(80, 24),
            Position = UDim2.new(1, -92, 0, 2), Parent = r })
        local bar = new("Frame", {
            Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(12, 34), BackgroundColor3 = T.Off, Parent = r,
        }, { round(3) })
        local fill = new("Frame", {
            Size = UDim2.fromScale((value - min) / (max - min), 1), BackgroundColor3 = T.Accent, Parent = bar,
        }, { round(3) })
        local knob = new("Frame", {
            Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0), BackgroundColor3 = Color3.new(1, 1, 1), Parent = bar,
        }, { round(7) })

        local function setFromX(x)
            local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + rel * (max - min) + 0.5)
            local p = (value - min) / (max - min)
            fill.Size = UDim2.fromScale(p, 1)
            knob.Position = UDim2.new(p, 0, 0.5, 0)
            val.Text = value .. suffix
            if callback then callback(value) end
        end
        local dragging = false
        r.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromX(i.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                setFromX(i.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        return { Get = function() return value end }
    end

    function tab:AddDropdown(text, options, default, callback)
        local current = default or options[1]
        local holder = new("Frame", {
            Size = UDim2.new(1, 0, 0, 36), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = page,
        }, { new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }) })
        local head = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 36), LayoutOrder = 1, BackgroundColor3 = T.Element,
            Text = "", AutoButtonColor = false, Parent = holder,
        }, { round(8), stroke(T.Accent, 1, 0.88) })
        label({ Text = text, Size = UDim2.new(0.5, -12, 1, 0), Position = UDim2.fromOffset(12, 0), Parent = head })
        local shown = label({ Text = current .. "  v", TextColor3 = T.Accent, TextXAlignment = Enum.TextXAlignment.Right,
            Size = UDim2.new(0.5, -12, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), Parent = head })
        local list = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2,
            BackgroundColor3 = T.Sidebar, Visible = false, Parent = holder,
        }, { round(8), new("UIListLayout", { Padding = UDim.new(0, 2) }), pad(4, 4, 4, 4) })
        for _, opt in ipairs(options) do
            local ob = new("TextButton", {
                Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = T.Sidebar, Text = opt,
                TextColor3 = T.Text, Font = Enum.Font.Gotham, TextSize = 12, AutoButtonColor = false, Parent = list,
            }, { round(6) })
            ob.MouseEnter:Connect(function() tween(ob, { BackgroundColor3 = T.Hover }) end)
            ob.MouseLeave:Connect(function() tween(ob, { BackgroundColor3 = T.Sidebar }) end)
            ob.MouseButton1Click:Connect(function()
                current = opt
                shown.Text = opt .. "  v"
                list.Visible = false
                if callback then callback(opt) end
            end)
        end
        head.MouseButton1Click:Connect(function() list.Visible = not list.Visible end)
        return { Get = function() return current end }
    end

    function tab:AddInput(text, default, placeholder, callback)
        local r = row(36)
        label({ Text = text, Size = UDim2.new(1, -150, 1, 0), Position = UDim2.fromOffset(12, 0), Parent = r })
        local box = new("TextBox", {
            Size = UDim2.fromOffset(130, 24), Position = UDim2.new(1, -140, 0.5, -12),
            BackgroundColor3 = T.Background, Text = default or "", PlaceholderText = placeholder or "",
            PlaceholderColor3 = T.SubText, TextColor3 = T.Text, Font = Enum.Font.Gotham, TextSize = 12,
            ClearTextOnFocus = false, Parent = r,
        }, { round(6), stroke(T.Accent, 1, 0.75) })
        box.FocusLost:Connect(function() if callback then callback(box.Text) end end)
        return box
    end

    return tab
end

-- ==========================================================
-- ISI UI (contoh susunan). Ganti nama, tambah, atau hapus sesuka hati.
-- ==========================================================

-- 1) Farm
local farm = Library:AddTab("🌱", "Farm")
farm:AddSection("Kontrol")
farm:AddToggle("Auto Farm", false, function(v)
    -- TODO: logika Auto Farm
    print("Auto Farm:", v)
end)
farm:AddDropdown("Mode", { "Place + Break", "Break saja", "Place saja" }, "Place + Break", function(v)
    -- TODO: ganti mode
    print("Mode:", v)
end)
farm:AddSection("Kecepatan")
farm:AddSlider("Jeda setelah place", 50, 1000, 250, function(v) print("Place ms:", v) end, " ms")
farm:AddSlider("Jeda tiap pukulan", 50, 1000, 220, function(v) print("Break ms:", v) end, " ms")
farm:AddSection("Opsi")
farm:AddToggle("Ambil drop otomatis", true, function(v) print("Collect:", v) end)
farm:AddToggle("Mode Lite", false, function(v) print("Lite:", v) end)

-- 2) Clear
local clear = Library:AddTab("🧹", "Clear")
clear:AddSection("Status")
local clearStatus = clear:AddLabel("Status: -")
clear:AddSection("Kontrol")
clear:AddToggle("Jalankan Clear", false, function(v) print("Clear:", v) end)
clear:AddDropdown("Arah sapu", { "Kiri → Kanan", "Zig-zag" }, "Kiri → Kanan", function(v) print("Arah:", v) end)
clear:AddToggle("Ikut pecah background", true, function(v) print("BG:", v) end)
clear:AddToggle("Pakai block pijakan", true, function(v) print("Pijakan:", v) end)
clear:AddButton("Reset tile yang dilewati", function()
    Library.Notify("Clear", "Daftar tile dilewati sudah di-reset.")
end)

-- 3) Farmer
local farmer = Library:AddTab("🌾", "Farmer")
farmer:AddSection("Kontrol")
farmer:AddToggle("Jalankan Farmer", false, function(v) print("Farmer:", v) end)
farmer:AddToggle("Panen otomatis", true, function(v) print("Panen:", v) end)
farmer:AddToggle("Tanam otomatis", true, function(v) print("Tanam:", v) end)
farmer:AddSection("Waktu")
farmer:AddSlider("Jeda setelah panen", 50, 1000, 250, function(v) print("Panen ms:", v) end, " ms")
farmer:AddSlider("Jeda setelah tanam", 50, 1000, 250, function(v) print("Tanam ms:", v) end, " ms")

-- 4) Pabrik
local pabrik = Library:AddTab("🏭", "Pabrik")
pabrik:AddSection("Kontrol")
pabrik:AddToggle("Jalankan Pabrik", false, function(v) print("Pabrik:", v) end)
pabrik:AddToggle("Drop seed lebihan", true, function(v) print("Drop:", v) end)
pabrik:AddSection("Pengaturan")
pabrik:AddSlider("Sisakan seed", 0, 200, 50, function(v) print("Keep:", v) end)
pabrik:AddSlider("Drop kalau sudah", 50, 200, 200, function(v) print("Drop at:", v) end)
pabrik:AddInput("World tu
