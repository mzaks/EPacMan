//
//  MZGameViewController.h
//  EPacMan
//

//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

#import "MZComponent.h"
@class MZGameViewController;

@interface MZGameViewControllerComponent : MZComponent

@property (readonly) MZGameViewController *viewController;

- (instancetype)initWithViewController:(MZGameViewController *)viewController;

+ (instancetype)componentWithViewController:(MZGameViewController *)viewController;


@end

@interface MZGameViewController : UIViewController
@property (weak, nonatomic) IBOutlet SKView *gameView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
