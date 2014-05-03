#import <Foundation/Foundation.h>
#import "MZComponent.h"
#import "MZDirection.h"


@interface MZMovingComponent : MZComponent

@property (readonly) MZDirection direction;
@property (readonly) NSUInteger startTick;
@property (readonly) NSUInteger durationInTicks;

- (instancetype)initWithDirection:(MZDirection)direction startTick:(NSUInteger)startTick durationInTicks:(NSUInteger)durationInTicks;

+ (instancetype)componentWithDirection:(MZDirection)direction startTick:(NSUInteger)startTick durationInTicks:(NSUInteger)durationInTicks;


@end