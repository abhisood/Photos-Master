//
//  ThumbnailTableViewCell.m
//  Photos
//
//  Created by Sood, Abhishek on 3/4/13.
//
//

#import "ThumbnailTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ThumbnailTableViewCell

@synthesize rowHeight = _rowHeight;
@synthesize insets = _insets;
@synthesize loadImageOperations;
@synthesize indexPath;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageViews = [NSMutableArray new];
        self.rowHeight = 100;
        self.insets = UIEdgeInsetsMake(5, 10, 5, 10);
        loadImageOperations = [NSMutableArray new];
        UITapGestureRecognizer* tapRecoganizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        tapRecoganizer.numberOfTapsRequired = 1;
        tapRecoganizer.numberOfTouchesRequired = 1;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tapRecoganizer];
    }
    return self;
}

-(void)cellTapped:(UITapGestureRecognizer*)tap{
    CGPoint point = [tap locationInView:self];
    int i =0;
    for (UIImageView* v in _imageViews) {
        if (CGRectContainsPoint(v.frame, point)) {
            [delegate thumbnailCell:self didSelectImageAtIndex:i];
            break;
        }
        i++;
    }
}

-(void)dealloc{
    [loadImageOperations release];
    [_imageViews release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRowHeight:(CGFloat)rowHeight{
    _rowHeight = rowHeight;
    [self setNeedsLayout];
}

-(void)setNumberOfImages:(int)numberOfImages{
    _numberOfImages = numberOfImages;
    if (_numberOfImages > [_imageViews count]) {
        for (int i = [_imageViews count]; i<_numberOfImages; i++) {
            UIImageView* imView = [[[UIImageView alloc] init] autorelease];
            [_imageViews addObject:imView];
            imView.contentMode = UIViewContentModeScaleAspectFill;
            imView.clipsToBounds = YES;
            [imView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
            [imView.layer setBorderWidth: 2.0];
            [self addSubview:imView];
            imView.userInteractionEnabled = NO;
        }
    }
    [self setNeedsLayout];
}

-(void)setInsets:(UIEdgeInsets)insets{
    _insets = insets;
    [self setNeedsLayout];
}

-(void)setImages:(NSArray *)images{
    for (UIImageView* view in _imageViews) {
        view.image = nil;
        view.hidden = YES;
    }

    int minCount = images.count < _imageViews.count? images.count: _imageViews.count;
    for (int i =0; i<minCount; i++) {
        UIImageView* view = _imageViews[i];
        view.image = images[i];
        view.hidden = NO;
    }
}

-(UIImageView *)imageViewForIndex:(NSUInteger)index{
    return _imageViews[index];
}

-(void)layoutSubviews{
    CGFloat imageViewHeight = self.rowHeight - self.insets.top - self.insets.bottom;
    CGFloat gap = (self.insets.left + self.insets.right)/4;
    CGFloat imageViewWidth = self.bounds.size.width - self.insets.left - self.insets.right;
    imageViewWidth -= (self.numberOfImages -1) * gap;
    imageViewWidth /= self.numberOfImages;
    
    CGFloat x = self.insets.left;
    CGFloat y = self.insets.top;
    for (UIImageView* view in _imageViews) {
        view.frame = CGRectMake(x, y, imageViewWidth, imageViewHeight);
        x += (imageViewWidth + gap);
    }
}

@end
