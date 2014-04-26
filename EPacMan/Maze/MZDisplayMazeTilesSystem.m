#import <SpriteKit/SpriteKit.h>
#import "MZDisplayMazeTilesSystem.h"
#import "ESRepositoryObserver.h"
#import "ESEntityRepository+Singleton.h"
#import "MZPositionComponent.h"
#import "MZGameSceneComponent.h"
#import "MZSpriteKitNodeComponent.h"
#import "MZNotWalkableComponent.h"


@implementation MZDisplayMazeTilesSystem {
    ESRepositoryObserver *_observer;
    ESEntityRepository *_repository;
}

- (id)init {
    self = [super init];
    if (self) {
        _observer = [[ESRepositoryObserver alloc] initWithRepository:[ESEntityRepository sharedRepository] matcher:[MZPositionComponent matcher]];
        _repository = [ESEntityRepository sharedRepository];
    }

    return self;
}


- (void)execute {

    NSArray *freshCreatedMazeTiles = [_observer drain];
    if(freshCreatedMazeTiles.count == 0){
        return;
    }

    ESEntity *gameSceneEntity = [_repository singletonEntity:[MZGameSceneComponent matcher]];
    SKNode *scene = getComponent(gameSceneEntity, MZSpriteKitNodeComponent).node;

    for (ESEntity *mazeTile in freshCreatedMazeTiles){
        MZPositionComponent *positionComponent = getComponent(mazeTile, MZPositionComponent);
        UIColor *color = [mazeTile hasComponentOfType:[MZNotWalkableComponent class]]? [SKColor yellowColor] : [SKColor grayColor];
        SKNode *node = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(5, 5)];
        node.position = CGPointMake(positionComponent.position.x * 5, positionComponent.position.y * 5 + 200);
        [scene addChild:node];
    }
}

@end