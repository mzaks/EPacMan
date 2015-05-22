//
//  MZGameScene.m
//  EPacMan
//
//  Created by Maxim Zaks on 26.04.14.
//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

#import <Entitas/ESEntity.h>
#import "MZGameScene.h"
#import "ESEntityRepository+Singleton.h"
#import "ESSystems.h"
#import "MZMazeTileEmitter.h"
#import "MZDisplayMazeTilesSystem.h"
#import "MZGameSceneComponent.h"
#import "MZSpriteKitNodeComponent.h"
#import "MZDisplayCharacterSystem.h"
#import "MZMovingSystem.h"
#import "MZTileMap.h"
#import "MZTickComponent.h"
#import "MZMovingAnimationSystem.h"
#import "MZStopSystem.h"
#import "MZCollectDotsSystem.h"
#import "MZUpdateTileViewOnDotRemovalSystem.h"
#import "MZCheckWinSystem.h"
#import "MZTimeDisplayingSystem.h"
#import "MZGameViewController.h"
#import "MZPacManEatPacManSystem.h"
#import "MZGameOverPopupSystem.h"
#import "MZGameOverComponent.h"
#import "MZMazeLevelComponent.h"
#import "MZMazeMetricsComponent.h"
#import "MZMoveHistoryComponent.h"
#import "MZMoveHistorizedPacManSystem.h"

@implementation MZGameScene {
    ESEntityRepository *_repo;
    ESSystems *_rootSystem;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        _repo = [ESEntityRepository sharedRepository];
        [self createMazeLevelEntity];
        [self createMoveHistoryEntity];
        [self reset];
    }
    return self;
}

- (void)reset {
    [_rootSystem removeAllSystems];
    [self removeAllChildren];
    for (ESEntity *entity in [_repo allEntities]) {
        if([entity hasComponentOfType:[MZGameViewControllerComponent class]]){
            MZGameViewControllerComponent *gameViewControllerComponent = getComponent(entity, MZGameViewControllerComponent);
            [gameViewControllerComponent.viewController resetButtons];
            continue;
        }
        if([entity hasComponentOfType:[MZMazeLevelComponent class]]){
            continue;
        }

        if([entity hasComponentOfType:[MZMoveHistoryComponent class]]){
            NSMutableArray *moves = [NSMutableArray arrayWithArray:getComponent(entity, MZMoveHistoryComponent).moves];
            [moves addObject:[NSMutableDictionary new]];
            [entity exchangeComponent:[MZMoveHistoryComponent componentWithMoves:moves]];
            continue;
        }
        [_repo destroyEntity:entity];
    }
    [[MZTileMap sharedMap] reset];
    [self createTickEntity];
    [self createRootSystem];
    [self createGameSceneEntity];
    [MZMazeTileEmitter readMazeDefinitionAndCreateMazeTileEntities];
}


- (void)createTickEntity {
    [[_repo createEntity] addComponent:[MZTickComponent componentWithCurrentTick:0]];
}

- (void)createMazeLevelEntity {
    [[_repo createEntity] addComponent:[MZMazeLevelComponent componentWithLevel:1]];
}

- (void)createMoveHistoryEntity {
    [[_repo createEntity] addComponent:[MZMoveHistoryComponent componentWithMoves:@[]]];
}


- (void)createGameSceneEntity {
    ESEntity *gameSceneEntity = [_repo createEntity];
    [gameSceneEntity addComponent:[MZGameSceneComponent new]];
    [gameSceneEntity addComponent:[MZSpriteKitNodeComponent componentWithNode:self]];
}

-(void)createRootSystem {
    _rootSystem = [ESSystems new];
    [_rootSystem addSystem:[MZDisplayMazeTilesSystem new]];
    [_rootSystem addSystem:[MZDisplayCharacterSystem new]];
    [_rootSystem addSystem:[MZMoveHistorizedPacManSystem new]];
    [_rootSystem addSystem:[MZMovingSystem new]];
    [_rootSystem addSystem:[MZMovingAnimationSystem new]];
    [_rootSystem addSystem:[MZStopSystem new]];
    [_rootSystem addSystem:[MZCollectDotsSystem new]];
    [_rootSystem addSystem:[MZUpdateTileViewOnDotRemovalSystem new]];
    [_rootSystem addSystem:[MZCheckWinSystem new]];
    [_rootSystem addSystem:[MZTimeDisplayingSystem new]];
    [_rootSystem addSystem:[MZPacManEatPacManSystem new]];
    [_rootSystem addSystem:[MZGameOverPopupSystem new]];

}

-(void)update:(CFTimeInterval)currentTime {
    if([_repo singletonEntity:[MZGameOverComponent matcher]]){
        return;
    }
    ESEntity *tickEntity = [_repo singletonEntity:[MZTickComponent matcher]];
    [_rootSystem execute];
    [tickEntity exchangeComponent:[MZTickComponent componentWithCurrentTick:getComponent(tickEntity, MZTickComponent ).currentTick + 1]];
}

@end
