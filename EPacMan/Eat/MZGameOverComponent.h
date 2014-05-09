#import <Foundation/Foundation.h>
#import "MZComponent.h"

typedef NS_ENUM(NSInteger, MZGameOverState) {
    WIN,
    LOSE
};

@interface MZGameOverComponent : MZComponent

@property (readonly) MZGameOverState state;

- (instancetype)initWithState:(MZGameOverState)state;

+ (instancetype)componentWithState:(MZGameOverState)state;


@end