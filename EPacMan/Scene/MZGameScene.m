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

@implementation MZGameScene {
    ESEntityRepository *_repo;
    ESSystems *_rootSystem;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        _repo = [ESEntityRepository sharedRepository];
        [self createTickEntity];
        [MZTileMap sharedMap];
        [self createRootSystem];
        [self createGameSceneEntity];
        [MZMazeTileEmitter readMazeDefinitionAndCreateMazeTileEntities];
    }
    return self;
}

- (void)createTickEntity {
    [[_repo createEntity] addComponent:[MZTickComponent componentWithCurrentTick:0]];
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
    [_rootSystem addSystem:[MZMovingSystem new]];
    [_rootSystem addSystem:[MZMovingAnimationSystem new]];
    [_rootSystem addSystem:[MZStopSystem new]];
}

-(void)update:(CFTimeInterval)currentTime {
    ESEntity *tickEntity = [_repo singletonEntity:[MZTickComponent matcher]];
    [_rootSystem execute];
    [tickEntity exchangeComponent:[MZTickComponent componentWithCurrentTick:getComponent(tickEntity, MZTickComponent ).currentTick + 1]];
}

@end
