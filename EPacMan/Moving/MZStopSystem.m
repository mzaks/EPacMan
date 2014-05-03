#import <Entitas/ESEntity.h>
#import "MZStopSystem.h"
#import "ESEntityRepository+Singleton.h"
#import "MZTickComponent.h"
#import "MZMovingComponent.h"
#import "MZTileMap.h"
#import "MZStopedComponent.h"
#import "MZPositionComponent.h"


@implementation MZStopSystem {

    ESEntityRepository *_repository;
    MZTileMap *_tileMap;
}

- (id)init {
    self = [super init];
    if (self) {
        _repository = [ESEntityRepository sharedRepository];
        _tileMap = [MZTileMap sharedMap];
    }

    return self;
}


- (void)execute {
    ESEntity * tickEntity = [_repository singletonEntity:[MZTickComponent matcher]];
    for (ESEntity *movingEntity in [_repository entitiesForMatcher:[MZMovingComponent matcher]]) {
        MZMovingComponent *movingComponent = getComponent(movingEntity, MZMovingComponent);
        NSUInteger moveEndTick = movingComponent.startTick + movingComponent.durationInTicks;
        if (getComponent(tickEntity, MZTickComponent).currentTick >= moveEndTick){
            ESEntity *tile = [_tileMap tileEntityInDirection:movingComponent.direction fromEntityWithPosition:movingEntity];
            CGPoint position = getComponent(tile, MZPositionComponent).position;
            [movingEntity exchangeComponent:[MZPositionComponent componentWithPosition:position]];
            [movingEntity addComponent:[MZStopedComponent new]];
        }
    }
}

@end