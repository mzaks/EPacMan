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

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MZGameScene sceneWithSize:skView.bounds.size];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
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
    // Release any cached data, images, etc that aren't in use.
}

@end
