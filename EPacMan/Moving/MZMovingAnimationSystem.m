#import <SpriteKit/SpriteKit.h>
#import "MZMovingAnimationSystem.h"
#import "ESRepositoryObserver.h"
#import "MZMovingComponent.h"
#import "ESEntityRepository+Singleton.h"
#import "MZSpriteKitNodeComponent.h"
#import "MZSimulationConstants.h"
#import "MZTileMap.h"


@implementation MZMovingAnimationSystem {
    ESEntityRepository *_repository;
    ESRepositoryObserver *_observer;
    MZTileMap *_tileMap;
}

- (id)init {
    self = [super init];
    if (self) {
        _repository = [ESEntityRepository sharedRepository];
        _observer = [[ESRepositoryObserver alloc] initWithRepository:_repository
                                                             matcher:[MZMovingComponent matcher]];
        _tileMap = [MZTileMap sharedMap];
    }

    return self;
}


- (void)execute {
    for (ESEntity *movingEntity in [_observer drain]){
        MZDirection direction = getComponent(movingEntity, MZMovingComponent).direction;
        ESEntity *tile = [_tileMap tileEntityInDirection:direction fromEntityWithPosition:movingEntity];
        CGPoint position = getComponent(tile, MZSpriteKitNodeComponent).node.position;
        SKSpriteNode *node = (SKSpriteNode *) getComponent(movingEntity, MZSpriteKitNodeComponent).node;
        [node runAction:[SKAction moveTo:position duration:MOVE_DURATION_IN_TICKS/TARGETED_FPS]];
    }
}

@end