#import <SpriteKit/SpriteKit.h>
#import "MZDisplayMazeTilesSystem.h"
#import "ESRepositoryObserver.h"
#import "ESEntityRepository+Singleton.h"
#import "MZPositionComponent.h"
#import "MZGameSceneComponent.h"
#import "MZSpriteKitNodeComponent.h"
#import "MZNotWalkableComponent.h"
#import "MZMazeTileComponent.h"
#import "MZMazeConstants.h"

@implementation MZDisplayMazeTilesSystem {
    ESRepositoryObserver *_observer;
    ESEntityRepository *_repository;
}

- (id)init {
    self = [super init];
    if (self) {
        _observer = [[ESRepositoryObserver alloc] initWithRepository:[ESEntityRepository sharedRepository]
                                                             matcher:[ESMatcher allOf:[MZPositionComponent class], [MZMazeTileComponent class], nil]];
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
        UIColor *color = [mazeTile hasComponentOfType:[MZNotWalkableComponent class]]? [SKColor blueColor] : [SKColor blackColor];
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(TILE_WIDTH, TILE_HEIGHT)];
        node.anchorPoint = CGPointMake(0, 1);
        node.position = CGPointMake(positionComponent.position.x * TILE_WIDTH, positionComponent.position.y * TILE_HEIGHT);
        [scene addChild:node];
        [mazeTile addComponent:[MZSpriteKitNodeComponent componentWithNode:node]];
    }
}

@end