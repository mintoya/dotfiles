﻿Alt & RButton::
  global cmd
  CoordMode, Mouse
  MouseGetPos, origMouseX, origMouseY, winId

  WinGetPos, winX, winY, winW, winH, ahk_id %winId%
  relX := (origMouseX - winX) / winW - .5
  relY := (origMouseY - winY) / winH - .5
  resizeLeft := 2 * relX + Abs(relY) < 0
  resizeTop := 2 * relY + Abs(relX) < 0
  resizeRight := 2 * relX - Abs(relY) > 0
  resizeBottom := 2 * relY - Abs(relX) > 0

  while(GetKeyState("RButton","P")) {
    CoordMode, Mouse
    MouseGetPos, mouseX, mouseY
    WinGetPos, winX, winY, winW, winH, ahk_id %winId%
    deltaX := mouseX - origMouseX
    deltaY := mouseY - origMouseY
    origMouseX := mouseX
    origMouseY := mouseY
    SetWinDelay, -1

    newWinX := resizeLeft ? winX + deltaX : winX
    newWinY := resizeTop ? winY + deltaY : winY
    newWinW := winW + winX - newWinX + (resizeRight ? deltaX : 0)
    newWinH := winH + winY - newWinY + (resizeBottom ? deltaY : 0)
    WinMove, ahk_id %winId%,, newWinX, newWinY, newWinW, newWinH
    cmd := Format("glazewm command size --width {:i} --height {:i}",newWinW,newWinH)
  }
  Run %cmd%,,"Hide"
  return
