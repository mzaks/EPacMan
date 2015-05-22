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
#import "MZTileMap.h"
#import "MZDotComponent.h"
#import "MZBigDotComponent.h"

@implementation MZDisplayMazeTilesSystem {
    ESRepositoryObserver *_observer;
    ESEntityRepository *_repository;
    MZTileMap *_tileMap;
}

- (id)init {
    self = [super init];
    if (self) {
        _observer = [[ESRepositoryObserver alloc] initWithRepository:[ESEntityRepository sharedRepository]
                                                             matcher:[ESMatcher allOf:[MZPositionComponent class], [MZMazeTileComponent class], nil]];
        _repository = [ESEntityRepository sharedRepository];
        _tileMap = [MZTileMap sharedMap];
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
        CGPoint position = getComponent(mazeTile, MZPositionComponent).position;
        NSString *tileName;
        if([mazeTile hasComponentOfType:[MZNotWalkableComponent class]]){
            tileName = [self tileName:position];
        } else if([mazeTile hasComponentOfType:[MZDotComponent class]]){
            tileName = @"dot.png";
        } else if([mazeTile hasComponentOfType:[MZBigDotComponent class]]){
            tileName = @"big_dot.png";
        }
        else {
            tileName = @"tile1111.png";
        }

        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:tileName];
        node.anchorPoint = CGPointMake(0, 1);
        node.position = CGPointMake(position.x * TILE_WIDTH, position.y * TILE_HEIGHT);
        [scene addChild:node];
        [mazeTile addComponent:[MZSpriteKitNodeComponent componentWithNode:node]];
    }
}

- (NSString *)tileName:(CGPoint)position{
    NSString *up = [self isNotWalkable:CGPointMake(position.x, position.y+1)] ? @"1" : @"0";
    NSString *right = [self isNotWalkable:CGPointMake(position.x+1, position.y)] ? @"1" : @"0";
    NSString *down = [self isNotWalkable:CGPointMake(position.x, position.y-1)] ? @"1" : @"0";
    NSString *left = [self isNotWalkable:CGPointMake(position.x-1, position.y)] ? @"1" : @"0";

    return [NSString stringWithFormat:@"tile%@%@%@%@.png", left,down,right,up];
}

- (BOOL)isNotWalkable:(CGPoint)position {
    return [[_tileMap tileEntityAtPosition:position] hasComponentOfType:[MZNotWalkableComponent class]];
}

@end