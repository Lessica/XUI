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
//@property (nonatomic, strong) UIBarButtonItem *addItem;
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
    
    if (self.isAddMode) {
        self.title = NSLocalizedStringFromTableInBundle(@"Add Item", nil, FRAMEWORK_BUNDLE, nil);
    } else {
        self.title = NSLocalizedStringFromTableInBundle(@"Edit Item", nil, FRAMEWORK_BUNDLE, nil);
    }
    self.navigationItem.rightBarButtonItem = self.saveItem;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textFieldCell.cellTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIView Getters

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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

//- (UIBarButtonItem *)addItem {
//    if (!_addItem) {
//        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addOrSaveItemTapped:)];
//        _addItem = addItem;
//    }
//    return _addItem;
//}

- (UIBarButtonItem *)saveItem {
    if (!_saveItem) {
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addOrSaveItemTapped:)];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self addOrSaveItemTapped:nil];
    return NO;
}

@end
