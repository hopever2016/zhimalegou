//
//  UserIDCardViewController.m
//  BoyacxClient
//
//  Created by clove on 7/12/16.
//  Copyright © 2016 com.boyacx. All rights reserved.
//

#import "FQGFormFillTableViewController.h"
#import "FQGTableViewCell.h"
#import "FQGPickerCell.h"
#import "FQGCellModel.h"

@interface FQGFormFillTableViewController ()

@end

@implementation FQGFormFillTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerClass:[FQGTableViewCell class] forCellReuseIdentifier:@"FQGTableViewCell"];
    [self.tableView registerClass:[FQGPickerCell class] forCellReuseIdentifier:@"FQGPickerCell"];
    
    [self configureModels];
    
//    [self addFooterButton:@"下一步"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureModels
{
    NSMutableArray *sectionArray = [NSMutableArray array];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[FQGCellModel modelWithTitle:@"真实姓名" placeholder:@"请输入姓名" type:FQGCellTypeTextInput key:nil value:nil]];
    [array addObject:[FQGCellModel modelWithTitle:@"性别" placeholder:@"男/女" type:FQGCellTypeTextInput key:nil value:nil]];
    [array addObject:[FQGCellModel modelWithTitle:@"民族" placeholder:@"民族" type:FQGCellTypeTextInput key:nil value:nil]];
    [array addObject:[FQGCellModel modelWithTitle:@"出生日期" placeholder:@"请选择出生日期" type:FQGCellTypePicker key:nil value:nil]];
    [sectionArray addObject:array];
    
    array = [NSMutableArray array];
    [array addObject:[FQGCellModel modelWithTitle:@"户籍所在地" placeholder:@"请输入户籍所在地" type:FQGCellTypeTextInput key:nil value:nil]];
    [array addObject:[FQGCellModel modelWithTitle:@"身份证号码" placeholder:@"请输入身份证号码" type:FQGCellTypeTextInput key:nil value:nil]];
    [array addObject:[FQGCellModel modelWithTitle:@"有效期至" placeholder:@"请选择有效期" type:FQGCellTypePicker key:nil value:nil]];
    [sectionArray addObject:array];
    
    array = [NSMutableArray array];
    [array addObject:[FQGCellModel modelWithTitle:@"职业类型" placeholder:@"请选择职业" type:FQGCellTypePicker key:nil value:nil]];
    [array addObject:[FQGCellModel modelWithTitle:@"婚姻状况" placeholder:@"请选择婚姻状况" type:FQGCellTypePicker key:nil value:nil]];
    [sectionArray addObject:array];
    
    _modelArray = sectionArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger num = _modelArray[section].count;
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FQGCellModel *modle = _modelArray[indexPath.section][indexPath.row];
    
    FQGTableViewCell *cell = nil;
    
    FQGCellType type = modle.type;
    switch (type) {
        case FQGCellTypeTextInput:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FQGTableViewCell" forIndexPath:indexPath];
            break;
        }
        case FQGCellTypePicker:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FQGPickerCell" forIndexPath:indexPath];
            break;
        }
        default:
            break;
    }
    
    
    cell.delegate = self;
    
    [cell updateWithModel:modle];
    
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    switch (indexPath.row) {
        case 0:
        {
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    [cell setSelected:NO animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - FQGTableViewCellDelegate

- (void)cellValueChanged:(FQGTableViewCell *)cell
{
    NSLog(@"%s  %@", __FUNCTION__, cell.model.value);
}

- (void)cellDidBeginEditing:(FQGTableViewCell *)cell
{
    NSArray *array = @[@"1", @"2", @"3"];
    FQGPickerView *view = [[FQGPickerView alloc] initWithKey:nil title:@"title" value:nil options:array];
    [self showPickerView:view];
}

@end
