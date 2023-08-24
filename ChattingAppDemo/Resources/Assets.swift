// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Assets {
  public static let accentColor = ColorAsset(name: "AccentColor")
  public static let black343A40 = ColorAsset(name: "black343A40")
  public static let blue212B71 = ColorAsset(name: "blue 212B71")
  public static let blue586AD8 = ColorAsset(name: "blue586AD8")
  public static let blueEEF0FC = ColorAsset(name: "blueEEF0FC")
  public static let gray828282 = ColorAsset(name: "gray828282")
  public static let grayADB5BD = ColorAsset(name: "grayADB5BD")
  public static let grayCED4DA = ColorAsset(name: "grayCED4DA")
  public static let grayEFF2F7 = ColorAsset(name: "grayEFF2F7")
  public static let grayF7F8F8 = ColorAsset(name: "grayF7F8F8")
  public static let greenF3FBF7 = ColorAsset(name: "green F3FBF7")
  public static let green34C38F = ColorAsset(name: "green34C38F")
  public static let greenCCF2E4 = ColorAsset(name: "greenCCF2E4")
  public static let redF2CCCC = ColorAsset(name: "redF2CCCC")
  public static let redF46A6A = ColorAsset(name: "redF46A6A")
  public static let redFDF5F5 = ColorAsset(name: "redFDF5F5")
  public static let icAvatarPlaceholder = ImageAsset(name: "ic_avatar_placeholder").image
  public static let icChatBlackSmall = ImageAsset(name: "ic_chat_black_small").image
  public static let icChatWhiteSmall = ImageAsset(name: "ic_chat_white_small").image
  public static let icClose = ImageAsset(name: "ic_close").image
  public static let icEyeClose = ImageAsset(name: "ic_eye_close").image
  public static let icEyeOpen = ImageAsset(name: "ic_eye_open").image
  public static let icLock = ImageAsset(name: "ic_lock").image
  public static let icUser = ImageAsset(name: "ic_user").image
  public static let icUserBlackSmal = ImageAsset(name: "ic_user_black_smal").image
  public static let icUserWhiteSmall = ImageAsset(name: "ic_user_white_small").image
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let bImage = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let imgName = NSImage.Name(self.name)
    let bImage = (bundle == .main) ? NSImage(named: imgName) : bundle.image(forResource: imgName)
    #elseif os(watchOS)
    let bImage = Image(named: name)
    #endif
    guard let result = bImage else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

public extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
