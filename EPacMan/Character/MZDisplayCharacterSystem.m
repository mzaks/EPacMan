#import <SpriteKit/SpriteKit.h>
#import "MZDisplayCharacterSystem.h"
#import "ESRepositoryObserver.h"
#import "ESEntityRepository+Singleton.h"
#import "MZPacManComponent.h"
#import "MZPositionComponent.h"
#import "MZSpriteKitNodeComponent.h"
#import "MZGameSceneComponent.h"
#import "MZMazeConstants.h"
#import "MZHistorizedComponent.h"


@implementation MZDisplayCharacterSystem {
    ESRepositoryObserver *_observer;
    ESEntityRepository *_repository;
}

- (id)init {
    self = [super init];
    if (self) {
        _repository = [ESEntityRepository sharedRepository];
        _observer = [[ESRepositoryObserver alloc] initWithRepository:_repository matcher:[MZPacManComponent matcher]];
    }

    return self;
}


- (void)execute {
    NSArray *pacmans = [_observer drain];
    if(pacmans.count == 0){
        return;
    }

    ESEntity *gameSceneEntity = [_repository singletonEntity:[MZGameSceneComponent matcher]];
    SKNode *scene = getComponent(gameSceneEntity, MZSpriteKitNodeComponent).node;

    for (ESEntity *pacman in pacmans){
        MZPositionComponent *positionComponent = getComponent(pacman, MZPositionComponent);
        UIColor *color = [pacman hasComponentOfType:[MZHistorizedComponent class]] ? [SKColor blueColor] : [SKColor redColor];
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(TILE_WIDTH, TILE_HEIGHT)];
        node.anchorPoint = CGPointMake(0, 1);
        node.position = CGPointMake(positionComponent.position.x * TILE_WIDTH, positionComponent.position.y * TILE_HEIGHT);
        node.zPosition = 1000;
        [scene addChild:node];
        [pacman addComponent:[MZSpriteKitNodeComponent componentWithNode:node]];
    }
}

@end