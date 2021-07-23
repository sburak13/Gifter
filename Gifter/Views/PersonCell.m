//
//  PersonCell.m
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import "PersonCell.h"

@implementation PersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPerson:(Person *)person {
    _person = person;
    
    self.nameLabel.text = person.name;
    NSString *interests = [[person.interests valueForKey:@"description"] componentsJoinedByString:@", "];
    if (interests) {
        self.interestsLabel.text = [@"Interests: " stringByAppendingString:interests];
    }
    
    if (person.budgetAmt) {
        NSLog(@"hiii");
        self.budgetLabel.text = [@"Budget: $" stringByAppendingString:[person.budgetAmt stringValue]];
        // NSLog(@"hiii");
    } else {
        self.budgetLabel.text = @"Budget: None";
    }
    
}

@end
