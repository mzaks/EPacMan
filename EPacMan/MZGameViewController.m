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
#import "MZMoveHistoryComponent.h"
#import "MZTickComponent.h"
#import "MZHistorizedComponent.h"

#import <GameController/GameController.h>

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
    NSMutableDictionary *_buttonImage;
    NSMutableDictionary *_buttonPressedImage;
    GCController *_gameController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKScene * scene = [MZGameScene sceneWithSize:_gameView.bounds.size];
    scene.scaleMode = SKSceneScaleModeFill;
    
    [_gameView presentScene:scene];
    _repository = [ESEntityRepository sharedRepository];
    [[_repository createEntity] addComponent:[MZGameViewControllerComponent componentWithViewController:self]];
    _buttonImage = [NSMutableDictionary new];
    _buttonPressedImage = [NSMutableDictionary new];
    _buttonImage[@(UP)] = ((UIButton *)_buttonsUp.firstObject).imageView.image;
    _buttonImage[@(DOWN)] = ((UIButton *)_buttonsDown.firstObject).imageView.image;
    _buttonImage[@(LEFT)] = _buttonLeft.imageView.image;
    _buttonImage[@(RIGHT)] = _buttonRight.imageView.image;

    [self createPressedImageInDirection:UP];
    [self createPressedImageInDirection:DOWN];
    [self createPressedImageInDirection:LEFT];
    [self createPressedImageInDirection:RIGHT];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectGameController) name:GCControllerDidConnectNotification object:nil];
    
}

- (void)connectGameController{
    _gameController = [[GCController controllers] firstObject];
    if(_gameController){
        _gameController.playerIndex = 0;
        _gameController.gamepad.dpad.valueChangedHandler = ^(GCControllerDirectionPad *dpad, float xValue, float yValue) {
            if (xValue == 0.0 && yValue == 0) {
                return;
            }
            if (fabsf(xValue)>fabsf(yValue)) {
                if (xValue>0) {
                    [self right:nil];
                }else{
                    [self left:nil];
                }
            } else {
                if (yValue>0) {
                    [self up:nil];
                } else {
                    [self down:nil];
                }
            }
        };
    }

}

- (void)createPressedImageInDirection:(enum MZDirection)direction {
    _buttonPressedImage[@(direction)] = [self imageBlackAndWhite:((UIImage *) _buttonImage[@(direction)])];
}

- (UIImage *)imageBlackAndWhite:(UIImage *)img
{
    CIImage *beginImage = [CIImage imageWithCGImage:img.CGImage];

    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;

    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage];

    CGImageRelease(cgiimage);

    return newImage;
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
    [self resetButtons];
    for (UIButton *button in _buttonsUp){
        [button setImage:_buttonPressedImage[@(UP)] forState:UIControlStateNormal];
    }
    MZWishDirectionComponent *directionComponent = [MZWishDirectionComponent componentWithDirection:UP];
    [self addWishDirectionComponent:directionComponent];
    [self addMoveToHistory:directionComponent];
}

- (IBAction)down:(id)sender
{
    [self resetButtons];
    for (UIButton *button in _buttonsDown){
        [button setImage:_buttonPressedImage[@(DOWN)] forState:UIControlStateNormal];
    }
    MZWishDirectionComponent *directionComponent = [MZWishDirectionComponent componentWithDirection:DOWN];
    [self addWishDirectionComponent:directionComponent];
    [self addMoveToHistory:directionComponent];
}

- (IBAction)right:(id)sender
{
    [self resetButtons];
    [_buttonRight setImage:_buttonPressedImage[@(RIGHT)] forState:UIControlStateNormal];
    MZWishDirectionComponent *directionComponent = [MZWishDirectionComponent componentWithDirection:RIGHT];
    [self addWishDirectionComponent:directionComponent];
    [self addMoveToHistory:directionComponent];
}

- (IBAction)left:(id)sender
{
    [self resetButtons];
    [_buttonLeft setImage:_buttonPressedImage[@(LEFT)] forState:UIControlStateNormal];
    MZWishDirectionComponent *directionComponent = [MZWishDirectionComponent componentWithDirection:LEFT];
    [self addWishDirectionComponent:directionComponent];
    [self addMoveToHistory:directionComponent];
}

- (void)addWishDirectionComponent:(MZWishDirectionComponent *)directionComponent {
    for(ESEntity *pacManEntity in [_repository entitiesForMatcher:[MZPacManComponent matcher]]){
        if([pacManEntity hasComponentOfType:[MZHistorizedComponent class]]){
            continue;
        }
        [pacManEntity exchangeComponent:directionComponent];
    }
}

- (void)addMoveToHistory:(MZWishDirectionComponent *)directionComponent {
    ESEntity *movesHistoryEntity = [_repository singletonEntity:[MZMoveHistoryComponent matcher]];
    NSMutableDictionary *movesDict = getComponent(movesHistoryEntity, MZMoveHistoryComponent).moves.lastObject;
    ESEntity *tickEntity = [_repository singletonEntity:[MZTickComponent matcher]];
    movesDict[@(getComponent(tickEntity, MZTickComponent).currentTick)] = directionComponent;
}

- (void)resetButtons {
    [_buttonLeft setImage:_buttonImage[@(LEFT)] forState:UIControlStateNormal];
    [_buttonRight setImage:_buttonImage[@(RIGHT)] forState:UIControlStateNormal];
    for (UIButton *button in _buttonsUp){
        [button setImage:_buttonImage[@(UP)] forState:UIControlStateNormal];
    }
    for (UIButton *button in _buttonsDown){
        [button setImage:_buttonImage[@(DOWN)] forState:UIControlStateNormal];
    }
}

@end
