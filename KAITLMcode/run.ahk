; Prevents Dialog box to come up if you run this script for a second time
#singleInstance ignore

; Button to Activate Script ^ = Control, ! = Alt, + = Shift, So to make control+d as hotkey ^d or control+alt+d = ^!d 
!d::




Loop, 10000
{
Random,dostuff,1,5

If(dostuff < 2)
{
Send {q down}
Sleep dostuff*100
Send {q up}
Send {e down}
Sleep dostuff*100
Send {e up}
}

If(dostuff > 3)
{
Send {Space}
}


Random,rand,3000,4500
Send {Tab}
Send {1}
Sleep rand
}

Send {a up}


; Return function (must be present)
return

Esc::ExitApp