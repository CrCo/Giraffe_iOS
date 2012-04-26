//
//  TutorialViewController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialViewController.h"

#define CENTER_FRAME_IN_PARENT_WITH_MULTIPLE(child, index) child.frame = CGRectApplyAffineTransform(child.frame, CGAffineTransformMakeTranslation(CGRectGetWidth(child.superview.bounds) * index + (CGRectGetWidth(child.superview.bounds) - CGRectGetWidth(child.frame)) / 2, (CGRectGetHeight(child.superview.bounds) - CGRectGetHeight(child.frame)) / 2))


@interface TutorialViewController ()

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation TutorialViewController

@synthesize pageControl;
@synthesize scrollView = _scrollView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *allImages = [NSArray arrayWithObjects:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Content1"]], [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Content2"]], [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Content4"]], [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Content5"]], nil];
    
    for (int index = 0; index < allImages.count; index++)
    {
        UIImageView *view = [allImages objectAtIndex:index];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin];
        [self.scrollView addSubview:view];
        CENTER_FRAME_IN_PARENT_WITH_MULTIPLE(view, index);
    }
    
    self.scrollView.contentSize = CGSizeApplyAffineTransform(self.scrollView.bounds.size, CGAffineTransformMakeScale(allImages.count, 1));
}

- (void)viewDidUnload
{
    [self setPageControl:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = roundl(scrollView.contentOffset.x /scrollView.bounds.size.width);
}

@end
