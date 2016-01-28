//
//  PeekViewController.m
//  3DTouchTest
//
//  Created by hzzhanyawei on 16/1/27.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "PeekViewController.h"

@interface PeekViewController ()
@property (strong, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation PeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textLabel.text = self.data;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onDismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)previewActionItems{
    UIPreviewAction *actionOne = [UIPreviewAction actionWithTitle:@"Action 1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Preview Action 1 triggered");
    }];
    UIPreviewAction *actionTwo = [UIPreviewAction actionWithTitle:@"Action 2" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Preview Action 2 triggered");
    }];
    
    NSArray *actions = @[actionOne, actionTwo];
//    return actions;
    
    UIPreviewActionGroup *groupOne = [UIPreviewActionGroup actionGroupWithTitle:@"Group One" style:UIPreviewActionStyleDefault actions:actions];
    NSArray *groups = @[groupOne];
    return groups;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
