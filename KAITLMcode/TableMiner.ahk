; Prevents Dialog box to come up if you run this script for a second time
#singleInstance ignore

; Button to Activate Script ^ = Control, ! = Alt, + = Shift, So to make control+d as hotkey ^d or control+alt+d = ^!d 
!d::

CoordMode, Mouse, Screen 

SetDefaultMouseSpeed, 25

Loop, 90
{
Click 225, 1115
Sleep, 2000
MouseClickDrag, L, 223, 1115, 750, 668, 25
Sleep, 5000
Click 520, 764 right
Sleep, 1000
Click 601, 775
Sleep, 155000
Click 1012, 1098
Sleep, 3500
Send ^v
Sleep, 1000
Click 1012, 1098
Send ^{NumpadUp}
Send ^{NumpadDown}
Send {NumpadDown}
Sleep, 500
Click 946, 1144
}

;Click 232, 1088
;Sleep, 1500
;Send, {LControl down}
Sleep, 2000
;Click down
;Sleep, 2000
;Mousemove, 750, 668
;Sleep, 2000
;Click up
;Sleep, 2000
;Sleep, 5000
;Send, {LControl up}
;Sleep, 2000
;Send, {LControl up}
;Sleep, 5000


; Return function (must be present)
return

Esc::ExitApp