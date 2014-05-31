#import <Foundation/Foundation.h>
#import "MZComponent.h"


@interface MZMazeMetricsComponent : MZComponent

@property(readonly) NSUInteger widthInTiles;
@property(readonly) NSUInteger heightInTiles;

- (instancetype)initWithWidthInTiles:(NSUInteger)widthInTiles heightInTiles:(NSUInteger)heightInTiles;

+ (instancetype)componentWithWidthInTiles:(NSUInteger)widthInTiles heightInTiles:(NSUInteger)heightInTiles;

@end