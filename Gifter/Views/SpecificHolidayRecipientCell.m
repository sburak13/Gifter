//
//  SpecificHolidayRecipientCell.m
//  Gifter
//
//  Created by samanthaburak on 8/3/21.
//

#import "SpecificHolidayRecipientCell.h"

@implementation SpecificHolidayRecipientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPersonName:(NSString *)personName {
    _personName = personName;
    
    self.recipientNameLabel.text = personName;
    
}

@end
