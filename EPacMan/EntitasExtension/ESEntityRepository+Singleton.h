#import <Foundation/Foundation.h>
#import "ESEntityRepository.h"

@interface ESEntityRepository (Singleton)

+ (id)sharedRepository;

- (ESEntity *)singletonEntity:(ESMatcher *)componentClass;

@end