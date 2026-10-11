#Requires AutoHotkey 2.0+
#SingleInstance Force

CoordMode("Mouse")
SetTitleMatchMode("RegEx")
DetectHiddenWindows true

^!-::toggle_app(".*default\.ahk.*", 'gvim ' EnvGet("USERPROFILE") '\default.ahk')
^!=::BlinkFrame(), Sleep(500), Reload()

^#j::SendInput("{Down}")
^#k::SendInput("{Up}")
^#h::SendInput("{Left}")
^#l::SendInput("{Right}")

^#a::SendInput("{Home}")
^#e::SendInput("{End}")
^#i::SendInput("{Home}")
^#o::SendInput("{End}")

^#u::SendInput("^{Home}")
^#p::SendInput("^{End}")

^#,::SendInput("^{Left}")
^#.::SendInput("^{Right}")

^#+i::SendInput("^+{Home}")
^#+o::SendInput("^+{End}")
^#+u::SendInput("^+{Home}")
^#+p::SendInput("^+{End}")

^#+,::SendInput("^+{Left}")
^#+.::SendInput("^+{Right}")

^!a::SendInput("#+{Right}")

^#[::SendInput("{PgUp}")
^#]::SendInput("{PgDn}")

^#+h::SendInput("!{Left}")
^#+l::SendInput("!{Right}")
^#+k::SendInput("!{Up}")
^#+j::SendInput("!{Down}")

^Rctrl::SendInput("{AppsKey}")

^!h::SnapWindow("left")
^!l::SnapWindow("right")

^!s:: FocusOtherMonitor()

!^q::SendInput("!{F4}")
!^f::SendInput("{F11}")

^!enter::SwapMonitors(1, 2)

^!+f::HideTaskbar()
!^d::Run(".\Downloads")

^!+[::send_to_window(".*YouTube.*", "{Left}")
^!+]::send_to_window(".*YouTube.*", "{Right}")
^!+enter::Send("{Media_Play_Pause}")
^!+-::Send("{Volume_Down}")
^!+=::Send("{Volume_Up}")

