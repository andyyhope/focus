
#import "ObjcDynamicInternal.h"

@interface ObjcDynamicInternal ()
@end

@implementation ObjcDynamicInternal {
}

+ (NSString *)secretName {
  return NSStringFromClass([self class]);
}

+ (void)secretHello {
    NSLog(@"Hello %@", self.secretName);
}

@end
