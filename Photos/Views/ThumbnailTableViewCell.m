//
//  ThumbnailTableViewCell.m
//  Photos
//
//  Created by Sood, Abhishek on 3/4/13.
//
//

#import "ThumbnailTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ThumbnailImageLayer ()

@end


@implementation ThumbnailImageLayer

@synthesize imageLayer = _imageLayer;
@synthesize shadowLayer = _shadowLayer;

-(id)init{
    if (self = [super init]) {
        _shadowLayer = [[CALayer layer] retain];
        _shadowLayer.backgroundColor = [UIColor blackColor].CGColor;
        _shadowLayer.borderColor = [UIColor whiteColor].CGColor;
        _shadowLayer.borderWidth = 2.0;
        [self addSublayer:_shadowLayer];
        
        _imageLayer = [[CALayer layer] retain];
        [_shadowLayer addSublayer:_imageLayer];
        
        _shadowLayer.opaque = YES;
        _imageLayer.opaque = YES;
    }
    return self;
}

-(void)dealloc{
    [_imageLayer release];
    [_shadowLayer release];
    [super dealloc];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.imageLayer.frame = self.bounds;
    self.shadowLayer.frame = self.bounds;
}

@end





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
        _imageLayers = [NSMutableArray new];
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
    for (CALayer* v in _imageLayers) {
        if (!v.isHidden && CGRectContainsPoint(v.frame, point)) {
            [delegate thumbnailCell:self didSelectImageAtIndex:i];
            break;
        }
        i++;
    }
}

-(void)dealloc{
    [loadImageOperations release];
    [_imageLayers release];
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
    if (_numberOfImages > [_imageLayers count]) {
        for (int i = [_imageLayers count]; i<_numberOfImages; i++) {
            ThumbnailImageLayer *layer = [ThumbnailImageLayer layer];
            [self.layer addSublayer:layer];
            [_imageLayers addObject:layer];
        }
    }
    [self setNeedsLayout];
}

-(void)setInsets:(UIEdgeInsets)insets{
    _insets = insets;
    [self setNeedsLayout];
}

-(void)hideAllImages{
    for (CALayer* v in self.layer.sublayers) {
        v.hidden = YES;
    }
}

-(void)setImage:(UIImage *)image forLayerAtIndex:(NSUInteger)index{
    ThumbnailImageLayer* layer = _imageLayers[index];
    if (image) {
        layer.imageLayer.contents = (id)image.CGImage;
    }else{
        layer.imageLayer.contents = nil;
    }
    layer.hidden = !image;
}

-(void)layoutSubviews{
    CGFloat imageViewHeight = self.rowHeight - self.insets.top - self.insets.bottom;
    CGFloat gap = (self.insets.left + self.insets.right)/4;
    CGFloat imageViewWidth = self.bounds.size.width - self.insets.left - self.insets.right;
    imageViewWidth -= (self.numberOfImages -1) * gap;
    imageViewWidth /= self.numberOfImages;
    
    CGFloat x = self.insets.left;
    CGFloat y = self.insets.top;
    for (CALayer* layer in _imageLayers) {
        layer.frame = CGRectMake(x, y, imageViewWidth, imageViewHeight);
        x += (imageViewWidth + gap);
    }
}

-(ThumbnailImageLayer *)layerForIndex:(NSUInteger)index{
    return _imageLayers[index];
}
@end