^!esc::toggle_app(".*Yazi: .*", "wezterm-gui start -- yazi ' EnvGet("USERPROFILE") '\Downloads')
!^Backspace::toggle_app(".*Obsidian.*", "Obsidian")
^Enter::toggle_app('.*\.pdf.*', 'sioyek')
^!Rshift::RunCentered("chrome --new-window --app=https://www.youtube.com", '.*YouTube$')
^#s::Run("chrome")

+Backspace::SetInputLang(0x0409)
^+Backspace::SetInputLang(0x0404), Send("^+{7}")
^+Enter::SetInputLang(0x0404), Send("^+{8}")

!+h::Run(A_ComSpec " /c task calendar && pause")
!+j::Run(A_ComSpec " /c it-open-url-bookmark.cmd")
!+w::Run(A_ComSpec ' /c buku -w "gvim -f"')

toggle_app(title_regex, app_cmd) {
	if WinActive(title_regex) {
		WinMinimize
	} else if WinExist(title_regex) {
		WinActivate(title_regex)
	} else {
		Run(app_cmd,  , "Max")
	}
	SetInputLang(0x0409)
}

BlinkFrame(color := "E0E0E0", thickness := 4, duration := 200) {
    edges := []
    
    ; Define the 4 rectangles: Top, Bottom, Left, Right
    ; [x, y, width, height]
    coords := [
        ; [0, 0, A_ScreenWidth, thickness],                      ; Top
        [0, A_ScreenHeight - thickness, A_ScreenWidth, thickness], ; Bottom
        ; [0, 0, thickness, A_ScreenHeight],                     ; Left
        ; [A_ScreenWidth - thickness, 0, thickness, A_ScreenHeight]  ; Right
    ]
    
    ; Create and show each edge
    for i, c in coords {
        edge := Gui("-Caption +AlwaysOnTop +ToolWindow +E0x20") ; E0x20 makes it click-through
        edge.BackColor := color
        edge.Show("x" c[1] " y" c[2] " w" c[3] " h" c[4] " NoActivate")
        edges.Push(edge)
    }
    
    ; Keep visible for the duration, then destroy all
    SetTimer(() => DestroyEdges(edges), -duration)
}

DestroyEdges(edges) {
    for edge in edges {
        edge.Destroy()
    }
}

send_to_window(target, keys) {
    prev := WinExist("A")              ; handle of the currently active window
    if !WinExist(target)
        return false

    WinActivate                         ; uses the window found by WinExist above
    if !WinWaitActive(target, , 2)      ; wait up to 2s for focus
        return false

    Send keys
    Sleep 50                            ; let the keystrokes get processed

    if WinExist("ahk_id " prev)         ; original window may have closed
        WinActivate "ahk_id " prev
    return true
}

SetInputLang(languageIdentifier) {
    WinExist("A")
    CtrlInFocus := ControlGetFocus("A")
    PostMessage(0x50, 0, languageIdentifier)
}

OnError(ForceErrorFocus)

;; make error message dialogue always bringed to foremost
ForceErrorFocus(exception, mode) {
    ; Small delay to allow the dialog window to actually exist
    SetTimer(() => WinActivate("ahk_class #32770 ahk_exe AutoHotkey64.exe"), -100)
    return 0 ; Continue to standard error dialog
}

; registered copy

global Registers := Map()
global RegDir := A_ScriptDir "\registers"

if !DirExist(RegDir)
    DirCreate(RegDir)

; --- load persisted registers on startup ---
Loop Files, RegDir "\*.txt" {
    letter := StrReplace(A_LoopFileName, ".txt", "")
    Registers[letter] := FileRead(A_LoopFileFullPath, "UTF-8")
}

Hotkey "^#'", EnterMode.Bind("paste")
Hotkey '^#"', EnterMode.Bind("yank")

; Waits for the next single letter key after the leader combo,
; then dispatches to yank or paste. Escape cancels; 3s timeout.
EnterMode(action, *) {
    ToolTip (action = "yank" ? "Save to register..." : "Paste from register...")

    ih := InputHook("L1 T3", "{Escape}")
    ih.Start()
    ih.Wait()
    ToolTip()

    if ih.EndReason = "EndKey" || ih.Input = ""
        return                                  ; cancelled or timed out

    letter := ih.Input
    if !RegExMatch(letter, "^[A-Za-z]$")
        return                                  ; not a letter, ignore

    isAppend := (letter == StrUpper(letter))     ; typed with Shift held = append
    reg := StrLower(letter)

    if action = "yank"
        YankToRegister(reg, isAppend)
    else
        PasteFromRegister(reg)
}

YankToRegister(reg, append) {
    ClipSaved := ClipboardAll()
    A_Clipboard := ""
    Send "^c"
    if !ClipWait(1) {
        A_Clipboard := ClipSaved
        return
    }
    text := A_Clipboard

    if append && Registers.Has(reg)
        Registers[reg] .= "`n" text
    else
        Registers[reg] := text

    SaveRegister(reg)
    A_Clipboard := ClipSaved

    ToolTip (append ? 'Appended to "' : 'Saved to "') reg '"'
    SetTimer () => ToolTip(), -800
}

PasteFromRegister(reg) {
    if !Registers.Has(reg) {
        ToolTip 'Register "' reg '" is empty'
        SetTimer () => ToolTip(), -800
        return
    }
    ClipSaved := ClipboardAll()
    A_Clipboard := Registers[reg]
    Send "^v"
    Sleep 150
    A_Clipboard := ClipSaved
}

SaveRegister(reg) {
    path := RegDir "\" reg ".txt"
    if FileExist(path)
        FileDelete path
    FileAppend Registers[reg], path, "UTF-8"
}

marks := Map()   ; case-sensitive by default, so 'a' and 'A' are different marks

Flash(text) {
    ToolTip(text)
    SetTimer(() => ToolTip(), -1200)
}

ReadKey() {
    ih := InputHook("L1 T3")   ; capture 1 char, 3s timeout, key is suppressed
    ih.Start()
    ih.Wait()
    return (ih.EndReason = "Max") ? ih.Input : ""
}

; set mark on the active window
^!+':: {
    key := ReadKey()
    if key = ""
        return
    hwnd := WinExist("A")
    marks[key] := hwnd
    Flash("Mark '" key "' set: " WinGetTitle("ahk_id " hwnd))
}

