#import <SpriteKit/SpriteKit.h>
#import "MZCharacterMovingSystem.h"
#import "ESMatcher.h"
#import "MZPositionComponent.h"
#import "MZStopedComponent.h"
#import "MZMovingDirectionComponent.h"
#import "ESRepositoryObserver.h"
#import "ESEntityRepository+Singleton.h"
#import "MZTileMap.h"
#import "MZNotWalkableComponent.h"
#import "MZSpriteKitNodeComponent.h"
#import "MZWishMovingDirectionComponent.h"
#import "MZCharacterConstants.h"

@implementation MZCharacterMovingSystem {

    ESEntityRepository *_repository;
    ESRepositoryObserver *_observer;
}

- (id)init {
    self = [super init];
    if (self) {
        _repository = [ESEntityRepository sharedRepository];
        _observer = [[ESRepositoryObserver alloc] initWithRepository:_repository
                                                             matcher:[ESMatcher allOf:[MZWishMovingDirectionComponent class], [MZStopedComponent class], nil]];
    }

    return self;
}


- (void)execute {
    for (ESEntity *character in [_observer drain]) {
        MZDirection wishDirection = getComponent(character, MZWishMovingDirectionComponent).direction;
        ESEntity *tile = [[MZTileMap sharedMap] tileEntityInDirection:wishDirection fromEntityWithPosition:character];
        if (![tile hasComponentOfType:[MZNotWalkableComponent class]]){
            [character exchangeComponent:[MZMovingDirectionComponent componentWithDirection:wishDirection]];
        }
        MZDirection direction = getComponent(character, MZMovingDirectionComponent).direction;
        tile = [[MZTileMap sharedMap] tileEntityInDirection:direction fromEntityWithPosition:character];
        if ([tile hasComponentOfType:[MZNotWalkableComponent class]]){
            continue;
        }
        [character removeComponentOfType:[MZStopedComponent class]];
        CGPoint position = getComponent(tile, MZSpriteKitNodeComponent).node.position;
        CGPoint tilePosition = getComponent(tile, MZPositionComponent).position;
        SKSpriteNode *node = (SKSpriteNode *) getComponent(character, MZSpriteKitNodeComponent).node;
        [node runAction:[SKAction moveTo:position duration:MOVE_DURATION_IN_TICKS/60.0]completion:^{
            [character exchangeComponent:[MZStopedComponent new]];
            [character exchangeComponent:[MZPositionComponent componentWithPosition:tilePosition]];
        }];
    }
}

@end