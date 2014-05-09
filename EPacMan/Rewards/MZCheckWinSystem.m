#import "MZCheckWinSystem.h"
#import "ESRepositoryObserver.h"
#import "ESEntityRepository+Singleton.h"
#import "MZDotComponent.h"
#import "MZBigDotComponent.h"
#import "MZTickComponent.h"
#import "MZGameSceneComponent.h"
#import "MZSpriteKitNodeComponent.h"
#import "MZGameScene.h"
#import "MZGameViewController.h"


@implementation MZCheckWinSystem {
    ESEntityRepository *_repository;
    ESRepositoryObserver *_observer;
}

- (id)init {
    self = [super init];
    if (self) {
        _repository = [ESEntityRepository sharedRepository];
        _observer = [[ESRepositoryObserver alloc] initWithRepository:_repository
                                                             matcher:[ESMatcher anyOf:[MZDotComponent class], [MZBigDotComponent class], nil]trigger:ESEntityRemoved];
    }

    return self;
}

- (void)execute {
    if([_observer drain].count == 0){
        return;
    }
    
    if ([_repository entitiesForMatcher:[ESMatcher anyOf:[MZDotComponent class], [MZBigDotComponent class], nil]].count == 0){
        ESEntity *tickEntity = [_repository singletonEntity:[MZTickComponent matcher]];
        NSString *time = singletonComponent(_repository, MZGameViewControllerComponent).viewController.timeLabel.text;
        NSString *message = [NSString stringWithFormat:@"You finished in %@", time];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Yeah!!!" message:message delegate:self cancelButtonTitle:@"Replay!" otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    ESEntity *sceneEntity = [_repository singletonEntity:[MZGameSceneComponent matcher]];
    MZGameScene *scene = (MZGameScene *) getComponent(sceneEntity , MZSpriteKitNodeComponent).node;
    [scene reset];
}

@end