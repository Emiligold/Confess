//
//  FacebookCell.m
//  Confess
//
//  Created by Noga badhav on 24/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "FacebookCell.h"

@implementation FacebookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Image initialize
        self.profileImage = [[UIImageView alloc] init];
        self.profileImage.layer.masksToBounds = YES;
        self.profileImage.layer.cornerRadius = 20;
        self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.profileImage];
        
        // Label initialize
        //CGRect frame = CGRectMake(0, 0, 220, 30);
        self.name = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[self.name setFrame:frame];
        //self.name.textAlignment = NSTextAlignmentCenter;
        [self.name setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.name];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithFriend:(NSDictionary<FBGraphUser> *)facebookFriend
{
    [self.name setTitle: facebookFriend.name forState: UIControlStateNormal];
    [self.name sizeToFit];
    self.profileImage.bounds = CGRectMake(0,0,50,50);
    self.profileImage.frame = CGRectMake(20,20,50,50);
    NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:[FacebookCell getUserUrl:facebookFriend]]];
    UIImage *image = [UIImage imageWithData:data];
    self.name.center = CGPointMake(self.contentView.frame.size.width / 2, 85);
    self.profileImage.image = image;
    self.profileImage.center = CGPointMake(self.contentView.frame.size.width / 2, 50);
    //cell.imageView.image = [UIImage imageWithData:data];
    //CGRect bounds;
    //bounds.origin = CGPointZero;
    //bounds.size = image.size;
    //self.profileImage.bounds = bounds;
    //self.profileImage.image = image;
    //self.profileImage.frame = CGRectMake(20, 20, image.size.width, image.size.height);
    //self.profileImage.center = self.profileImage.superview.center;
    //self.profileImage.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.profileImage.layer.masksToBounds = YES;
    //UIImage *newImage = [FacebookCell imageWithImage:image scaledToSize:newSize];
    //self.profileImage.image = image;
    //this line will do it!
    //self.profileImage.frame = CGRectMake(20, 20, newImage.size.width, newImage.size.height);
    //self.profileImage.clipsToBounds = YES;
    //self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
    self.profileImage.layer.cornerRadius = 20;
    //self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
}

+(NSString*)getUserUrl:(NSDictionary<FBGraphUser>*)user
{
    FBGraphObject *picture = [user objectForKey:@"picture"];
    FBGraphObject *check = [picture objectForKey:@"data"];
    return [check objectForKey:@"url"];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
