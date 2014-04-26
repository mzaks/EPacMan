#import "MZMazeTileEmitter.h"
#import "ESEntityRepository.h"
#import "ESEntityRepository+Singleton.h"
#import "ESEntity.h"
#import "MZPositionComponent.h"
#import "MZNotWalkableComponent.h"


@implementation MZMazeTileEmitter {

}
+ (void)readMazeDefinitionAndCreateMazeTileEntities {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"maze"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSArray* lines = [content componentsSeparatedByCharactersInSet:
            [NSCharacterSet newlineCharacterSet]];

    ESEntityRepository *repo = [ESEntityRepository sharedRepository];

    for (NSUInteger y = 0; y < lines.count; y++) {
        NSString *line = lines[y];
        for (int x = 0; x < line.length; x++) {
            unichar tileCharacter = [line characterAtIndex:x];
            ESEntity *mazeTileEntity = [repo createEntity];
            [mazeTileEntity addComponent:[MZPositionComponent componentWithPosition:CGPointMake(x, lines.count - y)]];
            if(tileCharacter == '#'){
                [mazeTileEntity addComponent:[MZNotWalkableComponent new]];
            }
        }
    }
    NSLog(@"Entities %i : %@", repo.allEntities.count, repo.allEntities);
}

@end