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
    [self setupCustomNavBar];
}

- (void) setupCustomNavBar {
    self.navigationItem.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
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

//- (NSArray *)bubbleSort:(NSMutableArray *)sortedArray {
//   long count = sortedArray.count;
//   bool swapped = YES;
//   while (swapped)
//   {
//   swapped = NO;
//
//      for (int i = 1; i < count; i++)
//      {
//          int x = [sortedArray[i-1] intValue];
//          int y = [sortedArray[i] intValue];
//
//          if (x > y)
//          {
//               [sortedArray exchangeObjectAtIndex:(i-1) withObjectAtIndex:i];
//               swapped = YES;
//          }
//      }
//   }
//   return sortedArray;
//}

- (NSArray *)arrayMerge:(NSArray *)arrayLeft :(NSArray *)arrayRight
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];

    int i = 0, j = 0;

    while (i < arrayLeft.count && j < arrayRight.count)
        [resultArray addObject:([arrayLeft[i] intValue] < [arrayRight[j] intValue]) ? arrayLeft[i++] : arrayRight[j++]];

    while (i < arrayLeft.count)
        [resultArray addObject:arrayLeft[i++]];

    while (j < arrayRight.count)
        [resultArray addObject:arrayRight[j++]];

    return resultArray;
}

- (NSArray *)arrayMergeSort:(NSArray *)targetArray
{
    if (targetArray.count < 2)
        return targetArray;

    long midIndex = targetArray.count/2;

    NSArray *arrayLeft = [targetArray subarrayWithRange:NSMakeRange(0, midIndex)];

    NSArray *arrayRight= [targetArray subarrayWithRange:NSMakeRange(midIndex, targetArray.count - midIndex)];

    return [self arrayMerge: [self arrayMergeSort:arrayLeft] : [self arrayMergeSort:arrayRight]];
}




- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *identifier = @"movieCell";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //POPULAR
    if(indexPath.section == 0) {
        cell.title.text = _popular[indexPath.row].movieTitle;
        cell.overview.text = _popular[indexPath.row].overview;
        cell.image.layer.cornerRadius = 10;
        NSString *ratingToLabel = [_popular[indexPath.row].rating stringValue];
        cell.rating.text = ratingToLabel;
        
        
        if (_popular[indexPath.row].movieBanner == nil) {
            [self getBanner:_popular[indexPath.row].imageUrl completion:^(UIImage * image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_popular[indexPath.row].movieBanner = image;
                });
            }];
        }
    } else if (indexPath.section == 1) {
        NSMutableArray * nowPlayingSorted = [[NSMutableArray alloc] initWithObjects:_nowPlaying, nil];
        [self arrayMergeSort:nowPlayingSorted];
        
        cell.title.text = _nowPlaying[indexPath.row].movieTitle;
        cell.overview.text = _nowPlaying[indexPath.row].overview;
        cell.image.layer.cornerRadius = 10;
        NSString *ratingToLabel = [_nowPlaying[indexPath.row].rating stringValue];
        cell.rating.text = ratingToLabel;
        
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
