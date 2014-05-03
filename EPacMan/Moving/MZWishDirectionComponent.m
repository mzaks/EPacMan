#import "MZWishDirectionComponent.h"


@implementation MZWishDirectionComponent {

}
- (instancetype)initWithDirection:(MZDirection)direction {
    self = [super init];
    if (self) {
        _direction = direction;
    }

    return self;
}

+ (instancetype)componentWithDirection:(MZDirection)direction {
    return [[self alloc] initWithDirection:direction];
}
@end