#import "MZMazeLevelComponent.h"


@implementation MZMazeLevelComponent {

}
- (instancetype)initWithLevel:(NSUInteger)level {
    self = [super init];
    if (self) {
        _level = level;
    }

    return self;
}

+ (instancetype)componentWithLevel:(NSUInteger)level {
    return [[self alloc] initWithLevel:level];
}


@end