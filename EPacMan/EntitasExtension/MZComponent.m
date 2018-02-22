#import "Entitas.h"
#import "MZComponent.h"


@implementation MZComponent

+ (ESMatcher *)matcher {
    return [ESMatcher just:self];
}

@end
