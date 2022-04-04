
#import "ZZZ.h"

@interface ZZZ ()
@end

@implementation ZZZ {
}

+ (NSString *)name {
  return NSStringFromClass([self class]);
}

+ (void)hello {
    NSLog(@"Hello %@", self.name);
}

@end
