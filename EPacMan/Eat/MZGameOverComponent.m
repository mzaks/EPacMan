#import "MZGameOverComponent.h"


@implementation MZGameOverComponent {

}
- (instancetype)initWithState:(MZGameOverState)state {
    self = [super init];
    if (self) {
        _state = state;
    }

    return self;
}

+ (instancetype)componentWithState:(MZGameOverState)state {
    return [[self alloc] initWithState:state];
}

@end