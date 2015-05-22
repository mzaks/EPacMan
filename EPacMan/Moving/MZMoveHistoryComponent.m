#import "MZMoveHistoryComponent.h"


@implementation MZMoveHistoryComponent {

}
- (instancetype)initWithMoves:(NSArray *)moves {
    self = [super init];
    if (self) {
        _moves = moves;
    }

    return self;
}

+ (instancetype)componentWithMoves:(NSArray *)moves {
    return [[self alloc] initWithMoves:moves];
}

@end