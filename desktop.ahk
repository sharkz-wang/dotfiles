#Requires AutoHotkey 2.0+

#SingleInstance Force

CoordMode("Mouse")
SetTitleMatchMode("RegEx")

;; #: windows key
;; ^: ctrl key
;; !: alt
;; +: shift
;; {Left}
;; {CapsLock}

toggle_app(title_regex, app_cmd) {

	if WinActive(title_regex) {
		Send("!{Esc}")
	} else if WinExist(title_regex) {
		WinActivate(title_regex)
	} else {
		Run(app_cmd,  , "Max")
	}
}

!^Backspace:: {
	toggle_app(".*OneNote.*", "C:\\Program Files\\Microsoft Office\\root\\Office16\\ONENOTE.EXE")
	return
}

!^q::SendInput("!{F4}")
!^d::Run(".\Downloads")
^!g::Run("C:\Program Files\Google\Chrome\Application\chrome.exe")

^F11::Run("notepad .\desktop.ahk")
^F12::{
	MsgBox("Reload done.", "Message", "T0.3")
	Reload()
}

^!a::SendInput("{Home}")
^!e::SendInput("{End}")
^!j::SendInput("{Down}")
^!k::SendInput("{Up}")
^!h::SendInput("{Left}")
^!l::SendInput("{Right}")
^!i::SendInput("{End}")
^!o::SendInput("{Home}")
^!u::SendInput("^{End}")
^!p::SendInput("^{Home}")
^!m::SendInput("^{Left}")
^!,::SendInput("^{Right}")
^#k::SendInput("#{Up}")

SetInputLang(languageIdentifier) {
    WinExist("A")
    CtrlInFocus := ControlGetFocus("A")
    PostMessage(0x50, 0, languageIdentifier)
}

+Backspace::SetInputLang(0x0409)
+Insert::SetInputLang(0x0404)

OnError(ForceErrorFocus)
;; make error message dialogue always bringed to foremost
ForceErrorFocus(exception, mode) {
    ; Small delay to allow the dialog window to actually exist
    SetTimer(() => WinActivate("ahk_class #32770 ahk_exe AutoHotkey64.exe"), -100)
    return 0 ; Continue to standard error dialog
}

; Press Ctrl + Alt + E to exit the script
!F1::ExitApp
