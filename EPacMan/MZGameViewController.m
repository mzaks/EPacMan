//
//  MZGameViewController.m
//  EPacMan
//
//  Created by Maxim Zaks on 26.04.14.
//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

#import "MZGameViewController.h"
#import "MZGameScene.h"

@implementation MZGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKScene * scene = [MZGameScene sceneWithSize:_gameView.bounds.size];
    scene.scaleMode = SKSceneScaleModeFill;
    
    [_gameView presentScene:scene];
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

@end
