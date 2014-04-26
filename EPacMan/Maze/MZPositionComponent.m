#import "MZPositionComponent.h"


@implementation MZPositionComponent {

}
- (instancetype)initWithPosition:(CGPoint)position {
    self = [super init];
    if (self) {
        _position = position;
    }

    return self;
}

+ (instancetype)componentWithPosition:(CGPoint)position {
    return [[self alloc] initWithPosition:position];
}

@end