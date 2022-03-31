
#import "MixedAObjC.h"

@interface MixedAObjC ()
@end

@implementation MixedAObjC

+ (NSString *)name {
  return NSStringFromClass([self class]);
}

+ (void)hello {
    NSLog(@"Hello %@", self.name);
}

@end
