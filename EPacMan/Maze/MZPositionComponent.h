#import <Foundation/Foundation.h>
#import "ESComponent.h"
#import "MZComponent.h"


@interface MZPositionComponent : MZComponent

@property (readonly) CGPoint position;

- (instancetype)initWithPosition:(CGPoint)position;

+ (instancetype)componentWithPosition:(CGPoint)position;

@end