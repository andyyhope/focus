import Foundation
import XCTest
import SwiftA

final class SwiftATests: XCTestCase {
  func testA() {
    let a = 1
    XCTAssertTrue(a == 1)
  }
  
  func testB() {
    let a = 1
    XCTAssertFalse(a == 2)
  }
  
  func testC() {
    let a = 1
    XCTAssertEqual(a, 1)
  }
  
  func testSwiftA() {
    let a = 1234
    XCTAssertEqual(a, SwiftA.number)
  }
}
