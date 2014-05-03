//
//  MZTileMap.h
//  EPacMan
//
//  Created by Maxim Zaks on 01.05.14.
//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESCollection.h"
#import "MZDirection.h"
#import "MZComponent.h"

@interface MZTileMap : NSObject <ESCollectionObserver>

+ (instancetype)sharedMap;

- (ESEntity *)tileEntityAtPosition:(CGPoint)position;

- (ESEntity *)tileEntityInDirection:(MZDirection)direction fromEntityWithPosition:(ESEntity *)tile;

@end