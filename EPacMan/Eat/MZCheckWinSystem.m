#import "MZCheckWinSystem.h"
#import "ESRepositoryObserver.h"
#import "ESEntityRepository+Singleton.h"
#import "MZDotComponent.h"
#import "MZBigDotComponent.h"
#import "MZGameOverComponent.h"


@implementation MZCheckWinSystem {
    ESEntityRepository *_repository;
    ESRepositoryObserver *_observer;
}

- (id)init {
    self = [super init];
    if (self) {
        _repository = [ESEntityRepository sharedRepository];
        _observer = [[ESRepositoryObserver alloc] initWithRepository:_repository
                                                             matcher:[ESMatcher anyOf:[MZDotComponent class], [MZBigDotComponent class], nil]trigger:ESEntityRemoved];
    }

    return self;
}

- (void)execute {
    if([_observer drain].count == 0){
        return;
    }
    
    if ([_repository entitiesForMatcher:[ESMatcher anyOf:[MZDotComponent class], [MZBigDotComponent class], nil]].count == 0){
        [[_repository createEntity] addComponent:[MZGameOverComponent componentWithState:WIN]];
    }
    
}

@end