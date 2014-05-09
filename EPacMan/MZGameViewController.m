//
//  MZGameViewController.m
//  EPacMan
//
//  Created by Maxim Zaks on 26.04.14.
//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

#import "MZGameViewController.h"
#import "MZGameScene.h"
#import "ESEntityRepository.h"
#import "ESEntityRepository+Singleton.h"
#import "MZPacManComponent.h"
#import "ESEntity.h"
#import "MZMovingComponent.h"
#import "MZWishDirectionComponent.h"

@implementation MZGameViewControllerComponent
- (instancetype)initWithViewController:(MZGameViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }

    return self;
}

+ (instancetype)componentWithViewController:(MZGameViewController *)viewController {
    return [[self alloc] initWithViewController:viewController];
}


@end

@implementation MZGameViewController {
    ESEntityRepository *_repository;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKScene * scene = [MZGameScene sceneWithSize:_gameView.bounds.size];
    scene.scaleMode = SKSceneScaleModeFill;
    
    [_gameView presentScene:scene];
    _repository = [ESEntityRepository sharedRepository];
    [[_repository createEntity] addComponent:[MZGameViewControllerComponent componentWithViewController:self]];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)up:(id)sender
{
//    ESEntity *pacManEntity = [_repository singletonEntity:[MZPacManComponent matcher]];
    for(ESEntity *pacManEntity in [_repository entitiesForMatcher:[MZPacManComponent matcher]]){
        [pacManEntity exchangeComponent:[MZWishDirectionComponent componentWithDirection:UP]];
    }
}

- (IBAction)down:(id)sender
{
//    ESEntity *pacManEntity = [_repository singletonEntity:[MZPacManComponent matcher]];
    for(ESEntity *pacManEntity in [_repository entitiesForMatcher:[MZPacManComponent matcher]]){
        [pacManEntity exchangeComponent:[MZWishDirectionComponent componentWithDirection:DOWN]];
    }
}

- (IBAction)right:(id)sender
{
//    ESEntity *pacManEntity = [_repository singletonEntity:[MZPacManComponent matcher]];
    for(ESEntity *pacManEntity in [_repository entitiesForMatcher:[MZPacManComponent matcher]]){
        [pacManEntity exchangeComponent:[MZWishDirectionComponent componentWithDirection:RIGHT]];
    }

}

- (IBAction)left:(id)sender
{
//    ESEntity *pacManEntity = [_repository singletonEntity:[MZPacManComponent matcher]];
    for(ESEntity *pacManEntity in [_repository entitiesForMatcher:[MZPacManComponent matcher]]){
        [pacManEntity exchangeComponent:[MZWishDirectionComponent componentWithDirection:LEFT]];
    }
}

@end
