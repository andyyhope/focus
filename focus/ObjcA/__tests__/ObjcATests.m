@import Foundation;
@import XCTest;
@import ObjcA;

@implementation ObjcATests: XCTestCase
  
- (void)testA {
  NSInteger a = 1;
  XCTAssertTrue(a == 1);
}
  
- (void)testB {
  NSInteger a = 1;
  XCTAssertFalse(a == 2);
}
  
- (void)testC {
  NSInteger a = 1;
  XCTAssertEqual(a, 1);
}

- (void)testObjcA {
  NSInteger a = 100;
  XCTAssertEqual(a, ObjcA.number);
}

@end
