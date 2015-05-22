#import "MZMazeTileEmitter.h"
#import "ESEntityRepository.h"
#import "ESEntityRepository+Singleton.h"
#import "ESEntity.h"
#import "MZPositionComponent.h"
#import "MZNotWalkableComponent.h"
#import "MZPacManComponent.h"
#import "MZDotComponent.h"
#import "MZBigDotComponent.h"
#import "MZGateComponent.h"
#import "MZMazeTileComponent.h"
#import "MZStopedComponent.h"
#import "MZMazeLevelComponent.h"
#import "MZMazeMetricsComponent.h"
#import "MZMoveHistoryComponent.h"
#import "MZHistorizedComponent.h"


@implementation MZMazeTileEmitter {

}
+ (void)readMazeDefinitionAndCreateMazeTileEntities {
    ESEntity *levelEntity = [[ESEntityRepository sharedRepository] singletonEntity:[MZMazeLevelComponent matcher]];
    MZMazeLevelComponent *mazeLevelComponent = getComponent(levelEntity, MZMazeLevelComponent);
    NSString *name = [NSString stringWithFormat:@"maze%lu", (unsigned long)mazeLevelComponent.level];
    NSLog(@"Maze : %@", name);
    NSString* path = [[NSBundle mainBundle] pathForResource:name
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSArray* lines = [content componentsSeparatedByCharactersInSet:
            [NSCharacterSet newlineCharacterSet]];

    ESEntityRepository *repo = [ESEntityRepository sharedRepository];

    [[repo createEntity] addComponent:[MZMazeMetricsComponent componentWithWidthInTiles:((NSString *)lines[0]).length heightInTiles:lines.count]];

    for (NSUInteger y = 0; y < lines.count; y++) {
        NSString *line = lines[y];
        for (NSUInteger x = 0; x < line.length; x++) {
            unichar tileCharacter = [line characterAtIndex:x];
            ESEntity *mazeTileEntity = [repo createEntity];
            [mazeTileEntity addComponent:[MZPositionComponent componentWithPosition:CGPointMake(x, lines.count - y)]];
            [mazeTileEntity addComponent:[MZMazeTileComponent new]];
            if(tileCharacter == '#'){
                [mazeTileEntity addComponent:[MZNotWalkableComponent new]];
            }
            if(tileCharacter == '.'){
                [mazeTileEntity addComponent:[MZDotComponent new]];
            }
            if(tileCharacter == 'o'){
                [mazeTileEntity addComponent:[MZBigDotComponent new]];
            }
            if(tileCharacter == '='){
                [mazeTileEntity addComponent:[MZGateComponent new]];
            }
            if(tileCharacter == '@'){
                ESEntity *pacMan = [repo createEntity];
                [pacMan addComponent:[MZPacManComponent new]];
                [pacMan addComponent:[MZPositionComponent componentWithPosition:CGPointMake(x, lines.count - y)]];
                [pacMan addComponent:[MZStopedComponent new]];
            }
        }
    }

    [self addHistorizedPacmans:repo];

}

+ (void)addHistorizedPacmans:(ESEntityRepository *)repo {
    NSArray *pacManEntities = [repo entitiesForMatcher:[MZPacManComponent matcher]];
    if(pacManEntities.count > 1){
        return;
    }

    ESEntity *moveHistoryEntity = [repo singletonEntity:[MZMoveHistoryComponent matcher]];
    NSArray *moves = getComponent(moveHistoryEntity, MZMoveHistoryComponent).moves;

    for(int i = 0; i < moves.count-1; i++){
        ESEntity *pacMan = [repo createEntity];
        [pacMan addComponent:[MZPacManComponent new]];
        [pacMan addComponent:[MZHistorizedComponent new]];
        [pacMan addComponent:[MZPositionComponent componentWithPosition:getComponent(pacManEntities.firstObject, MZPositionComponent).position]];
        [pacMan addComponent:[MZStopedComponent new]];
    }
}

@end