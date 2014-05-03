#import "MZMazeMetricsComponent.h"


@implementation MZMazeMetricsComponent {

}
- (instancetype)initWithWidthInTiles:(NSUInteger)widthInTiles {
    self = [super init];
    if (self) {
        _widthInTiles = widthInTiles;
    }

    return self;
}

+ (instancetype)componentWithWidthInTiles:(NSUInteger)widthInTiles {
    return [[self alloc] initWithWidthInTiles:widthInTiles];
}

@end