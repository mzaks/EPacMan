#import <Foundation/Foundation.h>
#import "ESEntityRepository.h"

#define singletonComponent(repo, ComponentClassName) getComponent([repo singletonEntity:[ESMatcher just:[ComponentClassName class]]], ComponentClassName)

@interface ESEntityRepository (Singleton)

+ (instancetype)sharedRepository;

- (ESEntity *)singletonEntity:(ESMatcher *)componentClass;

@end