// Copyright 2015 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "BaseViewController.h"

//@import MixedB;
@import SwiftA;
#import <MixedB/MixedBObjC.h>
#import <MixedB/MixedB-Swift.h>

@interface BaseViewController ()
@end

@implementation BaseViewController {
  bool _isFlipped;
}

- (void)viewDidLoad {
  self.view.backgroundColor = UIColor.redColor;
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  button.frame = CGRectMake(0, 0, 200, 200);
  button.center = self.view.center;
  button.backgroundColor = UIColor.blackColor;
  [button setTitle:@"PUSH ME" forState:UIControlStateNormal];
  [button addTarget:self action:@selector(doSomething) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];
}

- (void)doSomething {
  self.view.backgroundColor = _isFlipped ? UIColor.redColor : UIColor.blueColor;
  _isFlipped = !_isFlipped;
//  NSInteger number = SwiftA.number;
  NSString *bswift = MixedBSwift.name;
  NSString *bobjc = MixedBObjC.name;
  NSLog(@"BREAKPOINT INCOMING!");
  NSLog(@"BREAKPOINT, %@, %@", bswift, bobjc);
}

@end
