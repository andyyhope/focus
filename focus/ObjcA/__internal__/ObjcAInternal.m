
#import "ObjcAInternal.h"

@interface ObjcAInternal ()
@end

@implementation ObjcAInternal {
}

+ (NSString *)secretName {
  return NSStringFromClass([self class]);
}

+ (void)secretHello {
    NSLog(@"Hello %@", self.secretName);
}

@end
