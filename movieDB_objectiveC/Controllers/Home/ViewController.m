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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
    [self configNetwork];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupCustomNavBar];
}

- (void) configTableView {
    _moviesTableView.delegate = self;
    _moviesTableView.dataSource = self;
}

// MARK: - Custom nav bar to hide back button title and color
- (void) setupCustomNavBar {
    self.navigationItem.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self setupSearchBar];
}

- (void) setupSearchBar {
    UISearchController *searchBarController = UISearchController.new;
    searchBarController.obscuresBackgroundDuringPresentation = true;
    self.navigationItem.searchController = searchBarController;
    self.navigationItem.hidesSearchBarWhenScrolling = false;
}

// MARK: - Perform segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(Movie *)sender {
    if([[segue identifier] isEqualToString:@"goToDetails"]) {
        DetailsViewController *vc = [segue destinationViewController];
        vc.movie = sender;
    }
}

// MARK: - Requests and networking layer setup
- (void) configNetwork {
    _networking = [[Network alloc] init];
    
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

- (void)getBanner:(NSString *)imageUrl completion:(void (^)(UIImage *))callback {
    [_networking getMovieBanner:imageUrl completion:^(NSData * data) {
        UIImage *img = [[UIImage alloc] initWithData: data];
        callback(img);
    }];
}

// - MARK: - Table View delegate and data source methods
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *identifier = @"movieCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //POPULAR
    if(indexPath.section == 0) {
        cell.title.text = _popular[indexPath.row].movieTitle;
        cell.overview.text = _popular[indexPath.row].overview;
        cell.image.layer.cornerRadius = 10;
        NSString *ratingToLabel = [_popular[indexPath.row].rating stringValue];
        cell.rating.text = [NSString stringWithFormat:@"%.01f", ratingToLabel.doubleValue];
        
        
        if (_popular[indexPath.row].movieBanner == nil) {
            [self getBanner:_popular[indexPath.row].imageUrl completion:^(UIImage * image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_popular[indexPath.row].movieBanner = image;
                });
            }];
        }
    } else if (indexPath.section == 1) {
        cell.title.text = _nowPlaying[indexPath.row].movieTitle;
        cell.overview.text = _nowPlaying[indexPath.row].overview;
        cell.image.layer.cornerRadius = 10;
        NSString *ratingToLabel = [_nowPlaying[indexPath.row].rating stringValue];
        cell.rating.text = [NSString stringWithFormat:@"%.01f", ratingToLabel.doubleValue];
        
        if (_nowPlaying[indexPath.row].movieBanner == nil) {
            [self getBanner:_nowPlaying[indexPath.row].imageUrl  completion:^(UIImage * image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_nowPlaying[indexPath.row].movieBanner = image;
                });
            }];
        } else {
            cell.image.image = _nowPlaying[indexPath.row].movieBanner;
        }
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSNumber *movieId = _popular[indexPath.row].movieId;
        [_networking getMovieDetails:movieId completion:^(Movie * movie) {
            dispatch_async(dispatch_get_main_queue(), ^{
                movie.movieBanner = self->_popular[indexPath.row].movieBanner;
                [self performSegueWithIdentifier:@"goToDetails" sender:movie];
            });
        }];
    } else {
        NSNumber *movieId = _nowPlaying[indexPath.row].movieId;
        [_networking getMovieDetails:movieId completion:^(Movie * movie) {
            dispatch_async(dispatch_get_main_queue(), ^{
                movie.movieBanner = self->_nowPlaying[indexPath.row].movieBanner;
                [self performSegueWithIdentifier:@"goToDetails" sender:movie];
            });
        }];
    }
}

@end
