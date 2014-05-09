#import <Entitas/ESEntityRepository.h>
#import "MZPacManEatPacManSystem.h"
#import "ESRepositoryObserver.h"
#import "ESEntityRepository+Singleton.h"
#import "MZPositionComponent.h"
#import "MZPacManComponent.h"
#import "MZGameOverComponent.h"


@implementation MZPacManEatPacManSystem {
    ESEntityRepository *_repository;
    ESRepositoryObserver *_observer;
}

- (id)init {
    self = [super init];
    if (self) {
        _repository = [ESEntityRepository sharedRepository];
        _observer = [[ESRepositoryObserver alloc] initWithRepository:_repository matcher:[MZPositionComponent matcher]];
    }

    return self;
}


- (void)execute {
    if(_observer.drain.count == 0){
        return;
    }

    NSMutableDictionary *takenPositions = [NSMutableDictionary new];

    for (ESEntity *pacMan in [_repository entitiesForMatcher:[MZPacManComponent matcher]]){
        CGPoint position = getComponent(pacMan, MZPositionComponent).position;
        NSString *key = [NSString stringWithFormat:@"%gx%g", position.x, position.y];
        if (!takenPositions[key]){
            takenPositions[key] = @YES;
        } else {
            [[_repository createEntity] addComponent:[MZGameOverComponent componentWithState:LOSE]];
            return;
        }
    }
}

@end