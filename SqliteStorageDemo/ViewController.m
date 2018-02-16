//
//  ViewController.m
//  SqliteStorageDemo
//
//  Created by Zsombor on 2018. 02. 06..
//  Copyright © 2018. Zsombor. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentsTextView;
@property (weak, nonatomic) IBOutlet UITextField *foodNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *contentsLabel;
@property (weak, nonatomic) IBOutlet UITextField *foodVerdictTextField;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)foodNameEditEnd:(id)sender {
    [_foodNameTextField endEditing:YES];
}
- (IBAction)foodVerdictEditEnded:(id)sender {
    [_foodVerdictTextField endEditing:YES];
}

- (void)updateContentsLabel{
    NSString* listQuery = @"select * from food";
    NSArray*  paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* dir   = [paths objectAtIndex:0];
    NSString* dbPath = [dir stringByAppendingPathComponent:@"food.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        NSLog(@"DB opened.");
    }
    FMResultSet *rs = [db executeQuery:listQuery];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    while ([rs next]) {
        //retrieve values for each record
        NSLog(@"%@ - %@ - \n",[rs stringForColumn:@"name"],[rs stringForColumn:@"verdict"]);
        [data addObject:[[NSString alloc] initWithFormat:@"%@ - %@ \n",[rs stringForColumn:@"name"],[rs stringForColumn:@"verdict"]]];
    }
    _contentsTextView.text = [data componentsJoinedByString:@"\n"];
    [db close];
}

- (IBAction)insertButtonPressed:(id)sender {
    NSString *name =[_foodNameTextField text];
    NSString *verdict =[_foodVerdictTextField text];
    
    if (![name isEqualToString:@""]) {
        NSString* insertQuery = [NSString stringWithFormat:@"insert into food values('%@','%@')",name,verdict];
        NSString* createQuery = @"create table food (name text, verdict text)";
        NSArray*  paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
        NSString* dir   = [paths objectAtIndex:0];
        NSString* dbPath = [dir stringByAppendingPathComponent:@"food.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if ([db open]){
            NSLog(@"DB opened.");
        }
        [db executeUpdate:createQuery];
        [db executeUpdate:insertQuery];
        [db close];
        
        [[[UIAlertView alloc] initWithTitle:@"Result" message:@"Data saved to SQLite."
                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self updateContentsLabel];

    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter food name to proceed."
                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    NSString* deleteQuery = @"delete from food";
    NSArray*  paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* dir   = [paths objectAtIndex:0];
    NSString* dbPath = [dir stringByAppendingPathComponent:@"food.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        NSLog(@"DB opened.");
    }
    [db executeUpdate:deleteQuery];
    [db close];
    
    [[[UIAlertView alloc] initWithTitle:@"Result" message:@"Data deleted from SQLite."
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self updateContentsLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)foodNameEditEnded:(id)sender {
}
@end
