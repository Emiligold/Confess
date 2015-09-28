//
//  SkipContainer.m
//  Confess
//
//  Created by Noga badhav on 28/09/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "SkipContainer.h"

@interface SkipContainer ()

@end

@implementation SkipContainer

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

- (IBAction)exitClicked:(id)sender
{
    self.logInViewController.skipContainer.hidden = YES;
    [self.logInViewController.modalView removeFromSuperview];
}

-(void)initProperties:(ViewController*)viewController
{
    self.logInViewController = viewController;
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

@end
