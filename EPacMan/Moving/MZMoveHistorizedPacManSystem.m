#import "MZMoveHistorizedPacManSystem.h"
#import "ESEntity.h"
#import "ESEntityRepository.h"
#import "ESEntityRepository+Singleton.h"
#import "ESMatcher.h"
#import "MZPacManComponent.h"
#import "MZHistorizedComponent.h"
#import "MZMoveHistoryComponent.h"
#import "MZTickComponent.h"
#import "MZWishDirectionComponent.h"


@implementation MZMoveHistorizedPacManSystem {
}

- (void)execute {
    ESEntityRepository *repo = [ESEntityRepository sharedRepository];
    NSArray * historizedPacmans = [repo entitiesForMatcher:[ESMatcher allOf:[MZPacManComponent class], [MZHistorizedComponent class], nil]];
    ESEntity *historyOfMoves = [repo singletonEntity:[MZMoveHistoryComponent matcher]];
    NSArray *moves = getComponent(historyOfMoves, MZMoveHistoryComponent).moves;
    ESEntity *tickEntity = [repo singletonEntity:[MZTickComponent matcher]];
    for(int i = 0; i < historizedPacmans.count; i++){
        ESEntity *pacman = historizedPacmans[i];
        MZWishDirectionComponent *directionComponent = moves[i][@(getComponent(tickEntity, MZTickComponent ).currentTick)];
        if(directionComponent){
            [pacman exchangeComponent:directionComponent];
        }
    }
}

@end