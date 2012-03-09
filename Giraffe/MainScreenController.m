//
//  ViewController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainScreenController.h"
#import <QuartzCore/QuartzCore.h>
#import "RotatingWheel.h"

@interface MainScreenController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet RotatingWheel *wheel;

@end

@implementation MainScreenController
@synthesize tableView, label, wheel=_wheel, needsLogin;

CFTimeInterval lastTime;
CGPoint lastPoint;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.needsLogin)
    {
        [self performSegueWithIdentifier:@"Login" sender:self];
    }
    
    self.wheel.layer.transform = CATransform3DMakeRotation(M_PI / 3.0, 0.0, 1.0, 0.0);     
 }

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setLabel:nil];
    [self setWheel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CFTimeInterval currentTime = CACurrentMediaTime();
    CGPoint currentPoint = scrollView.contentOffset;
    
    self.label.text = [NSString stringWithFormat:@"%f", (currentPoint.y - lastPoint.y) / (currentTime - lastTime) ];
    [self.wheel rotate:currentPoint.y];
    
    lastTime = currentTime;
    lastPoint = currentPoint;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = @"Generic";
    return cell;
}

@end
