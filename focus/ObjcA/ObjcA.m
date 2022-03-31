
#import "ObjcA.h"
#import "ObjcAInternal.h"

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

@end
