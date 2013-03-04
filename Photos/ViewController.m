//
//  ViewController.m
//  Photos
//
//  Created by Farhad Noorzay on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@implementation ViewController
@synthesize scrollView_;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self refresh:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.scrollView_ = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (IBAction)refresh:(id)sender
{
    NSInteger imagePerPage = 100;
    
    NSString *url = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=ccb1a44ee5bbf5b72ab0aff810fbeb43&per_page=%d&format=json&nojsoncallback=1", imagePerPage];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setCompletionBlock:^{
        //NSLog(@"%@", [request responseString]);
        
        NSString *str = [request responseString];
        NSDictionary *entries = [[str objectFromJSONString] valueForKey:@"photos"];
        
        NSArray *items = [entries valueForKey:@"photo"];
        
        CGFloat imageViewSize = 100.0f;
        CGFloat offset = self.view.frame.size.width * 0.1f;
        CGFloat x = offset;
        CGFloat y = offset;
        // Print the url of the images to load
        for (NSDictionary *item in items) {
            //http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
            NSString *farm = [item valueForKey:@"farm"];
            NSString *server = [item valueForKey:@"server"];
            NSString *secret = [item valueForKey:@"secret"];
            NSString *img_id = [item valueForKey:@"id"];
            NSString *imgURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", farm, server, img_id, secret, @"t"];
            //NSLog(@"%@", imgURL);
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageViewSize, imageViewSize)];
            iv.backgroundColor = [UIColor grayColor];
            [self.scrollView_ addSubview:iv];
            
            
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]]];
            iv.image = img;
            
            x += iv.frame.size.width + offset;
            
            if (x >= (self.view.frame.size.width)) {
                x = offset;
                y += offset + iv.frame.size.width;
            }
            
            [iv release];
        }
        
        CGFloat height = (y > self.scrollView_.frame.size.height) ? y : self.scrollView_.frame.size.height;
        self.scrollView_.contentSize = CGSizeMake(self.scrollView_.frame.size.width, height);
    }];
    
    [request setFailedBlock:^{
        NSLog(@"Error %@", [[request error] description]);
    }];
    
    [request startAsynchronous];

}

@end
