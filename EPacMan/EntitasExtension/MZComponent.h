#import <Foundation/Foundation.h>
#import <Entitas/ESComponent.h>

@class ESMatcher;


@interface MZComponent : NSObject<ESComponent>
+(ESMatcher *)matcher;
@end