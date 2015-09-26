//
//  ReturnButtonContainer.m
//  Confess
//
//  Created by Noga badhav on 14/02/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "ReturnButtonContainer.h"

@interface ReturnButtonContainer ()

@end

@implementation ReturnButtonContainer

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

- (IBAction)returnClicked:(UIButton*)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[sender tintColor] forState:UIControlStateNormal];
    NSRange cursorPosition = [self.confessFriend.content selectedRange];
    NSMutableString *tfContent = [[NSMutableString alloc] initWithString:self.confessFriend.content.text];
    self.confessFriend.numberOfLines++;
    
    if (self.confessFriend.numberOfLines > MAX_LINES)
    {
        self.confessFriend.numberOfLines = MAX_LINES;
        [self.confessFriend.content resignFirstResponder];
    }
    else
    {
        [tfContent insertString:@"\n" atIndex:cursorPosition.location];
        [self.confessFriend.content setText:tfContent];
    }
}

- (IBAction)returnTouchDown:(UIButton*)sender
{
    sender.backgroundColor = [sender tintColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)returnTouchOut:(UIButton*)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[sender tintColor] forState:UIControlStateNormal];
}

@end
