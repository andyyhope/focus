import Foundation

@objc public class MixedBSwift: NSObject {
  
  @objc public class func hello() {
    print("Hello \(self.name)")
  }
  
  @objc public class var name: String {
    String(describing: self)
  }
}
