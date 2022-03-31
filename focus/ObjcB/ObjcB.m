
#import "ObjcB.h"

@interface ObjcB ()
@end

@implementation ObjcB {
}

+ (NSString *)name {
  return NSStringFromClass([self class]);
}

+ (void)hello {
    NSLog(@"Hello %@", self.name);
}

@end
