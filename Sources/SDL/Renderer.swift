
import CSDL2

public struct Renderer: Passthrough {
  public init() { self.pointer = nil }
  public var pointer: OpaquePointer?

  public struct Flag: SDLOptionSet {
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public let rawValue: UInt32

    public static let
      software      = 0b0001 as Flag,
      accelerated   = 0b0010 as Flag,
      presentVsync  = 0b0100 as Flag,
      targetTexture = 0b1000 as Flag
  }
}


// MARK: - Lifetime

extension Renderer {

  public static func create(for window: Window, indexOfDriver: Int32 = -1, flags: Flag = .accelerated) -> Renderer {

    let renderer = SDL_CreateRenderer(window.pointer, indexOfDriver, flags.rawValue)

    return Renderer(renderer)
  }

  func destory() {
    SDL_DestroyRenderer(pointer)
  }
}


// MARK: - Drawing

extension Renderer {

  public func setDrawColor(rgb: UInt32, a: UInt8 = 0xff) throws {

    let r = UInt8((rgb & 0xff0000) >> 16)
    let g = UInt8((rgb & 0x00ff00) >>  8)
    let b = UInt8((rgb & 0x0000ff) >>  0)

    try setDrawColor(r: r, g: g, b: b, a: a)
  }

  public func setDrawColor(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 0xff) throws {

    let result = SDL_SetRenderDrawColor(pointer, r, g, b, a)
    guard result == 0 else { throw SDL.Error.last }
  }

  public func clear() throws {

    let result = SDL_RenderClear(pointer)
    guard result == 0 else { throw SDL.Error.last }
  }

  public func present() {

    SDL_RenderPresent(pointer)
  }

  public func drawLine(x1: Int32, y1: Int32, x2: Int32, y2: Int32) throws {

    let result = SDL_RenderDrawLine(pointer, x1, y1, x2, y2)

    guard result == 0 else { throw SDL.Error.last }
  }

  // TODO(vdka): this needs to be inout but can `var rect = rect` acheive the same performance?
  public func draw(rect: inout Rect) throws {

    let result = SDL_RenderDrawRect(pointer, &rect)

    guard result == 0 else { throw SDL.Error.last }
  }

  public func fill(rect: inout Rect) throws {

    let result = SDL_RenderFillRect(pointer, &rect)

    guard result == 0 else { throw SDL.Error.last }
  }
}
