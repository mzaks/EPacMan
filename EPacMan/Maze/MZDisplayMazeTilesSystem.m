#import <SpriteKit/SpriteKit.h>
#import "MZDisplayMazeTilesSystem.h"
#import "ESRepositoryObserver.h"
#import "ESEntityRepository+Singleton.h"
#import "MZPositionComponent.h"
#import "MZGameSceneComponent.h"
#import "MZSpriteKitNodeComponent.h"
#import "MZNotWalkableComponent.h"

#define TILE_WIDTH 10
#define TILE_HEIGHT 10



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
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(TILE_WIDTH, TILE_HEIGHT)];
        node.anchorPoint = CGPointMake(0, 1);
        node.position = CGPointMake(positionComponent.position.x * TILE_WIDTH, positionComponent.position.y * TILE_HEIGHT);
        [scene addChild:node];
    }
}

@end