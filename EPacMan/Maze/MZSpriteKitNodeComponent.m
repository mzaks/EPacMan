#import <SpriteKit/SpriteKit.h>
#import "MZSpriteKitNodeComponent.h"


@implementation MZSpriteKitNodeComponent {

}
- (instancetype)initWithNode:(SKNode *)node {
    self = [super init];
    if (self) {
        _node = node;
    }

    return self;
}

+ (instancetype)componentWithNode:(SKNode *)node {
    return [[self alloc] initWithNode:node];
}

@end