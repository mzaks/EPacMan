#import <Foundation/Foundation.h>
#import "MZComponent.h"


@interface MZTickComponent : MZComponent

@property(readonly) NSUInteger currentTick;

- (instancetype)initWithCurrentTick:(NSUInteger)currentTick;

+ (instancetype)componentWithCurrentTick:(NSUInteger)currentTick;


@end