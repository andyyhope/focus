
#import "ObjcS.h"

@interface ObjcS ()
@end

@implementation ObjcS {
}

+ (NSInteger)number {
    return 55;
}

+ (void)hello {
    NSInteger a = 2;
    NSLog(@"Hello %li", a);
}

@end
