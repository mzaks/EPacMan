#import "MZTickComponent.h"


@implementation MZTickComponent {

}
- (instancetype)initWithCurrentTick:(NSUInteger)currentTick {
    self = [super init];
    if (self) {
        _currentTick = currentTick;
    }

    return self;
}

+ (instancetype)componentWithCurrentTick:(NSUInteger)currentTick {
    return [[self alloc] initWithCurrentTick:currentTick];
}

@end