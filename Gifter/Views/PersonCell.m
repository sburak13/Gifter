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

/*
- (IBAction)didTapGenerate:(id)sender {
    [self performSegueWithIdentifier:@"giftStreamSegue" sender:self];
}
*/

- (void)setPerson:(Person *)person {
    _person = person;
    
    self.nameLabel.text = person.name;
    
    NSString *interests = [[person.interests valueForKey:@"description"] componentsJoinedByString:@", "];
    if (interests) {
        NSString *interestsString = [@"Interests: " stringByAppendingString:interests];
        NSMutableAttributedString *interestsAttributedString = [[NSMutableAttributedString alloc] initWithString:interestsString];
        NSString *boldString = @"Interests:";
        NSRange boldRange = [interestsString rangeOfString:boldString];
        [interestsAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:boldRange];
        [self.interestsLabel setAttributedText: interestsAttributedString];
    }
    
    if (person.budgetAmt) {
        NSString *budgetString = [@"Budget: $" stringByAppendingString:[person.budgetAmt stringValue]];
        NSMutableAttributedString *budgetAttributedString = [[NSMutableAttributedString alloc] initWithString:budgetString];
        NSString *boldString = @"Budget:";
        NSRange boldRange = [budgetString rangeOfString:boldString];
        [budgetAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:boldRange];
        [self.budgetLabel setAttributedText: budgetAttributedString];
    }
}

@end
