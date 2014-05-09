#import "MZMovingSystem.h"
#import "ESMatcher.h"
#import "MZPositionComponent.h"
#import "MZStopedComponent.h"
#import "MZMovingComponent.h"
#import "ESRepositoryObserver.h"
#import "ESEntityRepository+Singleton.h"
#import "MZTileMap.h"
#import "MZNotWalkableComponent.h"
#import "MZWishDirectionComponent.h"
#import "MZTimeConstants.h"
#import "MZTickComponent.h"

@implementation MZMovingSystem {

    ESEntityRepository *_repository;
    ESRepositoryObserver *_observer;
    MZTileMap *_tileMap;
}

- (id)init {
    self = [super init];
    if (self) {
        _repository = [ESEntityRepository sharedRepository];
        _observer = [[ESRepositoryObserver alloc] initWithRepository:_repository
                                                             matcher:[ESMatcher allOf:[MZWishDirectionComponent class], [MZStopedComponent class], nil]];
        _tileMap = [MZTileMap sharedMap];
    }

    return self;
}


- (void)execute {

    MZTickComponent *tickComponent = getComponent([_repository singletonEntity:[MZTickComponent matcher]], MZTickComponent);

    for (ESEntity *character in [_observer drain]) {
        MZDirection wishDirection = getComponent(character, MZWishDirectionComponent).direction;
        MZDirection currentDirection = getComponent(character, MZMovingComponent).direction;
        if([self isCharacter:character ableToMoveInDirection:wishDirection]){
            [self triggerMovingAtTick:tickComponent forCharacter:character inDirection:wishDirection];
        } else if([character hasComponentOfType:[MZMovingComponent class]] && [self isCharacter:character ableToMoveInDirection:currentDirection]){
            [self triggerMovingAtTick:tickComponent forCharacter:character inDirection:currentDirection];
        } else {
            [character removeComponentOfType:[MZMovingComponent class]];
        }

    }
}

- (void)triggerMovingAtTick:(MZTickComponent *)tickComponent forCharacter:(ESEntity *)character inDirection:(MZDirection)direction {
    [character exchangeComponent:[MZMovingComponent componentWithDirection:direction
                                                                         startTick:tickComponent.currentTick
                                                                   durationInTicks:MOVE_DURATION_IN_TICKS]];
    [character removeComponentOfType:[MZStopedComponent class]];
}

- (BOOL)isCharacter:(ESEntity *)character ableToMoveInDirection:(MZDirection)direction {
    ESEntity *tile = [_tileMap tileEntityInDirection:direction fromEntityWithPosition:character];
    return ![tile hasComponentOfType:[MZNotWalkableComponent class]];
}

@end