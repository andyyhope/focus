import Foundation

@objc public class SwiftB: NSObject {
  @objc public class func hello() {
    print("Hello \(self.name)")
  }
  
  @objc public class var name: String {
    String(describing: self)
  }
}
