
#import "ZZZObjc.h"

@interface ZZZObjc ()
@end

@implementation ZZZObjc {
}

+ (NSString *)name {
  return NSStringFromClass([self class]);
}

+ (void)hello {
    NSLog(@"Hello %@", self.name);
}

@end
