#import <Foundation/Foundation.h>
#import "MZComponent.h"


@interface MZMoveHistoryComponent : MZComponent

@property (readonly) NSArray *moves;

- (instancetype)initWithMoves:(NSArray *)moves;

+ (instancetype)componentWithMoves:(NSArray *)moves;

@end