; Win+' + <symbol>  ->  jump to marked window
^!':: {
    key := ReadKey()
    if key = ""
        return
    if !marks.Has(key) {
        Flash("Mark '" key "' not set")
        return
    }
    hwnd := marks[key]
    if !WinExist("ahk_id " hwnd) {
        marks.Delete(key)
        Flash("Mark '" key "': window no longer exists")
        return
    }
    if WinGetMinMax("ahk_id " hwnd) = -1
        WinRestore("ahk_id " hwnd)
    WinActivate("ahk_id " hwnd)
}

DllCall("SetThreadDpiAwarenessContext", "Ptr", -4)  ; per-monitor DPI aware, keeps coordinates consistent
CoordMode "Mouse", "Screen"

;; Ctrl+Alt+C: left-click the center of the focused window
^!\:: {
     hwnd := WinExist("A")
     if !hwnd
         return
     if WinGetMinMax(hwnd) = -1 {          ; minimized windows have bogus coordinates
         MsgBox "Window is minimized."
         return
     }
 
     WinGetPos &x, &y, &w, &h, hwnd
     cx := x + w // 10 * 9
     cy := y + h // 11 * 6
 
     MouseGetPos &oldX, &oldY              ; remember where the cursor was
     Click cx, cy                          ; left click at the center
 }

RunCentered(target, match := "", monitor := 2, wscale := 4/5, hscale := 6/7) {
    if WinActive(match) {
        Send("!{Esc}")
        return
    } else if WinExist(match) {
        WinActivate(match)
        return
    }

    if monitor > MonitorGetCount()
        monitor := MonitorGetPrimary()   ; fall back if monitor 2 isn't there

    MonitorGet(monitor, &L, &T, &R, &B)
    mw := R - L, mh := B - T
    w := Round(mw * wscale), h := Round(mh * hscale)
    x := L + (mw - w) // 2
    y := T + (mh - h) // 2

    Run(target, , , &pid)
    if !WinWait(match != "" ? match : "ahk_pid " pid, , 10) {
        MsgBox("Window not found. Try a different match string.")
        return
    }
    hwnd := "ahk_id " WinExist()        ; the window WinWait just found
    WinRestore(hwnd)
    WinMove(x, y, w, h, hwnd)
}

DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")   ; per-monitor DPI
CoordMode "Mouse", "Screen"
SetDefaultMouseSpeed 0
SetMouseDelay 15

; ---- Config ----------------------------------------------------------------
global CommitMode := "mouse"   ; "mouse"   = real title-bar drag (real OS move loop)
                               ; "message" = send WM_ENTERSIZEMOVE/WM_EXITSIZEMOVE only
