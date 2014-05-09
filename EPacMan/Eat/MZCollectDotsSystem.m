#import <Entitas/ESEntityRepository.h>
#import <Entitas/ESRepositoryObserver.h>
#import "MZCollectDotsSystem.h"
#import "ESEntityRepository+Singleton.h"
#import "MZPacManComponent.h"
#import "MZPositionComponent.h"
#import "MZTileMap.h"
#import "MZDotComponent.h"
#import "MZBigDotComponent.h"


@implementation MZCollectDotsSystem {
    ESEntityRepository *_repository;
    ESRepositoryObserver *_observer;
    MZTileMap *_tileMap;
}

- (id)init {
    self = [super init];
    if (self) {
        _repository = [ESEntityRepository sharedRepository];
        _observer = [[ESRepositoryObserver alloc] initWithRepository:_repository 
                                                             matcher:[ESMatcher allOf:[MZPacManComponent class], [MZPositionComponent class], nil]];
        _tileMap = [MZTileMap sharedMap];
    }

    return self;
}


- (void)execute {
    for (ESEntity *pacman in [_observer drain]){
        CGPoint position = getComponent(pacman, MZPositionComponent).position;
        ESEntity *tile = [_tileMap tileEntityAtPosition:position];
        if([tile hasComponentOfType:[MZDotComponent class]]){
            [tile removeComponentOfType:[MZDotComponent class]];
        } else if([tile hasComponentOfType:[MZBigDotComponent class]]){
            [tile removeComponentOfType:[MZBigDotComponent class]];
        }
    }
}

@end