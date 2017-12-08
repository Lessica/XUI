//
//  XUIEditableListItemViewController.m
//  XUI
//
//  Created by Zheng Wu on 16/10/2017.
//

#import "XUIEditableListItemViewController.h"

@interface XUIEditableListItemViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) XUITextFieldCell *textFieldCell;
@property (nonatomic, strong) UIBarButtonItem *saveItem;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XUIEditableListItemViewController

- (instancetype)initWithContent:(NSString *)content {
    if (self = [super init]) {
        _addMode = (content == nil);
        _content = content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveItem.enabled = (self.content.length > 0);
    
    if (self.isAddMode) {
        self.title = NSLocalizedStringFromTableInBundle(@"Add Item", nil, FRAMEWORK_BUNDLE, nil);
    } else {
        self.title = NSLocalizedStringFromTableInBundle(@"Edit Item", nil, FRAMEWORK_BUNDLE, nil);
    }
    self.navigationItem.rightBarButtonItem = self.saveItem;
    
    XUITheme *theme = self.theme;
    self.tableView.backgroundColor = theme.backgroundColor;
    self.tableView.separatorColor = theme.separatorColor;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textFieldCell.cellTextField becomeFirstResponder];
}

#pragma mark - UIView Getters

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.theme.tableViewStyle];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.editing = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_9) {
            tableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
        XUI_END_IGNORE_PARTIAL
        _tableView = tableView;
    }
    return _tableView;
}

- (UIBarButtonItem *)saveItem {
    if (!_saveItem) {
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addOrSaveItemTapped:)];
        saveItem.enabled = NO;
        _saveItem = saveItem;
    }
    return _saveItem;
}

- (XUITextFieldCell *)textFieldCell {
    if (!_textFieldCell) {
        XUITextFieldCell *cell = (XUITextFieldCell *)[[[XUITextFieldCell cellNib] instantiateWithOwner:self options:nil] lastObject];
        [cell setTheme:self.theme];
        cell.cellTextField.returnKeyType = UIReturnKeyDone;
        cell.cellTextField.delegate = self;
        cell.xui_value = self.content;
        cell.xui_placeholder = @"Value";
        _textFieldCell = cell;
    }
    return _textFieldCell;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.textFieldCell;
        }
    }
    return [XUIBaseCell new];
}

- (void)addOrSaveItemTapped:(UIBarButtonItem *)sender {
    NSString *newContent = self.textFieldCell.cellTextField.text;
    _content = newContent;
    if ([_delegate respondsToSelector:@selector(editableListItemViewController:contentUpdated:)]) {
        [_delegate editableListItemViewController:self contentUpdated:newContent];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *content = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.saveItem.enabled = (content.length > 0);
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.saveItem.enabled = NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self addOrSaveItemTapped:nil];
    return NO;
}

@end
