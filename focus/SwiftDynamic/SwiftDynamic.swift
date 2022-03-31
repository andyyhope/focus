import Foundation

@objc public class SwiftDynamic: NSObject {
  @objc public class func hello() {
    print("Hello \(self.name)")
  }
  
  @objc public class var name: String {
    String(describing: self)
  }
}
