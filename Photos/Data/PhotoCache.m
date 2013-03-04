//
//  PhotoCache.m
//  Photos
//
//  Created by Sood, Abhishek on 3/3/13.
//
//

#import "PhotoCache.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "FlikrPhoto.h"

static NSString const *kURLGetList = @"http://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=ccb1a44ee5bbf5b72ab0aff810fbeb43&per_page=%d&format=json&nojsoncallback=1&page=%d";


@implementation PhotoCache

-(id)init{
    self = [super init];
    if (self) {
        _currentPageNumber = 0;
        _totalPages = -1;
        _numberOfImagesPerPage = 100;
        _photoIndices = [[NSMutableDictionary alloc] init];
        _photos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_photos release];
    [_photoIndices release];
    [super dealloc];
}

-(BOOL)hasMorePagesToLoad{
    return _totalPages <=0 || _currentPageNumber < _totalPages;
}

-(void)loadNextPageWithSuccessBlock:(NextPageLoadSuccess)successBlock andErrorBlock:(NextPageLoadError)errorBlock{
    if (![self hasMorePagesToLoad]) {
        if (successBlock) {
            successBlock();
        }
        return;
    }
    
    _currentPageNumber++;
    
    NSString* url = [NSString stringWithFormat:[[kURLGetList copy] autorelease],_numberOfImagesPerPage,_currentPageNumber];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    __block PhotoCache* bself = self;
    [request setCompletionBlock:^{
        NSString *str = [request responseString];
        NSDictionary *entries = [[str objectFromJSONString] valueForKey:@"photos"];
        _totalPages = [[entries valueForKey:@"pages"] intValue];
        _totalImages = [[entries valueForKey:@"total"] intValue];
        NSLog(@"Total images: %d",_totalImages);
        NSArray *items = [entries valueForKey:@"photo"];
        
        for (NSDictionary *item in items) {
            //http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
            NSString *farm = [item valueForKey:@"farm"];
            NSString *server = [item valueForKey:@"server"];
            NSString *secret = [item valueForKey:@"secret"];
            NSString *imgId = [item valueForKey:@"id"];
            NSString *title = [item valueForKey:@"title"];
            
            NSString *thumbnailURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", farm, server, imgId, secret, @"t"];
            NSString *imageURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", farm, server, imgId, secret, @"b"];
            
            if (![bself->_photoIndices objectForKey:imgId]) {
                FlikrPhoto* photo = [[FlikrPhoto alloc] initWithID:imgId
                                                             title:title
                                                      thumbnailURL:thumbnailURL
                                                       andImageURL:imageURL];
                [bself->_photos addObject:photo];
                [bself->_photoIndices setObject:[NSNumber numberWithInt:(_photos.count -1)]
                                  forKey:imgId];
                [photo release];
            }
        }
        if (successBlock) {
            successBlock();
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"Error %@", [[request error] description]);
        if (errorBlock) {
            errorBlock([request error]);
        }
    }];
    
    [request startAsynchronous];
}

-(FlikrPhoto *)photoForImageId:(NSString *)photoId{
    NSNumber* index = [_photoIndices objectForKey:photoId];
    if (index) {
        return [_photos objectAtIndex:[index intValue]];
    }
    return nil;
}

-(FlikrPhoto *)photoForIndex:(NSUInteger)idx{
    return _photos[idx];
}

-(NSUInteger)photoCount{
    return _photos.count;
}

@end
