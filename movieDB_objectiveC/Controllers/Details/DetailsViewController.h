//
//  DetailsViewController.h
//  movieDB_objectiveC
//
//  Created by Adriano Ramos on 19/03/20.
//  Copyright © 2020 Adriano Ramos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface DetailsViewController : UIViewController

@property Movie *movie;

@property (weak, nonatomic) IBOutlet UIImageView *movieBannerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewTV;

- (void) hideLargeTitle;

@end

