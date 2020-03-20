//
//  ViewController.m
//  movieDB_objectiveC
//
//  Created by Adriano Ramos on 17/03/20.
//  Copyright © 2020 Adriano Ramos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "Movie.h"
#import "Network.h"
#import "TableViewCell.h"
#import "DetailsViewController.h"
#import <QuartzCore/QuartzCore.h>



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _networking = [[Network alloc] init];
    _moviesTableView.delegate = self;
    _moviesTableView.dataSource = self;
    
    [_networking getMovies:Popular completion:^(NSMutableArray * movies) {
        self->_popular = movies;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_moviesTableView reloadData];
        });
    }];
    
    [_networking getMovies:NowPlaying completion:^(NSMutableArray * movies) {
        
        self->_nowPlaying = movies;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_moviesTableView reloadData];
        });
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(Movie *)sender {
    if([[segue identifier] isEqualToString:@"goToDetails"]) {
        DetailsViewController *vc = [segue destinationViewController];
        vc.movie = sender;
    }
}

- (void)getBanner:(NSString *)imageUrl completion:(void (^)(UIImage *))callback {
    [_networking getMovieBanner:imageUrl completion:^(NSData * data) {
        UIImage *img = [[UIImage alloc] initWithData: data];
        callback(img);
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *identifier = @"movieCell";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //POPULAR
    if(indexPath.section == 0) {
        cell.title.text = _popular[indexPath.row].movieTitle;
        cell.overview.text = _popular[indexPath.row].overview;
        cell.image.layer.cornerRadius = 10;
        NSString *ratingNote = [_popular[indexPath.row].rating stringValue];
        cell.rating.text = ratingNote;
        
        
        if (_popular[indexPath.row].movieBanner == nil) {
            [self getBanner:_popular[indexPath.row].imageUrl completion:^(UIImage * image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_popular[indexPath.row].movieBanner = image;
                });
            }];
        }
    } else if (indexPath.section == 1) {
        NSMutableArray * nowPlayingSorted = [[NSMutableArray alloc] initWithObjects:_nowPlaying, nil];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return _popular.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Popular Movies";
    } else {
        return @"Now Playing";
    }
}

@end
