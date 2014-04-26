#import <Entitas/ESEntity.h>
#import <Entitas/ESMatcher.h>
#import <Entitas/ESCollection.h>
#import "ESEntityRepository+Singleton.h"
#import "ESEntityRepository+Internal.h"


@implementation ESEntityRepository (Singleton)

+ (id)sharedRepository {
    static ESEntityRepository *sharedRepository = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRepository = [[self alloc] init];
    });
    return sharedRepository;
}

- (ESEntity *)singletonEntity:(ESMatcher *)matcher {
    ESCollection *collection = [self collectionForMatcher:matcher];

    NSInteger count = collection.entities.count;
    NSAssert(count <= 1, @"Should have maximum 1 instance of the singleton entity with component %@, instead: %d", matcher, count);

    return [collection.entities firstObject];
}

@end