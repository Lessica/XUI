//
//  XUIEditableListItemViewController.m
//  XUI
//
//  Created by Zheng Wu on 16/10/2017.
//

#import "XUIEditableListItemViewController.h"
#import "XUIPrivate.h"

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
    
    if (self.isAddMode) {
        self.title = [XUIStrings localizedStringForString:@"Add Item"];
    } else {
        self.title = [XUIStrings localizedStringForString:@"Edit Item"];
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
        XUITextFieldCell *cell = [[XUITextFieldCell alloc] init];
        [cell setFactory:self.cellFactory];
        [cell setInternalTheme:self.theme]; // override its theme
        [cell.cellTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.cellTextField.returnKeyType = UIReturnKeyDone;
        cell.cellTextField.enablesReturnKeyAutomatically = YES;
        cell.cellTextField.delegate = self;
        cell.xui_placeholder = [XUIStrings localizedStringForString:@"Value"];
        cell.xui_value = self.content;
        _textFieldCell = cell;
    }
    return _textFieldCell;
}

#pragma mark - Setters

- (void)setValidationRegex:(NSRegularExpression *)validationRegex {
    _validationRegex = validationRegex;
    self.textFieldCell.validationRegex = validationRegex;
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont systemFontOfSize:14.0];
    header.textLabel.textColor = self.theme.sectionHeaderTextColor;
    header.backgroundColor = self.theme.sectionHeaderBackgroundColor;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.textLabel.font = [UIFont systemFontOfSize:12.0];
    footer.textLabel.textColor = self.theme.sectionFooterTextColor;
    footer.backgroundColor = self.theme.sectionFooterBackgroundColor;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.textFieldCell;
        }
    }
    return [XUIBaseCell new];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (0 == section) {
        return self.footerText;
    }
    return nil;
}

- (void)addOrSaveItemTapped:(UIBarButtonItem *)sender {
    NSString *newContent = self.textFieldCell.cellTextField.text;
    _content = newContent;
    if ([_delegate respondsToSelector:@selector(editableListItemViewController:contentUpdated:)]) {
        [_delegate editableListItemViewController:self contentUpdated:newContent];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldValueChanged:(UITextField *)textField {
    NSString *content = textField.text;
    BOOL validated = YES;
    if (self.validationRegex)
    {
        NSTextCheckingResult *result
        = [self.validationRegex firstMatchInString:content options:0 range:NSMakeRange(0, content.length)];
        if (!result)
        { // validation failed
            validated = NO;
        }
    }
    self.saveItem.enabled = (content.length > 0) && (![content isEqualToString:self.content]) && validated;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.saveItem.enabled = NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.saveItem.enabled) {
        [self addOrSaveItemTapped:self.saveItem];
    }
    return NO;
}

@end
