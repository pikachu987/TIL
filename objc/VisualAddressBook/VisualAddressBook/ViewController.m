//
//  ViewController.m
//  VisualAddressBook
//
//  Created by guanho on 2017. 1. 17..
//  Copyright © 2017년 guanho. All rights reserved.
//

#import "ViewController.h"
#import "Book.h"
#import "BookManager.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *genreTextField;
@property (strong, nonatomic) IBOutlet UITextField *authorTextField;
@property (strong, nonatomic) IBOutlet UITextView *resultTextView;
@property (strong, nonatomic) IBOutlet UILabel *bookCountLbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Book *book1 = [[Book alloc]init];
    book1.name = @"가가가";
    book1.genre = @"느와르";
    book1.author = @"몰라";
    
    Book *book2 = [[Book alloc]init];
    book2.name = @"나나나";
    book2.genre = @"액션";
    book2.author = @"몰라111";
    
    Book *book3 = [[Book alloc]init];
    book3.name = @"다다다";
    book3.genre = @"스릴러";
    book3.author = @"몰라333";
    
    
    myBook = [[BookManager alloc]init];
    [myBook addBook:book1];
    [myBook addBook:book2];
    [myBook addBook:book3];
    
    [self bookCount];
}

- (void)bookCount{
    NSString *str = [[NSString alloc] initWithFormat:@"전체 책 갯수 %li", [myBook countBook]];
    self.bookCountLbl.text = str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showAllBookAction:(id)sender {
    self.resultTextView.text = [myBook showAllBook];
}

- (IBAction)addBookAction:(id)sender{
    Book *book = [[Book alloc]init];
    book.name = self.nameTextField.text;
    book.genre = self.genreTextField.text;
    book.author = self.authorTextField.text;
    NSLog(@"%@", book.name);
    [myBook addBook:book];
    self.resultTextView.text = @"책이 추가됬네요.";
    [self bookCount];
}

- (IBAction)searchBookAction:(id)sender {
    NSString *strTemp = [myBook findBook:self.nameTextField.text];
    if(strTemp != nil){
        self.resultTextView.text = strTemp;
    }else{
        self.resultTextView.text = @"찾으시는 책이 없네요.";
    }
}
- (IBAction)removeBookAction:(id)sender {
    NSString *strTemp = [myBook removeBook:self.nameTextField.text];
    if(strTemp != nil){
        self.resultTextView.text = strTemp;
        [self bookCount];
    }else{
        self.resultTextView.text = @"삭제하려는 책이 없네요.";
    }
}

@end
