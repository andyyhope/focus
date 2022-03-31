
#import "ObjcBInternal.h"

@interface ObjcBInternal ()
@end

@implementation ObjcBInternal {
}

+ (NSString *)secretName {
  return NSStringFromClass([self class]);
}

+ (void)secretHello {
    NSLog(@"Hello %@", self.secretName);
}

@end
