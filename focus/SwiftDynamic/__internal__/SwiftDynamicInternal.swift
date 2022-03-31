import Foundation

@objc class SwiftDynamicInternal: NSObject {
  @objc public class func hello() {
    print("Hello \(self.name)")
  }
  
  @objc class var name: String {
    String(describing: self)
  }
}
