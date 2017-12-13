# XXTouch UI (XUI) 界面库使用手册

标签（空格分隔）:  XXTouch XXTouchApp


----------


在阅读本文前, 您需要对 Lua 语法有所了解, 并能理解 数值/布尔型/字符串/数组/字典 等基本数据类型.

 - 适用于 **v1\.2\-1** 及以上平台版本
 - 支持 iPhone/iPad 横竖屏, 支持 iOS 7 及以上系统版本
 - XUI 不与原有的对话框 \( dialog \) 和 WebView UI 冲突
 - XUI 为 [脚本应用包 \( XPP \)](https://www.zybuluo.com/xxtouch/note/738353) 提供界面扩展


----------


## 目录

[TOC]


----------


## 前言

XUI 用于在 XXTouch 上提供配置界面, 采用 iOS 系统原生组件. 本手册提供了 XUI 界面布局的规范. XUI 是 [脚本应用包 \( XPP \)](https://www.zybuluo.com/xxtouch/note/738353) 的一部分, 用来为脚本包创建配置, 不能独立使用. 

如需使用 XUI, 您需要创建指定格式的 xui / json / plist 文件, 在脚本包中激活. 保存的配置项, 可以通过 plist 库进行读取. 


----------


## 综合示例

![A-Script-Bundle.xpa-1001kB][1]

![1512233554.png-1.9kB][2]

脚本开发者可以下载示例包, 在 XXTouch 中安装并运行. 

![IMG_0716.JPG-152.2kB][3]


----------


## 创建

xui 是一种特定格式的 lua 文件, 使用这种格式创建 XUI 界面, 需要使 lua 执行后返回一个包含各组件及属性的表. 

您也可以使用 json 或 plist 格式, 来创建 XUI 界面. 


----------


### 根

XUI 配置的根（顶层）为字典. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|title|字符串|导航栏标题|可选, 可本地化|
|header|字符串|主标题|可选, 可本地化|
|subheader|字符串|副标题|可选, 可本地化|
|items|包含字典的数组|组件列表|\-|
|theme|字典|界面主题样式|可选|

**items** 是组件列表数组, 所有的 *组件字典* 按顺序存放在该数组中, 即可在界面上显示. 关于 *组件字典* 的说明, 参见本文后续内容. 

``` lua
return {
		subheader = "Elegant App UI provided by XXTouchApp.";
		header = "Example";
		title = "Demo";
		theme = {
				tintColor = "#FFFFFF";
		};
		items = {};
};
```


----------


### 主题样式

在根层级设置 **theme** 属性, 能为界面配置统一的样式.

**界面**

|   键   |   类型   |   描述   |
|--------|----------|----------|
|style|风格|界面风格|
|tintColor|颜色|前景颜色|
|backgroundColor|颜色|背景颜色|

**组件**

|   键   |   类型   |   描述   |
|--------|----------|----------|
|cellBackgroundColor|颜色|组件背景颜色|
|disclosureIndicatorColor|颜色|组件指示器颜色|
|selectedColor|颜色|选中颜色|
|highlightedColor|颜色|高亮颜色|
|labelColor|颜色|标题文字颜色|
|valueColor|颜色|值文字颜色|

**导航栏**

|   键   |   类型   |   描述   |
|--------|----------|----------|
|navigationBarColor|颜色|导航栏背景颜色|
|navigationTitleColor|颜色|导航栏标题颜色|

**状态**

|   键   |   类型   |   描述   |
|--------|----------|----------|
|dangerColor|颜色|错误颜色|
|warningColor|颜色|警告颜色|
|successColor|颜色|成功颜色|

在组件层级设置 **theme** 属性, 每个组件单独设置样式, 参见每个组件的 *主题键* 表格. 推荐配色方案: http://www.bootcss.com/p/flat-ui/

| style | 描述 |
|--------|------|
|Grouped|传统风格 (默认)|
|Plain|平铺风格|

类型 **颜色**, 即十六进制 RGB (RGBA) 字符串形式, 如 *#FF0000* 代表红色. 

![CFE17DA4-C299-4533-A0E9-E1E2F9734C8D.png-32.9kB][4]


----------


### 通用属性

各组件均可使用如下通用属性, 为组件添加标题, 图标, 指定配置保存位置等. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|cell|字符串|组件类型|\-|
|label|字符串|显示标签|可选, 可本地化|
|defaults|字符串|配置标识符|\-|
|key|字符串|配置键名|defaults != nil|
|default|字符串|配置默认值|\-|
|value|基本类型|配置值|可选|
|icon|字符串|图标文件名|可选|
|readonly|布尔型|组件是否只读|可选|
|height|数值|组件的高度|可选|

**cell** 为组件类型, 不同类型代表不同组件. 

**label** 为组件标题, 显示在组件左侧. 

**default** 为组件默认值, 若 **value** 为 nil, 则使用 **default** 的值填充 **value**. 

**icon** 为图标, 显示在 **label** 左侧. 若设置为 "res/16.png", 建议同时准备 "res/16@2x.png" 和 "res/16@3x.png", 实际尺寸须分别为原来的 2 倍和 3 倍. 

**readonly** 如果为 *true*, 则组件的值只读, 不能被修改和置空. 也不能链接到子界面. 


----------


### 读取配置

配置完成后, 在 **defaults** 指定的保存位置, 读取 plist 中键 **key** == "switch1" 的值, 即为开关 "switch1" 的状态. 

``` lua
function read_xui_conf(bid)
	local plist = require("plist")
	return plist.read("/var/mobile/Media/1ferver/uicfg/"..bid..".plist") or {}
end
local conf = read_xui_conf('com.yourcompany.A-Script-Bundle')
sys.alert(json.encode(conf))
local enabled = conf.enabled
```


----------


### Group 分组

此组件在界面上显示一个分组区域 Section, 包含到下一个相同组件类型之间的所有组件. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|footerText|字符串|在当前组之后添加一行小字|可选, 可本地化|

*此组件不支持 **label/icon/height***

``` lua
{
		items = {
				{
						cell = "Group";
						label = "Switch";
				};
				{
						defaults = "com.yourcompany.yourscript";
						default = true;
						label = "Enabled";
						cell = "Switch";
						key = "switch1";
						icon = "res/16.png";
				};
				{
						cell = "Group";
						label = "Button";
				};
				{
						url = "https://www.xxtouch.com";
						cell = "Link";
						label = "Open XXTouch.com";
				};
				{
						cell = "Button";
						action = "OpenURL:";
						label = "Contact i.82@me.com";
						args = {
								url = "mailto://i.82@me.com";
						};
				};
		};
};
```

![QQ20170914-191445.png-44.5kB][5]


----------


### Link 链接子界面

此组件在界面上显示一个子菜单项, 用于链接子界面. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|url|字符串|子界面文件名|\-|

**url** 可以为普通文件名、XUI 文件名或网络地址. 普通文件将使用默认打开方式打开, XUI 文件将作为子界面打开, 网络地址将使用内置浏览器打开. 

``` lua
{
		url = "sub/xui-sub.xui";
		cell = "Link";
		label = "Load another pane";
};
```

![QQ20170914-191746.png-51.9kB][6]


----------


### Switch 开关

此组件在界面上显示一个开关. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|negate|布尔型|反转开关显示情况|可选|
|trueValue|基本类型|当结果为 true 时保存的值<br />若不填则保存 **true**|可选|
|falseValue|基本类型|当结果为 false 时保存的值<br />若不填则保存 **false**|可选|

|  主题键  |  描述  |
|----------|--------|
|tintColor|开关底色|
|thumbColor|开关中心色|

|   返回类型   |   描述   |
|--------------|----------|
|基本类型|与开关状态一致, 但若 negate 为真, 配置值为开关状态取反.<br />若存在, 配置值会被 **trueValue** 或 **falseValue** 代替.|

``` lua
{
		defaults = "com.yourcompany.yourscript";
		default = true;
		label = "Enabled";
		cell = "Switch";
		key = "switch1";
		icon = "res/16.png";
};
```

![CFC04C38-FFBE-46B9-BE86-AE8470342DAD.png-19.2kB][7]


----------


### Button 动作按钮

此组件在界面上显示一个按钮, 用于执行某些动作. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|alignment|字符串|对齐方式|\-|
|action|选择器|指定按钮的操作类型|\-|
|args|字典|传递给选择器的参数|\-|

| alignment | 描述 |
|--------|------|
|Left|左对齐 (默认)|
|Center|居中|
|Right|右对齐|
|Natural|自然对齐|
|Justified|两边对齐|

| action | 描述 |
|--------|------|
|LaunchScript:|运行服务脚本|
|OpenURL:|在第三方应用中打开URL|
|ScanQRCode:|调起相机, 扫描二维码|
|SendMail:|在应用中, 发送邮件|

不同的 **action** 需要携带不同的参数字典 **args**, 现对参数字典 **args** 中包含的参数说明如下: 

**LaunchScript:**

|  参数  |  类型  |  描述  |  条件  |
|------|--------|--------|--------|
|path|字符串|服务脚本路径|\-|

*无返回值*

**OpenURL:**

|  参数  |  类型  |  描述  |  条件  |
|------|--------|--------|--------|
|url|字符串|欲打开的URL|\-|

*无返回值*

**ScanQRCode:**

*无参数*

|   返回值类型   |   描述   |
|----------|----------|
|字符串|二维码扫描结果|

**SendMail:**

|  参数  |  类型  |  描述  |  条件  |
|------|--------|--------|--------|
|subject|字符串|邮件主题|可选|
|toRecipients|包含字符串的数组|收件邮箱地址数组|可选|
|ccRecipients|包含字符串的数组|抄送邮箱地址数组|可选|
|bccRecipients|包含字符串的数组|密送邮箱地址数组|可选|
|attachments|包含字符串的数组|携带附件的路径数组|可选|

*无返回值*


``` lua
{
		cell = "Button";
		action = "OpenURL:";
		label = "Contact i.82@me.com";
		args = {
				url = "mailto://i.82@me.com";
		};
};
```

![QQ20170914-191854.png-23kB][8]


----------


### TextField 单行文本框

此组件在界面上显示一个文本框, 用于字符串输入. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|alignment|字符串|对齐方式|可选|
|keyboard|字符串|键盘类型|可选|
|placeholder|字符串|文本框占位符|可选|
|isSecure|布尔型|字符是否显示为小圆点|可选|

*此组件不支持 __icon__, 若设置 __title__ 属性, 建议将 __alignment__ 属性设为 "Right".*

|  主题键  |  描述  |
|----------|--------|
|textColor|颜色|文字颜色|
|caretColor|颜色|光标颜色|
|placeholderColor|颜色|占位符颜色|

| alignment | 描述 |
|--------|------|
|Left|左对齐 (默认)|
|Center|居中|
|Right|右对齐|
|Natural|自然对齐|
|Justified|两边对齐|

| keyboard | 描述 |
|--------|------|
|Default|标准及第三方键盘 (默认)|
|Alphabet|标准 ASCII|
|ASCIICapable|标准 ASCII|
|NumbersAndPunctuation|数字与标点|
|URL|网址|
|NumberPad|数字|
|PhonePad|电话号码|
|NamePhonePad|姓名与电话号码|
|EmailAddress|电子邮箱|
|DecimalPad|带小数点的数字|

|   返回类型   |   描述   |
|--------------|----------|
|字符串|文本框内容|

``` lua
{
		defaults = "com.yourcompany.yourscript";
		default = "";
		cell = "TextField";
		key = "username";
		keyboard = "Alphabet";
		placeholder = "Enter the username";
};
{
		defaults = "com.yourcompany.yourscript";
		default = "";
		isSecure = true;
		cell = "TextField";
		key = "password";
		keyboard = "Alphabet";
		placeholder = "Enter the password";
};
```

![QQ20170914-192018.png-30kB][9]


----------


### Radio / Checkbox 单选框 / 复选框组

此组件在界面上显示若干单选框 / 复选框. 

点选**单选框**会选中当前选择的单选框, 取消同组其它单选框的选中状态. 
点选**复选框**会切换其选中 / 未选状态. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|alignment|字符串|对齐方式|可选|
|options|包含字典的数组|选项列表数组|\-|
|minCount|整数|最少选择项目数|复选框有效|
|maxCount|整数|最多选择项目数|复选框有效|

| alignment | 描述 |
|--------|------|
|Left|左对齐 (默认)|
|Center|居中|
|Right|右对齐|
|Natural|扩展空白部分使两边对齐|
|Justified|扩展标签宽度使两边对齐|

**options** 包含若干 *选项*, *选项* 为字典, 有如下属性: 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|title|字符串|选项标题|可本地化|
|value|基本类型|选项配置值<br />若不填, 则与 **title** 一致.|可选|

*此组件不支持 **label/icon/height***

|  主题键  |  描述  |
|----------|--------|
|tagTextColor|标签文字颜色|
|tagSelectedTextColor|选中标签文字颜色|
|tagBackgroundColor|标签背景颜色|
|tagSelectedBackgroundColor|选中标签背景颜色|
|tagBorderColor|标签边框颜色|
|tagSelectedBorderColor|选中标签边框颜色|

|   返回类型   |   描述   |
|--------------|----------|
|包含字符串的数组|包含所有选中项 **value** 的数组|

``` lua
{
		defaults = "com.yourcompany.yourscript";
		default = {
				"Red";
				"Green";
		};
		cell = "Checkbox";
		key = "checkbox";
		maxCount = 4;
		options = {
				{
						title = "Red";
				};
				{
						title = "Green";
				};
				{
						title = "Blue";
				};
				{
						title = "Yellow";
				};
				{
						title = "Purple";
				};
				{
						title = "Black";
				};
				{
						title = "White";
				};
		};
};
{
		defaults = "com.yourcompany.yourscript";
		default = "Fifth; please!";
		cell = "Radio";
		key = "radio";
		options = {
				{
						title = "First";
				};
				{
						title = "Second";
				};
				{
						title = "Third";
				};
				{
						title = "Fourth";
				};
				{
						title = "Fifth; please!";
				};
				{
						title = "Zero";
				};
		};
};
```

![QQ20170916-182221@2x.png-185.2kB][10]


----------


### Segment 适合少量选项的单项选择

此组件在界面上显示一个选项组. 用于选择单个选项 (总选项数一般少于 6 个). 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|options|包含字典的数组|选项列表数组|\-|

**options** 包含若干 *选项*, *选项* 为字典, 有如下属性: 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|title|字符串|选项标题|可本地化|
|value|基本类型|选项配置值<br />若不填, 则与 **title** 一致.|可选|

*此组件不支持 **icon***

|   返回类型   |   描述   |
|--------------|----------|
|字符串|选中项的 **value**|

``` lua
{
		defaults = "com.yourcompany.yourscript";
		default = "Green";
		label = "List of Options";
		cell = "Segment";
		key = "list-segment";
		options = {
				{
						title = "Red";
				};
				{
						title = "Green";
				};
				{
						title = "Blue";
				};
		};
};
```

![QQ20170914-192102.png-14.5kB][11]


----------


### Option 单项选择列表

此组件在界面上显示一个子菜单项, 用于链接包含一些选项的子菜单. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|options|包含字典的数组|选项列表数组|\-|
|footerText|字符串|显示在列表选项下方的小字|可选, 可本地化|

**options** 包含若干 *选项*, *选项* 为字典, 有如下属性: 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|title|字符串|选项标题|可本地化|
|shortTitle|字符串|显示在父级菜单右侧的标题|可选, 可本地化|
|value|基本类型|选项配置值<br />若不填, 则与 **title** 一致.|可选|
|icon|字符串|选项图标文件名|可选|

|   返回类型   |   描述   |
|--------------|----------|
|字符串|选中项的 **value**|

``` lua
{
		defaults = "com.yourcompany.yourscript";
		default = "Green; it's green!";
		label = "List of Options";
		cell = "Option";
		key = "list-1";
		options = {
				{
						title = "Red; it's red!";
						shortTitle = "Red";
				};
				{
						title = "Green; it's green!";
						shortTitle = "Green";
				};
				{
						title = "Blue; great color!";
						shortTitle = "Blue";
				};
		};
};
```

![QQ20170916-182546@2x.png-23.3kB][12]


----------


### MultipleOption 多项选择列表

此组件在界面上显示一个子菜单项, 用于链接包含一些选项的子菜单. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|options|包含字典的数组|选项列表数组|\-|
|footerText|字符串|显示在列表选项下方的小字|可选, 可本地化|
|maxCount|整数|最多选择项目数|\-|

**options** 包含若干 *选项*, *选项* 为字典, 有如下属性: 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|title|字符串|选项标题|可本地化|
|value|基本类型|选项配置值<br />若不填, 则与 **title** 一致.|可选|
|icon|字符串|选项图标文件名|可选|

|   返回类型   |   描述   |
|--------------|----------|
|包含字符串的数组|包含所有选中项 **value** 的数组|

``` lua
{
		defaults = "com.yourcompany.yourscript";
		default = {
				"Red; it's red!"; "Green; it's green!"
		};
		label = "List of Multiple Options";
		cell = "MultipleOption";
		key = "list-2";
		maxCount = 2;
		options = {
				{
						title = "Red; it's red!";
				};
				{
						title = "Green; it's green!";
				};
				{
						title = "Blue; great color!";
				};
		};
};
```

![QQ20170916-182611@2x.png-25.2kB][13]


----------


### OrderedOption 多项有序选择列表

此组件在界面上显示一个子菜单项, 用于链接包含一些选项的子菜单. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|options|包含字典的数组|选项列表数组|\-|
|footerText|字符串|显示在列表选项下方的小字|可选, 可本地化|
|minCount|整数|最少选择项目数|\-|
|maxCount|整数|最多选择项目数|\-|

**options** 包含若干 *选项*, *选项* 为字典, 有如下属性: 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|title|字符串|选项标题|可本地化|
|value|基本类型|选项配置值<br />若不填, 则与 **title** 一致.|可选|
|icon|字符串|选项图标文件名|可选|


|   返回类型   |   描述   |
|--------------|----------|
|包含字符串的数组|包含所有选中项 **value** 的数组|

``` lua
{
		defaults = "com.yourcompany.yourscript";
		default = {
				"Red";
		};
		label = "List of Ordered Options";
		cell = "OrderedOption";
		key = "list-3";
		maxCount = 2;
		minCount = 1;
		options = {
				{
						title = "Red";
				};
				{
						title = "Green";
				};
				{
						title = "Blue";
				};
		};
};
```

![QQ20170916-182729@2x.png-34kB][14]


----------


### EditableList 可编辑列表

此组件在界面上显示一个子菜单项, 用于链接一个可编辑的字符串列表. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|footerText|字符串|显示在列表选项下方的小字|可选, 可本地化|
|maxCount|整数|最多选择项目数|\-|

|  主题键  |  描述  |
|----------|--------|
|textColor|颜色|文字颜色|
|caretColor|颜色|光标颜色|
|placeholderColor|颜色|占位符颜色|

|   返回类型   |   描述   |
|--------------|----------|
|包含字符串的数组|列表内容|

```lua
{
		maxCount = 10;
		defaults = "com.yourcompany.yourscript";
		cell = "EditableList";
		label = "Editable List";
		key = "list-4";
		default = {
				"Default";
		};
};
```

![QQ20171016-180741.png-157.3kB][15]


----------


### Slider 数值拖拽滑块

此组件在界面上显示一个滑块, 用于数值的选择和调整. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|min|数值|滑块最小值|\-|
|max|数值|滑块最大值|\-|
|showValue|布尔型|是否显示当前滑块的值|可选|

*此组件不支持 **label/icon***

|  主题键  |  描述  |
|----------|--------|
|tintColor|滑块进度底色|
|thumbColor|开关中心色|

|   返回类型   |   描述   |
|--------------|----------|
|数值|组件数值|

``` lua
{
		showValue = true;
		defaults = "com.yourcompany.yourscript";
		min = 1;
		default = 5;
		max = 10;
		label = "Slider";
		cell = "Slider";
		key = "slider";
		isSegmented = true;
};
```

![QQ20170914-192324.png-9.1kB][16]


----------


### Stepper 数值调节按钮

此组件在界面上显示一个调节器, 用于数值的选择和调整. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|min|数值|调节最小值|\-|
|max|数值|调节最大值|\-|
|step|数值|调节歩长|\-|
|isInteger|布尔型|值是否显示为整数|可选|
|autoRepeat|布尔型|长按是否连续调整|可选|

|   返回类型   |   描述   |
|--------------|----------|
|数值|组件数值|

``` lua
{
		defaults = "com.yourcompany.yourscript";
		min = 1;
		default = 5;
		max = 10;
		autoRepeat = true;
		label = "Stepper";
		cell = "Stepper";
		key = "stepper";
		isInteger = true;
};
```

![QQ20170914-192349.png-10.8kB][17]


----------


### DateTime 时间日期选择器

此组件在界面上显示一个时间日期选择器, 用于日期、时间的选择及时间间隔的调整. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|min|数值|时间间隔最小值|可选|
|max|数值|时间间隔最大值|可选|
|minuteInterval|整数|时间间隔歩长, 单位分钟|可选|
|mode|字符串|选择器模式|可选|

*此组件不支持 **label/icon***

| mode | 描述 |
|--------|------|
|datetime|日期时间选择器 (默认)|
|date|日期选择器|
|time|时间选择器|
|interval|时间间隔选择器|

|   返回类型   |   描述   |
|--------------|----------|
|整数|组件所选时间的 Unix 时间戳, 或时间间隔的秒数|

``` lua
{
		cell = "DateTime";
		key = "datetime1";
		defaults = "com.yourcompany.yourscript";
};
```

![QQ20170917-000929@2x.png-77.9kB][18]


----------


### TitleValue 键值对显示; 代码片段选择器

此组件在界面上显示 key - value 对, 类似 设置 -> 通用 -> 关于中系统参数键值对的显示. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|value|基本类型|右侧显示值|可选|
|snippet|字符串|选择器脚本文件名|可选|

此组件可以左划将已存的配置值置空, 但不能覆盖 XUI 中提供的 value. 

如果为此组件设置了 **defaults** 和 **key**, 则此组件可用来显示配置项的实际值；同时设置 **snippet** 属性, 则能够为此组件增加 XUI 内选择器的功能, 激活选择器组, 并将返回结果存入此组件的配置项内. 

``` lua
{
		default = true;
		cell = "Switch";
		key = "switch1";
		defaults = "com.yourcompany.yourscript";
		label = "Sosh!";
};
{
		cell = "TitleValue";
		label = "Version";
		value = "1.1.3";
}; -- 显示固定值
{
		cell = "TitleValue";
		label = "Dynamic";
		key = "switch1";
		defaults = "com.yourcompany.yourscript";
}; -- 显示配置值
{
		cell = "TitleValue";
		label = "Application";
		key = "applications";
		defaults = "com.yourcompany.yourscript";
		snippet = "snippets/app.snippet";
}; -- 显示选择器组
```

![QQ20170914-192446.png-36.5kB][19]


----------


### StaticText 静态文本框

此组件在界面上显示一段静态文本, 即其 label 属性中的文本. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|alignment|字符串|对齐方式|可选|
|selectable|布尔型|是否允许选择文本|可选|

| alignment | 描述 |
|--------|------|
|Left|左对齐 (默认)|
|Center|居中|
|Right|右对齐|
|Natural|自然对齐|
|Justified|两边对齐|

*暂不支持更改文本字体、尺寸等属性*

*此组件不支持 **label/icon/height***

``` lua
{
		cell = "StaticText";
		label = "This specifier uses the label key as text content. Dynamic height of this cell is enabled.";
};
```

![QQ20170914-192523.png-30.6kB][20]


----------


### Textarea 多行文本域


此组件在界面上显示一个子菜单项, 用于链接到一个多行文本输入界面. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|maxLength|整数|最大文本长度|可选|
|keyboard|字符串|键盘类型|可选|
|autoCapitalization|字符串|自动大写模式|可选|
|autoCorrection|字符串|自动更正模式|可选|

|  主题键  |  描述  |
|----------|--------|
|textColor|颜色|文字颜色|
|caretColor|颜色|光标颜色|
|placeholderColor|颜色|占位符颜色|

| keyboard | 描述 |
|--------|------|
|Default|标准及第三方键盘 (默认)|
|Alphabet|标准 ASCII|
|ASCIICapable|标准 ASCII|
|NumbersAndPunctuation|数字与标点|
|URL|网址|
|NumberPad|数字|
|PhonePad|电话号码|
|NamePhonePad|姓名与电话号码|
|EmailAddress|电子邮箱|
|DecimalPad|带小数点的数字|

| autoCapitalization | 描述 |
|--------|------|
|None|无 (默认)|
|Sentences|按句自动大写|
|Words|按单词自动大写|
|AllCharacters|全部大写|

| autoCorrection | 描述 |
|--------|------|
|Default|默认 (默认)|
|No|关闭自动更正|
|Yes|打开自动更正|

*暂不支持更改文本字体、尺寸等属性*

|   返回类型   |   描述   |
|--------------|----------|
|字符串|文本内容|

``` lua
{
		default = "You can enter any text here...";
		cell = "Textarea";
		key = "textarea";
		defaults = "com.yourcompany.yourscript";
		label = "Textarea Cell";
};
```


----------


### Image / AnimatedImage 图片 / 动态图片

此组件在界面上显示图片. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|path|字符串|本地图片名称|\-|

此组件必须设定通用属性 **height**,  以确定图片高度, 宽度将保持比例自动适应. 

**AnimatedImage** 组件支持 GIF 动态图. 

``` lua
{
		cell = "Image";
		path = "res/bd_logo1_31bdc765.png";
		height = 128.0;
};
```

![QQ20170918-022558.png-31kB][21]


----------


### File 文件选择器

此组件在界面上显示文件选择区域, 可显示文件类型图标、文件名称与文件修改时间, 点击可选择新文件. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|initialPath|字符串|文件选择初始顶层目录|可选|
|allowedExtensions|包含字符串的数组|允许的文件扩展名列表|可选|

此组件可以左划将已存的配置值置空. 

**initialPath** 若不填, 则为当前脚本包路径. **allowedExtensions** 中包含允许选择的文件名列表, 不符合扩展名要求的项目将不会被显示. 

|   返回类型   |   描述   |
|--------------|----------|
|字符串|所选文件完整路径|

``` lua
{
		cell = "File";
		key = "file1";
		defaults = "com.yourcompany.yourscript";
		allowedExtensions = { "lua"; "xxt"; "xpp" };
};
```

![QQ20170918-022520.png-31.5kB][22]

----------

### About 关于

此组件在界面上显示一个关于区域, 其样式与 XXTouch 关于界面样式一致. 

|   键   |   类型   |   描述   |   条件   |
|--------|----------|----------|----------|
|imagePath|字符串|关于图标|可选|

此组件需要设定通用属性 **label** 与 **value**, 分别显示在关于标题位置与副标题位置. 

```lua
{
		cell = "About";
		label = "XXTouch\nv1.2.0-1";
		value = "https://www.xxtouch.com\n2016-2017 (c) XXTouch Team.\nAll Rights Reserved.";
};
```

![A0EE71ED-F67B-4A88-9E57-30F2C581E3A3.png-91kB][23]

----------


	[1]: http://static.zybuluo.com/xxtouch/9so2wyf6ennrc0s2ar7vl0ov/A-Script-Bundle.xpa
	[2]: http://static.zybuluo.com/xxtouch/vb58yu2p3c8ihd3xztk66bar/1512233554.png
	[3]: http://static.zybuluo.com/xxtouch/yp88j1ws4na1r8enodb7ydhl/IMG_0716.JPG
	[4]: http://static.zybuluo.com/xxtouch/hxvpaqv424u4b4gjjg98aw2d/CFE17DA4-C299-4533-A0E9-E1E2F9734C8D.png
	[5]: http://static.zybuluo.com/xxtouch/8taro66htfohfw09hryyl0hv/QQ20170914-191445.png
	[6]: http://static.zybuluo.com/xxtouch/ac1u7v1ix272uvkgvg6j9qk7/QQ20170914-191746.png
	[7]: http://static.zybuluo.com/xxtouch/jm8gc462xjyi62gwiguzbzfa/CFC04C38-FFBE-46B9-BE86-AE8470342DAD.png
	[8]: http://static.zybuluo.com/xxtouch/rjklx5duv3eh0bkx24vxpcf9/QQ20170914-191854.png
	[9]: http://static.zybuluo.com/xxtouch/qoakjz7jg94iktgg2w0g1jdg/QQ20170914-192018.png
	[10]: http://static.zybuluo.com/xxtouch/tommwf1shji1gs6oc43k0sfo/QQ20170916-182221@2x.png
	[11]: http://static.zybuluo.com/xxtouch/cg54nkdvmezr1t8j4ef8nr8l/QQ20170914-192102.png
	[12]: http://static.zybuluo.com/xxtouch/x2uld8468nmcsvz2j3i08tn6/QQ20170916-182546@2x.png
	[13]: http://static.zybuluo.com/xxtouch/kgt4wil6flrisgpzvdza62gt/QQ20170916-182611@2x.png
	[14]: http://static.zybuluo.com/xxtouch/do6m93m2gjrcklyi12g4utke/QQ20170916-182729@2x.png
	[15]: http://static.zybuluo.com/xxtouch/cms3lnd7nlm1e10w5ii738wn/QQ20171016-180741.png
	[16]: http://static.zybuluo.com/xxtouch/z7wpczvqy0ilw9xbu9mpjh9l/QQ20170914-192324.png
	[17]: http://static.zybuluo.com/xxtouch/719ucx2zpm1jzxwxu7gexjeb/QQ20170914-192349.png
	[18]: http://static.zybuluo.com/xxtouch/p1oneomh57ftv97vu819xls8/QQ20170917-000929@2x.png
	[19]: http://static.zybuluo.com/xxtouch/k3mvmdkeweg91zejrz2g7usd/QQ20170914-192446.png
	[20]: http://static.zybuluo.com/xxtouch/0emxjk45iceyk1fufog7000g/QQ20170914-192523.png
	[21]: http://static.zybuluo.com/xxtouch/6jhlork14eat0w2xej0x6hj5/QQ20170918-022558.png
	[22]: http://static.zybuluo.com/xxtouch/keg9dr84ef52tc6cboq64nqi/QQ20170918-022520.png
	[23]: http://static.zybuluo.com/xxtouch/71dr9w7yn4pz4wi8orpnkwlz/A0EE71ED-F67B-4A88-9E57-30F2C581E3A3.png