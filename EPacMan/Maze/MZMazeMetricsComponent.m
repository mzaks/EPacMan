#import "MZMazeMetricsComponent.h"


@implementation MZMazeMetricsComponent {

}
- (instancetype)initWithWidthInTiles:(NSUInteger)widthInTiles heightInTiles:(NSUInteger)heightInTiles {
    self = [super init];
    if (self) {
        _widthInTiles = widthInTiles;
        _heightInTiles = heightInTiles;
    }

    return self;
}

+ (instancetype)componentWithWidthInTiles:(NSUInteger)widthInTiles heightInTiles:(NSUInteger)heightInTiles {
    return [[self alloc] initWithWidthInTiles:widthInTiles heightInTiles:heightInTiles];
}


@end