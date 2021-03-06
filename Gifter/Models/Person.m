//
//  Person.m
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import "Person.h"

@implementation Person

@dynamic user;
@dynamic name;
@dynamic interests;
@dynamic budgetAmt;
@dynamic starredBaskets;

+ (nonnull NSString *)parseClassName {
    return @"Person";
}

+ (void)createPerson: ( NSString * _Nullable )name withInterests: ( NSMutableArray * _Nullable )interests withBudget: ( NSNumber * _Nullable)budget withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Person *newPerson = [Person new];
    newPerson.user = [PFUser currentUser];
    newPerson.name = name;
    newPerson.interests = interests;
    newPerson.budgetAmt = budget;
    
    [newPerson saveInBackgroundWithBlock: completion];
    
    newPerson.starredBaskets = [NSMutableArray array];
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];

    if (copy) {
        // Copy NSObject subclasses
        [copy setName:[self.name copyWithZone:zone]];
        [copy setInterests:[self.interests copyWithZone:zone]];
        [copy setBudgetAmt:[self.budgetAmt copyWithZone:zone]];
    }

    return copy;
}

@end

