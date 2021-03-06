//
//  MZTileMap.m
//  EPacMan
//
//  Created by Maxim Zaks on 01.05.14.
//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

#import "MZTileMap.h"
#import "ESEntityRepository+Singleton.h"
#import "ESEntityRepository+Internal.h"
#import "MZMazeTileComponent.h"
#import "MZPositionComponent.h"
#import "MZMazeMetricsComponent.h"

@implementation MZTileMap {
    ESEntityRepository *_repository;
    ESCollection *_tileCollection;
    NSMutableDictionary *_map;
}

+ (instancetype)sharedMap {
    static MZTileMap *sharedMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMap = [[self alloc] init];
    });
    return sharedMap;

}

- (id)init {
    self = [super init];
    if (self) {
        _repository = [ESEntityRepository sharedRepository];
        _tileCollection = [_repository collectionForMatcher:[ESMatcher allOf:[MZMazeTileComponent class], [MZPositionComponent class], nil]];
        _map = [NSMutableDictionary new];
        [_tileCollection addObserver:self forEvent:ESEntityAdded];
    }

    return self;
}

-(void)reset{
    [_map removeAllObjects];
}

- (void)entity:(ESEntity *)changedEntity changedInCollection:(ESCollection *)collection withChangeType:(ESEntityChange)changeType {
    MZPositionComponent *positionComponent = getComponent(changedEntity, MZPositionComponent);
    NSNumber *mapIndex = @(positionComponent.position.x + (positionComponent.position.y * [self mazeWidth]));
    _map[mapIndex] = changedEntity;
}

- (ESEntity *)tileEntityAtPosition:(CGPoint)position{
    if(position.x<0 || position.y<0){
        return nil;
    }
    if(position.x>[self mazeWidth]-1){
        return nil;
    }
    NSNumber *mapIndex = @(position.x + (position.y * [self mazeWidth]));
    return _map[mapIndex];
}

- (ESEntity *)tileEntityInDirection:(MZDirection)direction fromEntityWithPosition:(ESEntity *)entity {
    MZPositionComponent *positionComponent = getComponent(entity, MZPositionComponent);
    NSAssert(positionComponent, @"Entity :%@ shoudl have position component", entity);

    if (direction == LEFT){
        return [self tileEntityLeftFromPosition:positionComponent];
    } else if (direction == RIGHT){
        return [self tileEntityRightFromTileEntity:positionComponent];
    }else if (direction == UP){
        return [self tileEntityUpFromTileEntity:positionComponent];
    }else if (direction == DOWN){
        return [self tileEntityDownFromTileEntity:positionComponent];
    }

    NSAssert(NO, @"direction: %i unknown", direction);

    return nil;
}


- (ESEntity *)tileEntityLeftFromPosition:(MZPositionComponent *)positionComponent{

    CGFloat x = positionComponent.position.x - 1;
    if(x<0){
        x = [self mazeWidth]-1;
    }
    NSNumber *mapIndex = @(x + (positionComponent.position.y * [self mazeWidth]));
    return _map[mapIndex];
}

- (ESEntity *)tileEntityRightFromTileEntity:(MZPositionComponent *)positionComponent{
    CGFloat x = (positionComponent.position.x + 1);
    if(x>=[self mazeWidth]){
        x = 0;
    }
    NSNumber *mapIndex = @(x + (positionComponent.position.y * [self mazeWidth]));
    return _map[mapIndex];
}

- (ESEntity *)tileEntityUpFromTileEntity:(MZPositionComponent *)positionComponent{
    CGFloat y = (positionComponent.position.y + 1);
    if(y>=[self mazeHeight]+1){
        y = 0;
    }

    NSNumber *mapIndex = @(positionComponent.position.x + (y * [self mazeWidth]));
    return _map[mapIndex];
}

- (ESEntity *)tileEntityDownFromTileEntity:(MZPositionComponent *)positionComponent{
    CGFloat y = (positionComponent.position.y - 1);
    if(y<0){
        y = [self mazeHeight]-1;
    }
    NSNumber *mapIndex = @(positionComponent.position.x + (y * [self mazeWidth]));
    return _map[mapIndex];
}

- (NSUInteger)mazeWidth {
    ESEntity *metricEntity = [_repository singletonEntity:[MZMazeMetricsComponent matcher]];
    return getComponent(metricEntity, MZMazeMetricsComponent).widthInTiles;
}

- (NSUInteger)mazeHeight {
    return getComponent([_repository singletonEntity:[MZMazeMetricsComponent matcher]], MZMazeMetricsComponent).heightInTiles;
}


@end
