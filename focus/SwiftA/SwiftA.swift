import Foundation

import ObjcB
import SwiftB

@objc public class SwiftA: NSObject {
  @objc public class func hello() {
    print("Hello \(self.name)")
    ObjcB.hello()
    SwiftB.hello()
  }
  
  @objc public class var name: String {
    String(describing: self)
  }
}
