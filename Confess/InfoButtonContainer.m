//
//  InfoButtonContainer.m
//  Confess
//
//  Created by Noga badhav on 15/02/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "InfoButtonContainer.h"

@interface InfoButtonContainer ()

@end

@implementation InfoButtonContainer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)infoClicked:(UIButton*)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[sender tintColor] forState:UIControlStateNormal];
}

- (IBAction)infoButtonTouchDown:(UIButton*)sender
{
    sender.backgroundColor = [sender tintColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)infoButtonTouchOut:(UIButton*)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[sender tintColor] forState:UIControlStateNormal];
}

@end