//
//  Tab4CollectionViewController.m
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/13.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "Tab4CollectionViewController.h"
#import "CellViewCollectionViewCell.h"
#import "FlowLayout.h"

@interface Tab4CollectionViewController ()

@end

@implementation Tab4CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[CellViewCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerNib:@"CellViewCollectionViewCell" forCellWithReuseIdentifier:reuseIdentifier];
   
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    FlowLayout *layout = [[FlowLayout alloc] init];
    [self.collectionView setCollectionViewLayout: layout];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//
//    return 1;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 10;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CellViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  
    cell.imageView.image = [UIImage imageNamed:@"tab1"];
    cell.textLabel.text = [NSString stringWithFormat:@"条目%d", (int)indexPath.row ];

//    cell.layer.masksToBounds = YES;
//    UIImageView *iv = (UIImageView *)[cell viewWithTag:1];
//    iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"tab%d",(int)(indexPath.row%4 + 1)]];
//    UILabel *label = (UILabel *)[cell viewWithTag:2];
//    label.text = [NSString stringWithFormat:@"条目%d", (int)indexPath.row ];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
