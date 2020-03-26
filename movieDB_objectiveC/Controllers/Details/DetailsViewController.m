//
//  DetailsViewController.m
//  movieDB_objectiveC
//
//  Created by Adriano Ramos on 19/03/20.
//  Copyright © 2020 Adriano Ramos. All rights reserved.
//

#import "DetailsViewController.h"
#import "Movie.h"
#import "Network.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNetwork];
    
//    _movieBannerImage.layer.cornerRadius = 10;
//    _movieBannerImage.image = _movie.movieBanner;
//    _titleLabel.text = _movie.movieTitle;
//    _genresLabel.text = _movie.genres;
//    _ratingLabel.text = [_movie.rating stringValue];
//    _overviewTV.text = _movie.overview;
}

- (void) configNetwork {
    Network *networking = Network.new;
    
        [networking getMovieDetails:_movieId completion:^(Movie * movie) {
        self.movie = movie;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.movieBannerImage.layer.cornerRadius = 10;
            self.movieBannerImage.image = self.movie.movieBanner;
            self.titleLabel.text = self.movie.movieTitle;
            self.genresLabel.text = self.movie.genres;
            self.ratingLabel.text = [NSString stringWithFormat:@"%.01f", self.movie.rating.doubleValue];
            self.overviewTV.text = self.movie.overview;
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self hideLargeTitle];
}

- (void) hideLargeTitle {
    self.navigationController.navigationBar.prefersLargeTitles = NO;
}

@end
