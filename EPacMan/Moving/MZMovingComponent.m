#import "MZMovingComponent.h"


@implementation MZMovingComponent {

}
- (instancetype)initWithDirection:(MZDirection)direction startTick:(NSUInteger)startTick durationInTicks:(NSUInteger)durationInTicks {
    self = [super init];
    if (self) {
        _direction = direction;
        _startTick = startTick;
        _durationInTicks = durationInTicks;
    }

    return self;
}

+ (instancetype)componentWithDirection:(MZDirection)direction startTick:(NSUInteger)startTick durationInTicks:(NSUInteger)durationInTicks {
    return [[self alloc] initWithDirection:direction startTick:startTick durationInTicks:durationInTicks];
}


@end