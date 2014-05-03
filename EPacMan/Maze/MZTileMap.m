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

- (void)entity:(ESEntity *)changedEntity changedInCollection:(ESCollection *)collection withChangeType:(ESEntityChange)changeType {
    MZPositionComponent *positionComponent = getComponent(changedEntity, MZPositionComponent);
    NSNumber *mapIndex = @(positionComponent.position.x + (positionComponent.position.y * 21));
    _map[mapIndex] = changedEntity;
}

- (ESEntity *)tileEntityAtPosition:(CGPoint)position{
    NSNumber *mapIndex = @(position.x + (position.y * 21));
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

    NSAssert(NO, @"direction: %n unknown", direction);

    return nil;
}


- (ESEntity *)tileEntityLeftFromPosition:(MZPositionComponent *)positionComponent{

    CGFloat x = positionComponent.position.x - 1;
    if(x<0){
        x = 20;
    }
    NSNumber *mapIndex = @(x + (positionComponent.position.y * 21));
    return _map[mapIndex];
}

- (ESEntity *)tileEntityRightFromTileEntity:(MZPositionComponent *)positionComponent{
    CGFloat x = (positionComponent.position.x + 1);
    if(x>=21){
        x = 0;
    }
    NSNumber *mapIndex = @(x + (positionComponent.position.y * 21));
    return _map[mapIndex];
}

- (ESEntity *)tileEntityUpFromTileEntity:(MZPositionComponent *)positionComponent{
    CGFloat y = (positionComponent.position.y + 1);
    if(y>=28){
        y = 0;
    }

    NSNumber *mapIndex = @(positionComponent.position.x + (y * 21));
    return _map[mapIndex];
}

- (ESEntity *)tileEntityDownFromTileEntity:(MZPositionComponent *)positionComponent{
    CGFloat y = (positionComponent.position.y - 1);
    if(y<0){
        y = 26;
    }
    NSNumber *mapIndex = @(positionComponent.position.x + (y * 21));
    return _map[mapIndex];
}


@end
