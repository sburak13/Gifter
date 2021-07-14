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
    self.interestsLabel.text = interests;
}

@end
