#import "Entitas.h"

@class ESMatcher;


@interface MZComponent : NSObject<ESComponent>
+(ESMatcher *)matcher;
@end
