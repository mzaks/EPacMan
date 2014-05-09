#import <SpriteKit/SpriteKit.h>
#import "ESRepositoryObserver.h"
#import "MZUpdateTileViewOnDotRemovalSystem.h"
#import "ESEntityRepository+Singleton.h"
#import "MZDotComponent.h"
#import "MZBigDotComponent.h"
#import "MZSpriteKitNodeComponent.h"


@implementation MZUpdateTileViewOnDotRemovalSystem {
    ESRepositoryObserver *_observer;
}

- (id)init {
    self = [super init];
    if (self) {
        _observer = [[ESRepositoryObserver alloc] initWithRepository:[ESEntityRepository sharedRepository]
                                                             matcher:[ESMatcher anyOf:[MZDotComponent class], [MZBigDotComponent class], nil]
                                                             trigger:ESEntityRemoved];
    }

    return self;
}


- (void)execute {
    for (ESEntity *tile in [_observer drain]) {
        SKSpriteNode *spriteNode = (SKSpriteNode *) getComponent(tile, MZSpriteKitNodeComponent).node;
        [spriteNode setTexture:[SKTexture textureWithImageNamed:@"tile1111.png"]];
    }
}

@end