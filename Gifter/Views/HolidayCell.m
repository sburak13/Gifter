//
//  HolidayCell.m
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import "HolidayCell.h"
#import "Person.h"

@implementation HolidayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHoliday:(Holiday *)holiday {
    _holiday = holiday;
    
    self.nameLabel.text = holiday.name;
    // self.dateLabel.text = holiday.date;
    
    self.recipientsLabel.text = [[holiday.recipientNames valueForKey:@"description"] componentsJoinedByString:@", "];
    
    
    // NSMutableArray *recipientNames = [NSMutableArray array];
    // NSArray *recipients = holiday.recipients;
    
    /*
    for (int i = 0; i < recipients.count; i++) {
        Person *person = (Person*)recipients[i];
        [recipientNames addObject:person[@"name"]];
        
        
        [person fetchIfNeededInBackgroundWithBlock:^(PFObject *person, NSError *error) {
            if (person) {
                Person *newPerson = (Person*)person;
                NSLog(@"%@", newPerson.name);
                
                [recipientNames addObject:newPerson.name];
                if (i == recipients.count - 1) {
                    self.recipientsLabel.text = [[recipientNames valueForKey:@"description"] componentsJoinedByString:@", "];
                    
                }
            } else {
                NSLog(@"Failed to fetch person");
            }
        }];
    
    }
    */
    

    
}


@end
