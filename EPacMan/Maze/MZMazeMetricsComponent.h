#import <Foundation/Foundation.h>
#import "MZComponent.h"


@interface MZMazeMetricsComponent : MZComponent

@property(readonly) NSUInteger widthInTiles;
@property(readonly) NSUInteger heightInTiles;

- (instancetype)initWithWidthInTiles:(NSUInteger)widthInTiles;

+ (instancetype)componentWithWidthInTiles:(NSUInteger)widthInTiles;


@end