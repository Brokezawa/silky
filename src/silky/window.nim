import std/unicode
import vmath, bumpy, pixie

type
  Button* = enum
    ButtonUnknown, MouseLeft, MouseRight, MouseMiddle, MouseButton4, MouseButton5,
    DoubleClick, TripleClick, QuadrupleClick, Key0, Key1, Key2, Key3, Key4, Key5,
    Key6, Key7, Key8, Key9, KeyA, KeyB, KeyC, KeyD, KeyE, KeyF, KeyG, KeyH, KeyI,
    KeyJ, KeyK, KeyL, KeyM, KeyN, KeyO, KeyP, KeyQ, KeyR, KeyS, KeyT, KeyU, KeyV,
    KeyW, KeyX, KeyY, KeyZ, KeyBacktick, KeyMinus, KeyEqual, KeyBackspace, KeyTab,
    KeyLeftBracket, KeyRightBracket, KeyBackslash, KeyCapsLock, KeySemicolon,
    KeyApostrophe, KeyEnter, KeyLeftShift, KeyComma, KeyPeriod, KeySlash,
    KeyRightShift, KeyLeftControl, KeyLeftSuper, KeyLeftAlt, KeySpace, KeyRightAlt,
    KeyRightSuper, KeyMenu, KeyRightControl, KeyDelete, KeyHome, KeyEnd, KeyInsert,
    KeyPageUp, KeyPageDown, KeyEscape, KeyUp, KeyDown, KeyLeft, KeyRight,
    KeyPrintScreen, KeyScrollLock, KeyPause, KeyF1, KeyF2, KeyF3, KeyF4, KeyF5,
    KeyF6, KeyF7, KeyF8, KeyF9, KeyF10, KeyF11, KeyF12, KeyNumLock, Numpad0,
    Numpad1, Numpad2, Numpad3, Numpad4, Numpad5, Numpad6, Numpad7, Numpad8,
    Numpad9, NumpadDecimal, NumpadEnter, NumpadAdd, NumpadSubtract, NumpadMultiply,
    NumpadDivide, NumpadEqual

  ButtonView* = set[Button]

  CursorKind* = enum
    ArrowCursor, PointerCursor, IBeamCursor, CrosshairCursor, ClosedHandCursor,
    OpenHandCursor, ResizeLeftCursor, ResizeRightCursor, ResizeLeftRightCursor,
    ResizeUpCursor, ResizeDownCursor, ResizeUpDownCursor, OperationNotAllowedCursor,
    WaitCursor, CustomCursor

  Cursor* = object
    case kind*: CursorKind:
    of CustomCursor:
      image*: Image
      hotspot*: IVec2
    else:
      discard

  Window* = ref object
    ## A backend-agnostic state container for a UI Window.
    size*: IVec2
    mousePrevPos*: IVec2
    mousePos*: IVec2
    mouseDelta*: IVec2
    buttonDown*: set[Button]
    buttonPressed*: set[Button]
    buttonReleased*: set[Button]
    scrollDelta*: Vec2
    closeRequested*: bool
    cursor*: Cursor
    runeInputEnabled*: bool
    onRune*: proc(rune: Rune)
    onFrame*: proc()
    contentScale*: float32
    # Generic native handle accessors for backends (e.g. OpenGL, Metal).
    # Expected to be populated by the host (e.g., nimplug or a standalone app).
    getNativeView*: proc(): pointer
    getNativeWindow*: proc(): pointer
    makeContextCurrentCb*: proc()
    swapBuffersCb*: proc()
    getClipboardStringCb*: proc(): string

proc newWindow*(width = 800, height = 600): Window =
  Window(
    size: ivec2(width.int32, height.int32),
    mousePrevPos: ivec2(0, 0),
    mouseDelta: ivec2(0, 0),
    mousePos: ivec2(0, 0),
    cursor: Cursor(kind: ArrowCursor)
  )

proc newWindow*(title: string, size: IVec2, vsync = true): Window =
  Window(
    size: size,
    mousePrevPos: ivec2(0, 0),
    mouseDelta: ivec2(0, 0),
    mousePos: ivec2(0, 0),
    cursor: Cursor(kind: ArrowCursor)
  )

proc makeContextCurrent*(window: Window) =
  if window.makeContextCurrentCb != nil: window.makeContextCurrentCb()

proc swapBuffers*(window: Window) =
  if window.swapBuffersCb != nil: window.swapBuffersCb()

proc getClipboardString*(): string =
  ""

proc setClipboardString*(s: string) =
  discard

proc loadExtensions*() =
  discard

proc resetInputState*(w: Window) =
  w.buttonPressed = {}
  w.buttonReleased = {}
  w.mouseDelta = ivec2(0, 0)
  w.scrollDelta = vec2(0, 0)

template mousePos*(w: Window): Vec2 = w.mousePos.vec2
template mouseDelta*(w: Window): Vec2 = w.mouseDelta.vec2
template buttonDown*(w: Window, btn: Button): bool = btn in w.buttonDown
template buttonPressed*(w: Window, btn: Button): bool = btn in w.buttonPressed
template buttonReleased*(w: Window, btn: Button): bool = btn in w.buttonReleased

proc `[]`*(buttonView: ButtonView, button: Button): bool =
  button in set[Button](buttonView)

proc len*(buttonView: ButtonView): int =
  set[Button](buttonView).len

proc pressButton*(w: Window, button: Button) =
  w.buttonDown.incl button
  w.buttonPressed.incl button

proc releaseButton*(w: Window, button: Button) =
  w.buttonDown.excl button
  w.buttonReleased.incl button

proc moveMouse*(w: Window, x, y: int) =
  let newPos = ivec2(x.int32, y.int32)
  w.mousePrevPos = w.mousePos
  w.mouseDelta = newPos - w.mousePos
  w.mousePos = newPos
