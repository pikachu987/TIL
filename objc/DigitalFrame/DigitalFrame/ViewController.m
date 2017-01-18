//
//  ViewController.m
//  DigitalFrame
//
//  Created by guanho on 2017. 1. 17..
//  Copyright © 2017년 guanho. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *speedLbl;
@property (strong, nonatomic) IBOutlet UIButton *toggle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *cuteImages = [[NSArray alloc]initWithObjects:
                           [UIImage imageNamed:@"1.jpg"],
                           [UIImage imageNamed:@"2.jpg"],
                           [UIImage imageNamed:@"3.jpg"],
                           [UIImage imageNamed:@"4.jpg"],
                           [UIImage imageNamed:@"5.jpg"],
                           [UIImage imageNamed:@"6.jpg"],
                           [UIImage imageNamed:@"7.jpg"],
                           [UIImage imageNamed:@"8.jpg"],
                           [UIImage imageNamed:@"9.jpg"],
                           [UIImage imageNamed:@"10.jpg"],
                           [UIImage imageNamed:@"11.jpg"],
                           [UIImage imageNamed:@"12.jpg"],
                           [UIImage imageNamed:@"13.jpg"],
                           [UIImage imageNamed:@"14.jpg"],
                           [UIImage imageNamed:@"15.jpg"],
                           nil];
    self.imgView.animationImages = cuteImages;
    self.imgView.animationDuration = 7.5;
}
- (IBAction)toggleAction:(id)sender {
    if(self.imgView.isAnimating){
        [self.imgView stopAnimating];
        [self.toggle setTitle:@"Start" forState:UIControlStateNormal];
    }else{
        self.imgView.animationDuration = self.slider.value;
        [self.imgView startAnimating];
        [self.toggle setTitle:@"Stop" forState:UIControlStateNormal];
    }
}
- (IBAction)sliderValueAction:(id)sender {
    self.speedLbl.text = [[NSString alloc]initWithFormat:@"%.2f", self.slider.value];
    [self.toggle setTitle:@"Stop" forState:UIControlStateNormal];
    self.imgView.animationDuration = self.slider.value;
    [self.imgView startAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
