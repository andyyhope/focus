
#import "MixedBObjC.h"

@interface MixedBObjC ()
@end

@implementation MixedBObjC

+ (NSString *)name {
  return NSStringFromClass([self class]);
}

+ (void)hello {
    NSLog(@"Hello %@", self.name);
}

@end
