//
//  Movie.h
//  movieDB_objectiveC
//
//  Created by Adriano Ramos on 19/03/20.
//  Copyright © 2020 Adriano Ramos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property NSString *movieTitle;
@property NSNumber *rating;
@property NSString *genres;
@property NSString *overview;
@property NSString *imageUrl;
@property NSNumber *movieId;

@end
