
#import "ObjcDynamic.h"

@interface ObjcDynamic ()
@end

@implementation ObjcDynamic {
}

+ (NSString *)name {
  return NSStringFromClass([self class]);
}

+ (void)hello {
    NSLog(@"Hello %@", self.name);
}

@end
