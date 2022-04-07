
#import "ObjcA.h"
#import "ObjcAInternal.h"

@import ZZZ;

@interface ObjcA ()
@end

@implementation ObjcA {
}

+ (NSString *)name {
  return NSStringFromClass([self class]);
}

+ (void)hello {
    NSLog(@"Hello %@", self.name);
}

+ (void)deps {
  NSString *name = ZZZObjc.name;
  [ZZZObjc hello];
  NSLog(@"%@", name);
  NSLog(@"%@", ZZZObjc.name);
}

@end
