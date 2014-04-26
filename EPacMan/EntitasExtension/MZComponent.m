#import <Entitas/ESMatcher.h>
#import "MZComponent.h"


@implementation MZComponent {

}
+ (ESMatcher *)matcher {
    return [ESMatcher just:self];
}

@end