global Wigglepx   := 1         ; pixels to move away and back during the drag
; ---- Snap ------------------------------------------------------------------
SnapWindow(side) {
    hwnd := WinExist("A")
    if !hwnd
        return

    WinGetPos(&x, &y, &w, &h, hwnd)
    cx := x + w // 2, cy := y + h // 2
    mon := MonitorGetPrimary()
    Loop MonitorGetCount() {
        MonitorGetWorkArea(A_Index, &l, &t, &r, &b)
        if (cx >= l && cx < r && cy >= t && cy < b) {
            mon := A_Index
            break
        }
    }

    MonitorGetWorkArea(mon, &L, &T, &R, &B)
    halfW := (R - L) // 2
    GetFrameInset(hwnd, &il, &it, &ir, &ib)

    if (side = "left") {
        nx := L - il, nw := halfW + il + ir
    } else {
        nx := L + halfW - il, nw := (R - L - halfW) + il + ir
    }
    ny := T - it, nh := (B - T) + it + ib

    SetNormalPlacement(hwnd, nx, ny, nw, nh)

    if (CommitMode = "mouse")
        CommitLikeDrag(hwnd)
    else
        CommitViaMessages(hwnd)
}

; Writes the rect as the window's NORMAL position and shows it as a normal window.
; WINDOWPLACEMENT uses workspace coords (relative to the primary monitor's work area).
SetNormalPlacement(hwnd, x, y, w, h) {
    wp := Buffer(44, 0)
    NumPut("uint", 44, wp, 0)
    DllCall("GetWindowPlacement", "ptr", hwnd, "ptr", wp)
    MonitorGetWorkArea(MonitorGetPrimary(), &pl, &pt)
    NumPut("uint", 1, wp, 8)                                   ; SW_SHOWNORMAL
    NumPut("int", x - pl,     "int", y - pt,
           "int", x - pl + w, "int", y - pt + h, wp, 28)       ; rcNormalPosition
    DllCall("SetWindowPlacement", "ptr", hwnd, "ptr", wp)
}

; ---- Commit method A: real title-bar drag -----------------------------------
CommitLikeDrag(hwnd) {
    ; Held Win/Alt keys would turn our mouse events into Alt+drag etc.
    for k in ["LWin", "RWin", "LAlt", "RAlt", "Left", "Right"]
        KeyWait k, "T2"
    Sleep 80

    if !FindGrabPoint(hwnd, &px, &py) {
        CommitViaMessages(hwnd)     ; no safe spot to grab: fall back to messages
        return
    }

    MouseGetPos(&ox, &oy)
    isDown := false
    try {
        MouseMove(px, py, 0)
        Sleep 30
        Click "Down"
        isDown := true
        Sleep 30
        Loop Wigglepx {             ; move away...
            MouseMove(1, 0, 0, "R")
            Sleep 8
        }
        Sleep 30
        Loop Wigglepx {             ; ...and back to the exact same pixel
            MouseMove(-1, 0, 0, "R")
            Sleep 8
        }
        Sleep 30
    } finally {
        if isDown
            Click "Up"
        MouseMove(ox, oy, 0)
    }
}

; Find a point on the title bar the OS reports as draggable caption (HTCAPTION),
; so we never grab a Chrome tab, a button, or a menu.
FindGrabPoint(hwnd, &px, &py) {
    WinGetPos(&x, &y, &w, &h, hwnd)
    for dy in [10, 16, 22] {
        py := y + dy
        px := x + 120
        while (px < x + w - 200) {
            lParam := ((py & 0xFFFF) << 16) | (px & 0xFFFF)
            if (SendMessage(0x84, 0, lParam, , "ahk_id " hwnd) = 2) {   ; HTCAPTION
                pt := (py << 32) | (px & 0xFFFFFFFF)
                hit := DllCall("WindowFromPoint", "int64", pt, "ptr")
                if (DllCall("GetAncestor", "ptr", hit, "uint", 2, "ptr") = hwnd)
                    return true
            }
            px += 20
        }
    }
    return false
}

; ---- Commit method B: messages only -----------------------------------------
CommitViaMessages(hwnd) {
    static WM_ENTERSIZEMOVE := 0x0231, WM_EXITSIZEMOVE := 0x0232
    id := "ahk_id " hwnd
    try {
        WinGetPos(&x, &y, , , hwnd)
        SendMessage(WM_ENTERSIZEMOVE, 0, 0, , id, , , , 500)
        WinMove(x + Wigglepx, y, , , hwnd)
        WinMove(x, y, , , hwnd)
        SendMessage(WM_EXITSIZEMOVE, 0, 0, , id, , , , 500)
    }
}

; ---- Invisible-border compensation (Win10/11) --------------------------------
GetFrameInset(hwnd, &left, &top, &right, &bottom) {
    rect := Buffer(16), frame := Buffer(16)
    DllCall("GetWindowRect", "ptr", hwnd, "ptr", rect)
    if DllCall("dwmapi\DwmGetWindowAttribute", "ptr", hwnd, "uint", 9, "ptr", frame, "uint", 16) != 0 {
        left := top := right := bottom := 0
        return
    }
    left   := NumGet(frame, 0, "int")  - NumGet(rect, 0, "int")
    top    := NumGet(frame, 4, "int")  - NumGet(rect, 4, "int")
    right  := NumGet(rect, 8, "int")   - NumGet(frame, 8, "int")
    bottom := NumGet(rect, 12, "int")  - NumGet(frame, 12, "int")
}

HideTaskbar() {
    static ABM_GETSTATE := 4, ABM_SETSTATE := 10
    abd := Buffer(A_PtrSize = 8 ? 48 : 36, 0)
    NumPut("UInt", abd.Size, abd, 0)                      ; cbSize
    state := DllCall("Shell32\SHAppBarMessage", "UInt", ABM_GETSTATE, "Ptr", abd, "UPtr")
    ; bit 0 = auto-hide, bit 1 = always-on-top; flip between them
    NumPut("Ptr", (state & 1) ? 2 : 1, abd, A_PtrSize = 8 ? 40 : 32)  ; lParam
    DllCall("Shell32\SHAppBarMessage", "UInt", ABM_SETSTATE, "Ptr", abd)
}

; Which monitor contains the window's center point
MonitorOf(hwnd) {
    WinGetPos(&x, &y, &w, &h, hwnd)
    cx := x + w // 2, cy := y + h // 2
    Loop MonitorGetCount() {
        MonitorGet(A_Index, &l, &t, &r, &b)
        if (cx >= l && cx < r && cy >= t && cy < b)
            return A_Index
    }
    return MonitorGetPrimary()
}

SwapMonitors(a, b) {
    plan := []
    ; Decide targets for ALL windows first, then move, so nothing gets moved twice
    for hwnd in GetObservableWindows() {
        if !IsRealWindow(hwnd)
            continue
        m := MonitorOf(hwnd)
        if (m = a)
            plan.Push([hwnd, b])
        else if (m = b)
            plan.Push([hwnd, a])
    }
    for p in plan {
	WinActivate(p[1])
	if (p[2] == 1) {
		Send("#+{Left}")
	}
	else {
		Send("#+{Right}")
	}
    }
}

IsRealWindow(hwnd) {
    if !(WinGetStyle(hwnd) & 0x10000000)             ; WS_VISIBLE
        return false
    ex := WinGetExStyle(hwnd)
    if ((ex & 0x80) && !(ex & 0x40000))              ; tool window without APPWINDOW
        return false
    if (WinGetTitle(hwnd) = "")
        return false
    cloaked := 0                                      ; hidden UWP / other-desktop windows
    DllCall("dwmapi\DwmGetWindowAttribute", "ptr", hwnd, "uint", 14, "int*", &cloaked, "uint", 4)
    if cloaked
        return false
    return !InStr("Progman,WorkerW,Shell_TrayWnd,Shell_SecondaryTrayWnd", WinGetClass(hwnd))
}

GetObservableWindows(minVisible := 60) {
    result := []
    covered := DllCall("CreateRectRgn", "int", 0, "int", 0, "int", 0, "int", 0, "ptr")
    cur     := DllCall("CreateRectRgn", "int", 0, "int", 0, "int", 0, "int", 0, "ptr")
    diff    := DllCall("CreateRectRgn", "int", 0, "int", 0, "int", 0, "int", 0, "ptr")
    box := Buffer(16)

    for hwnd in WinGetList() {                       ; top -> bottom z-order
        if !(WinGetStyle(hwnd) & 0x10000000)         ; not visible
            continue
        if (WinGetMinMax(hwnd) = -1)                 ; minimized
            continue
        if IsCloaked(hwnd)
            continue
        if InStr("Progman,WorkerW", WinGetClass(hwnd))
            continue
        ex := WinGetExStyle(hwnd)
        if (ex & 0x20)                               ; WS_EX_TRANSPARENT: click-through overlay, not an occluder
            continue

        FrameRect(hwnd, &l, &t, &r, &b)
        DllCall("SetRectRgn", "ptr", cur, "int", l, "int", t, "int", r, "int", b)

        ; visible part = this window minus everything above it
        DllCall("CombineRgn", "ptr", diff, "ptr", cur, "ptr", covered, "int", 4)   ; RGN_DIFF
        DllCall("GetRgnBox", "ptr", diff, "ptr", box)
        vw := NumGet(box, 8, "int") - NumGet(box, 0, "int")
        vh := NumGet(box, 12, "int") - NumGet(box, 4, "int")

        if (vw >= minVisible && vh >= minVisible && IsRealWindow(hwnd))
            result.Push(hwnd)

        ; this window now hides whatever is below it
        DllCall("CombineRgn", "ptr", covered, "ptr", covered, "ptr", cur, "int", 2) ; RGN_OR
    }

    DllCall("DeleteObject", "ptr", covered)
    DllCall("DeleteObject", "ptr", cur)
    DllCall("DeleteObject", "ptr", diff)
    return result
}

; Real visible bounds (excludes the invisible ~7px resize border on Win10/11)
FrameRect(hwnd, &l, &t, &r, &b) {
    rc := Buffer(16)
    if DllCall("dwmapi\DwmGetWindowAttribute", "ptr", hwnd, "uint", 9, "ptr", rc, "uint", 16)  ; DWMWA_EXTENDED_FRAME_BOUNDS
        DllCall("GetWindowRect", "ptr", hwnd, "ptr", rc)
    l := NumGet(rc, 0, "int"), t := NumGet(rc, 4, "int")
    r := NumGet(rc, 8, "int"), b := NumGet(rc, 12, "int")
}

IsCloaked(hwnd) {
    c := 0
    DllCall("dwmapi\DwmGetWindowAttribute", "ptr", hwnd, "uint", 14, "int*", &c, "uint", 4)
    return c
}

FocusOtherMonitor() {
    count := MonitorGetCount()
    if count < 2
        return

    ; which monitor is the cursor on now?
    MouseGetPos &x, &y
    cur := MonitorGetPrimary()
    Loop count {
        MonitorGet A_Index, &L, &T, &R, &B
        if (x >= L && x < R && y >= T && y < B) {
            cur := A_Index
            break
        }
    }

    target := Mod(cur, count) + 1
    MonitorGet target, &L, &T, &R, &B

    ; 2) activate the topmost real window on that monitor
    for hwnd in WinGetList() {          ; WinGetList is ordered top -> bottom
        if !IsRealWindow(hwnd)
            continue
        WinGetPos &wx, &wy, &ww, &wh, hwnd
        cx := wx + ww // 10 * 9
        cy := wy + wh // 11 * 6
        if (cx >= L && cx < R && cy >= T && cy < B) {
            WinActivate hwnd
            break
        }
    }

    cx := L + (R-L) // 10 * 9
    cy := T + (B-T) // 11 * 6

    ; 1) move the mouse to a fixed spot (center; or use L + 200, T + 150)
    MouseMove cx, cy, 0
    PulseRing(cx, cy)
}

