//
//  MZTimeDisplayingSystem.m
//  EPacMan
//
//  Created by Maxim Zaks on 09.05.14.
//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

#import "MZTimeDisplayingSystem.h"
#import "MZTickComponent.h"
#import "ESRepositoryObserver.h"
#import "ESEntityRepository+Singleton.h"
#import "MZGameViewController.h"

@implementation MZTimeDisplayingSystem{
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

    NSUInteger currentTick = singletonComponent(_repository, MZTickComponent).currentTick;

    if(currentTick % 60 != 0){
        return;
    }

    MZGameViewController *gameViewController = singletonComponent(_repository, MZGameViewControllerComponent).viewController;

    NSUInteger seconds = (currentTick / 60) % 60;
    NSUInteger minutes = currentTick / (60 * 60);

    gameViewController.timeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu", minutes, (unsigned long)seconds];
}


@end
