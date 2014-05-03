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
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)up:(id)sender {
    ESEntity *pacManEntity = [_repository singletonEntity:[MZPacManComponent matcher]];
    [pacManEntity exchangeComponent:[MZWishDirectionComponent componentWithDirection:UP]];
}
- (IBAction)down:(id)sender {
    ESEntity *pacManEntity = [_repository singletonEntity:[MZPacManComponent matcher]];
    [pacManEntity exchangeComponent:[MZWishDirectionComponent componentWithDirection:DOWN]];
}
- (IBAction)right:(id)sender {
    ESEntity *pacManEntity = [_repository singletonEntity:[MZPacManComponent matcher]];
    [pacManEntity exchangeComponent:[MZWishDirectionComponent componentWithDirection:RIGHT]];
}
- (IBAction)left:(id)sender {
    ESEntity *pacManEntity = [_repository singletonEntity:[MZPacManComponent matcher]];
    [pacManEntity exchangeComponent:[MZWishDirectionComponent componentWithDirection:LEFT]];
}

@end
