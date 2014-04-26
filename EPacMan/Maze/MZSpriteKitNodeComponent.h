#import <Foundation/Foundation.h>
#import "MZComponent.h"

@class SKSpriteNode;


@interface MZSpriteKitNodeComponent : MZComponent

@property (readonly)SKNode *node;

- (instancetype)initWithNode:(SKNode *)node;

+ (instancetype)componentWithNode:(SKNode *)node;


@end