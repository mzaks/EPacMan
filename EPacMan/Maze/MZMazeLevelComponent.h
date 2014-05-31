#import <Foundation/Foundation.h>
#import "MZComponent.h"


@interface MZMazeLevelComponent : MZComponent

@property (readonly)NSUInteger level;

- (instancetype)initWithLevel:(NSUInteger)level;

+ (instancetype)componentWithLevel:(NSUInteger)level;

@end