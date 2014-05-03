#import <Foundation/Foundation.h>
#import "ESEntityRepository.h"

@interface ESEntityRepository (Singleton)

+ (instancetype)sharedRepository;

- (ESEntity *)singletonEntity:(ESMatcher *)componentClass;

@end