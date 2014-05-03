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
#import "MZCharacterMovingSystem.h"
#import "MZTileMap.h"

@implementation MZGameScene {
    ESEntityRepository *_repo;
    ESSystems *_rootSystem;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        _repo = [ESEntityRepository sharedRepository];
        [MZTileMap sharedMap];
        [self createRootSystem];
        [self createGameSceneEntity];
        [MZMazeTileEmitter readMazeDefinitionAndCreateMazeTileEntities];

    }
    return self;
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
    [_rootSystem addSystem:[MZCharacterMovingSystem new]];
}

-(void)update:(CFTimeInterval)currentTime {
    [_rootSystem execute];
}

@end
