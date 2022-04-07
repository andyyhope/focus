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

#import "AppDelegate.h"

#import "BaseViewController.h"

@import SwiftA;
@import ObjcA;
@import ObjcDynamic;
@import SwiftDynamic;


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [ObjcA hello];
  NSString *name = ObjcA.name;
  NSLog(@"%@", name);
  NSLog(@"%@", ObjcA.name);

  [SwiftA hello];
  name = SwiftA.name;
  NSLog(@"%@", name);
  NSLog(@"%@", SwiftA.name);
  
  name = ObjcDynamic.name;
  [ObjcDynamic hello];
  NSLog(@"%@", name);
  NSLog(@"%@", ObjcDynamic.name);

  name = SwiftDynamic.name;
  [SwiftDynamic hello];
  NSLog(@"%@", name);
  NSLog(@"%@", SwiftDynamic.name);
    
  UITabBarController *bar = [[UITabBarController alloc] init];
  [bar setViewControllers:
      @[[[BaseViewController alloc] init]]];
  bar.selectedIndex = 0;
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = bar;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
