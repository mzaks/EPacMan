#import <Foundation/Foundation.h>
#import "MZDirection.h"
#import "MZComponent.h"

@interface MZWishDirectionComponent : MZComponent

@property (readonly) MZDirection direction;

- (instancetype)initWithDirection:(MZDirection)direction;

+ (instancetype)componentWithDirection:(MZDirection)direction;

@end