global gdipToken := 0
StartGdip() {
    global gdipToken
    if gdipToken
        return
    DllCall("LoadLibrary", "str", "gdiplus")
    si := Buffer(24, 0)
    NumPut("uint", 1, si)
    DllCall("gdiplus\GdiplusStartup", "ptr*", &gdipToken, "ptr", si, "ptr", 0)
}

; ---------- smooth contracting ring ----------
; cx, cy = screen coordinates of the destination
PulseRing(cx, cy, size := 180, ms := 200, rgb := 0x008c8c, penW := 5) {
    StartGdip()
    x0 := cx - size // 2, y0 := cy - size // 2

    ; click-through, non-activating, layered window
    g := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x80000 +E0x20 +E0x08000000")
    g.Show("NA x" x0 " y" y0 " w" size " h" size)

    ; 32-bit DIB to draw into
    hdcScreen := DllCall("GetDC", "ptr", 0, "ptr")
    hdc := DllCall("CreateCompatibleDC", "ptr", hdcScreen, "ptr")
    bi := Buffer(40, 0)
    NumPut("uint", 40, "int", size, "int", -size, "ushort", 1, "ushort", 32, bi)
    hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0
                 , "ptr*", &bits := 0, "ptr", 0, "uint", 0, "ptr")
    obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
    DllCall("gdiplus\GdipCreateFromHDC", "ptr", hdc, "ptr*", &gfx := 0)
    DllCall("gdiplus\GdipSetSmoothingMode", "ptr", gfx, "int", 4)   ; anti-alias

    ptDst := Buffer(8), NumPut("int", x0, "int", y0, ptDst)
    ptSrc := Buffer(8, 0)
    sz    := Buffer(8), NumPut("int", size, "int", size, sz)
    blend := Buffer(4), NumPut("uchar", 0, "uchar", 0, "uchar", 255, "uchar", 1, blend)

    outerR := size / 2 - penW - 2
    start := A_TickCount
    Loop {
        t := (A_TickCount - start) / ms
        if t >= 1
            break
        ease  := 1 - (1 - t) ** 3                 ; ease-out
        r     := outerR * (1 - 0.65 * ease)       ; contract to 35% of start
        alpha := Round(230 * (1 - t))             ; fade out

        DllCall("gdiplus\GdipGraphicsClear", "ptr", gfx, "uint", 0)

        ; soft inner glow
        DllCall("gdiplus\GdipCreateSolidFill", "uint", (alpha // 5 << 24) | rgb, "ptr*", &br := 0)
        DllCall("gdiplus\GdipFillEllipse", "ptr", gfx, "ptr", br
              , "float", size/2 - r, "float", size/2 - r, "float", 2*r, "float", 2*r)
        DllCall("gdiplus\GdipDeleteBrush", "ptr", br)

        ; ring
        DllCall("gdiplus\GdipCreatePen1", "uint", (alpha << 24) | rgb
              , "float", penW, "int", 2, "ptr*", &pen := 0)
        DllCall("gdiplus\GdipDrawEllipse", "ptr", gfx, "ptr", pen
              , "float", size/2 - r, "float", size/2 - r, "float", 2*r, "float", 2*r)
        DllCall("gdiplus\GdipDeletePen", "ptr", pen)

        DllCall("UpdateLayeredWindow", "ptr", g.Hwnd, "ptr", 0, "ptr", ptDst, "ptr", sz
              , "ptr", hdc, "ptr", ptSrc, "uint", 0, "ptr", blend, "uint", 2)
        Sleep 8
    }

    DllCall("gdiplus\GdipDeleteGraphics", "ptr", gfx)
    DllCall("SelectObject", "ptr", hdc, "ptr", obm)
    DllCall("DeleteObject", "ptr", hbm)
    DllCall("DeleteDC", "ptr", hdc)
    DllCall("ReleaseDC", "ptr", 0, "ptr", hdcScreen)
    g.Destroy()
}
