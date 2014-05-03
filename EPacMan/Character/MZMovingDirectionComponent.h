#import <Foundation/Foundation.h>
#import "MZComponent.h"
#import "MZDirection.h"


@interface MZMovingDirectionComponent : MZComponent

@property (readonly) MZDirection direction;

- (instancetype)initWithDirection:(MZDirection)direction;

+ (instancetype)componentWithDirection:(MZDirection)direction;


@end