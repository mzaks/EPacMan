#import <Entitas/ESEntity.h>
#import <Entitas/ESEntityRepository.h>
#import <Entitas/ESMatcher.h>
#import "MZGameOverPopupSystem.h"
#import "ESEntityRepository+Singleton.h"
#import "MZGameOverComponent.h"
#import "MZGameViewController.h"
#import "MZSpriteKitNodeComponent.h"
#import "MZGameScene.h"
#import "MZGameSceneComponent.h"


@implementation MZGameOverPopupSystem {
    ESEntityRepository *_repository;
}

- (id)init {
    self = [super init];
    if (self) {
        _repository = [ESEntityRepository sharedRepository];
    }

    return self;
}


- (void)execute {
    ESEntity *gameOver = [_repository singletonEntity:[MZGameOverComponent matcher]];

    if(gameOver) {
        NSString *time = singletonComponent(_repository, MZGameViewControllerComponent).viewController.timeLabel.text;
        NSString *title;
        NSString *message;
        if (getComponent(gameOver, MZGameOverComponent).state == WIN){
            title = @"Yeah!!!";
            message = [NSString stringWithFormat:@"You finished in %@", time];
        } else {
            title = @"Ouch!!!";
            message = [NSString stringWithFormat:@"You lost after %@", time];
        }


        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Replay!" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    ESEntity *sceneEntity = [_repository singletonEntity:[MZGameSceneComponent matcher]];
    MZGameScene *scene = (MZGameScene *) getComponent(sceneEntity , MZSpriteKitNodeComponent).node;
    [scene reset];
}

@end