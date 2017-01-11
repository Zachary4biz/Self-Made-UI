//
//  TextViewViewController.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/12/29.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "TextViewViewController.h"
#import "SetUpAboutKeyboard.h"

@interface TextViewViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *functionView;
@property (weak, nonatomic) IBOutlet UIView *slideBar;
@property (weak, nonatomic) IBOutlet UIView *square;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *functionalBtn1;
- (IBAction)functionalBtn1:(id)sender;
- (IBAction)functionalBtn2:(id)sender;
- (IBAction)functionalBtn3:(id)sender;
- (IBAction)functionalBtn4:(id)sender;


@property (nonatomic, assign) CGFloat squareOffset;
@property (nonatomic, assign) CGFloat squareOriginalX;
//@property (nonatomic, strong) NSOperation *moveRightOperation;
//@property (nonatomic, strong) NSOperation *moveLeftOperation;
//@property (nonatomic, assign) NSRunLoop *moveRightRunLoop;
//@property (nonatomic, assign) CFRunLoopRef moveLeftRunLoop;
@property (nonatomic, strong) NSOperationQueue *moveRightQueue;
@property (nonatomic, strong) NSOperationQueue *moveLeftQueue;

@property (nonatomic, strong) NSTimer *moveLeftTimer;
@property (nonatomic, strong) NSTimer *moveRightTimer;

@property (nonatomic, strong) NSTimer *selectLeftTimer;
@property (nonatomic, strong) NSTimer *selectRightTimer;
@end

@implementation TextViewViewController

- (CGFloat)squareOffset
{
    _squareOffset = _square.frame.origin.x - _squareOriginalX;
    return _squareOffset;
}

- (NSTimer *)moveLeftTimer
{
    if (!_moveLeftTimer) {
        _moveLeftTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(makeOffsetAutoIncreaseLeft) userInfo:nil repeats:YES];
    }
    return _moveLeftTimer;
}

- (NSTimer *)moveRightTimer
{
    if (!_moveRightTimer) {
        _moveRightTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(makeOffsetAutoIncreaseRight) userInfo:nil repeats:YES];
    }
    return _moveRightTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    //拖拽移动光标
    UIPanGestureRecognizer *aPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.square addGestureRecognizer:aPanGesture];
    
    //双击全选
    UITapGestureRecognizer *aDoubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [aDoubleTapGesture setNumberOfTapsRequired:2];
    [self.square addGestureRecognizer:aDoubleTapGesture];
    
    //双击后单击跳到开头、结尾
    UITapGestureRecognizer *aTapAfterDoubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAfterDoubleTap:)];
    //这句很重要
    [aTapAfterDoubleTapGesture requireGestureRecognizerToFail:aDoubleTapGesture];
    [self.square addGestureRecognizer:aTapAfterDoubleTapGesture];
    
    //长按选择
    UILongPressGestureRecognizer *aLongPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.square addGestureRecognizer:aLongPressGesture];
    
    
    //初始化originalX
    self.squareOriginalX = self.square.frame.origin.x;
    self.textField.delegate = self;
    self.textField.text = @"begin-----------a;sdjlkfhc阿斯兰的；开飞机离开；差距暗室逢灯；拉三等奖iuxcfgadsa;sdjlkfhcxuizviuabshjekgqwibshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwibshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwibshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwibshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwibshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiads*************end测试中文";
//    self.textField.text = @"begin-------a;sdjlkfhc阿斯兰的阿斯兰的阿斯兰的阿斯兰的阿斯兰的阿斯兰的";
    [[SetUpAboutKeyboard alloc]initWithPreparation4KeyboardWithVC:self andLiftTheViews:nil];
    
    //初始化队列
    self.moveRightQueue = [[NSOperationQueue alloc]init];
    self.moveLeftQueue = [[NSOperationQueue alloc]init];
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            NSLog(@"%@",[[NSRunLoop currentRunLoop] class]);
            NSLog(@"squareFrame%@ - slideBarFrame%@",NSStringFromCGRect(self.square.frame),NSStringFromCGRect(self.slideBar.frame));
        } while (self.square.frame.origin.x <= self.slideBar.frame.origin.x);
    });
}
#pragma mark LongPress手势

//这个用来记录自动右移和自动左移
static float recorder4AutoSelectionRight;
static float recorder4AutoSelectionLeft;
static int increasement4AutoSelection = 1;
static float log4AutoSelection = 1.2;
/*
 *这个是记录一下移动到哪里了，方便作为后面自动位移的基数来不停地加
 *不然这样写有问题：self.square.transform.tx + (int)(log(recorder4AutoSelectionRight)/log(log4AutoSelection))
 *导致offset每次增加的是 增量 的 增加量，比如增量依次是1 2 3 4 5 6 ，我希望的其实是offset每次增加1 2 3 4 5 6，结果是每次都只增加了1
 */
static float currentOffsetInTransform = 0;
/*
 *从自动选择（自动移动光标）的状态中出来，如果没有松开手，而是直接通过往回拖了一下滑块的方式
 *这时候是希望从当前选中的地方稍微往回来一个两个字符
 *而老的逻辑中做不到，因为如果直接往回就进入到了最开始的if判断中，直接用transform.tx作为offset来用了，显然不对
 *这时候应该用transform.tx的改变量来当做增量，加到现在的offset上，
 *所以用 isTransformAfterAutoSelection 判断是否是从自动状态出来的，以及从左移还是右移出来
 * （错）用 recorder4TransformX 来记录从而通过 transform.tx - recorder 得到transform的增量（错）
 *上面那句不对，因为这个拿来减的recorder初始不是0，而是根据从自动左移结束还是右移来判断它初始是最左边还是最右边
 *最左边（最负的）和最右边（最正的）的transform.tx不好直接初始化出来，那就在if elseif里面的开启timer时记录一下
 */
static int isTransformAfterAutoSelection = 0;
static CGFloat recorder4TransformX = 0;
static CGFloat recorder4MaxLeftTransformX = 0;
static CGFloat recorder4MaxRightTransformX = 0;
- (void)longPress:(UILongPressGestureRecognizer *)aLongPress
{
    if (aLongPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始长按");
        self.slideBar.backgroundColor = [UIColor cyanColor];
    }else if (aLongPress.state == UIGestureRecognizerStateChanged){
        NSLog(@"self.square.frame -- %@",NSStringFromCGRect(self.square.frame));
        CGPoint gesturePoint = [aLongPress locationInView:self.slideBar];
        NSLog(@"gesturePoint-longPress-location- %@",NSStringFromCGPoint(gesturePoint));
        
        //当前选中的offset
        NSInteger currentSelectedOffset = [self.textField offsetFromPosition:self.textField.selectedTextRange.start toPosition:self.textField.selectedTextRange.end];
        NSLog(@"当前选中量是%ld",currentSelectedOffset);
        if (gesturePoint.x>0+0.5*self.square.frame.size.width && gesturePoint.x<self.slideBar.frame.size.width-0.5*self.square.frame.size.width) {
            /*
             *这里transform之后，center.x虽然没有改变，但是根据实际位置的计算，
             *square的中心self.square.frame.origin.x+0.5*self.square.frame等于手势点的位置
             */
            self.square.transform = CGAffineTransformMakeTranslation(gesturePoint.x-self.square.center.x, 0);
            //将要发生的offset（来自滑块的位移），要判断一下是直接使用还是加上当前选中的offset后再用
            NSInteger willOffset = self.square.transform.tx;
            //记录一下transform
            recorder4TransformX = self.square.transform.tx;
            if (isTransformAfterAutoSelection == 1) {
                //如果是从自动移动状态结束了，没有松开手，而是直接又移动（往中间移）了滑块
//                willOffset += willOffset>0?currentSelectedOffset:-currentSelectedOffset;
                NSLog(@"从自动状态（左移）结束来到第一个if进行transform");
                NSInteger deltaOffset = self.square.transform.tx - recorder4MaxLeftTransformX;
                NSLog(@"变化量是%lf",self.square.transform.tx - recorder4MaxLeftTransformX);
                
                self.textField.selectedTextRange = [self.textField textRangeFromPosition:self.textField.selectedTextRange.end
                                                                               toPosition:[self.textField positionFromPosition:self.textField.selectedTextRange.start
                                                                                                                        offset:-deltaOffset+currentSelectedOffset]];
            }else if (isTransformAfterAutoSelection == 2){
                /*
                NSLog(@"从自动状态（右移）结束来到第一个if进行transform");
                NSInteger deltaOffset = self.square.transform.tx - recorder4MaxRightTransformX;
                NSLog(@"变化量是%lf",self.square.transform.tx - recorder4MaxRightTransformX);
                self.textField.selectedTextRange = [self.textField textRangeFromPosition:self.textField.selectedTextRange.start
                                                                              toPosition:[self.textField positionFromPosition:self.textField.selectedTextRange.start
                                                                                                                       offset:deltaOffset+currentSelectedOffset]];
                 */
                /*
                 *非常舒服的是自动右移是系统做好了的
                 */
            }else{
                //这就是正常情况下的拖动，直接用这个transform.tx当offset就行了
                [self makeSelectionWithOffset:willOffset];
            }
            
            //这个是记录一下移动到哪里了，方便作为后面自动位移的基数来不停地加
            currentOffsetInTransform = self.square.transform.tx;
        }else if (gesturePoint.x <= 5){
            //移到了slideBar的左边，表示要自动左移了，其实5还没有到左边，但是相当于滤波一下吧
            //记录一下最左边的时候transform是什么
            recorder4MaxLeftTransformX = self.square.transform.tx;
            NSLog(@"最左边的transform.tx是%lf",recorder4MaxLeftTransformX);
            if (!self.selectLeftTimer) {
                self.selectLeftTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    if (self.square.frame.origin.x <= 5) {
                        recorder4AutoSelectionLeft += increasement4AutoSelection;
                        //每次都加这个增量
                        currentOffsetInTransform += -(int)(log(recorder4AutoSelectionLeft)/log(log4AutoSelection));
                        [self makeSelectionWithOffset:currentOffsetInTransform];
                    }else{
                        NSLog(@"结束Timer");
                        [self.selectLeftTimer invalidate];
                        self.selectLeftTimer = nil;
                        //这个是标记一下现在状态是从自动移动中结束出来的 1表示自动左移
                        isTransformAfterAutoSelection = 1;
                        //重置
                        recorder4AutoSelectionLeft = 0.0;
                        //重置currentOffsetInTransform
                        currentOffsetInTransform = self.square.transform.tx;
                        
                    }
                }];
            }
        }else if (gesturePoint.x>self.slideBar.frame.size.width-5){
            //移到了slideBar的右边，表示要自动右移了，用5滤波一下
            //记录一下最右边的时候transform是什么
            recorder4MaxRightTransformX = self.square.transform.tx;
            NSLog(@"最右边的transform.tx是%lf",recorder4MaxRightTransformX);
            if (!self.selectRightTimer) {
                NSLog(@"手势点是--%lf",gesturePoint.x);
                self.selectRightTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    if (self.square.frame.origin.x>self.slideBar.frame.size.width-self.square.frame.size.width-5) {
                        recorder4AutoSelectionRight += increasement4AutoSelection;
                        currentOffsetInTransform += (int)(log(recorder4AutoSelectionRight)/log(log4AutoSelection));
                        [self makeSelectionWithOffset:currentOffsetInTransform];
                    }else{
                        NSLog(@"结束Timer");
                        [self.selectRightTimer invalidate];
                        self.selectRightTimer = nil;
                        //这个是标记一下现在状态是从自动移动中结束出来的， 2表示自动右移
                        isTransformAfterAutoSelection = 2;
                        //重置
                        recorder4AutoSelectionLeft = 0.0;
                        //重置currentOffsetInTransform
                        currentOffsetInTransform = self.square.transform.tx;
                        
                    }
                }];
            }
        }
    }
    if (aLongPress.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.square.transform = CGAffineTransformIdentity;
        }];
        self.slideBar.backgroundColor = [UIColor lightGrayColor];
        NSLog(@"结束长按");
        //重置
        isTransformAfterAutoSelection = 0;
    }
}

#pragma mark 移动选择方法
- (void)makeSelectionWithOffset:(NSInteger)aOffset
{
//    NSLog(@"aOffset--%ld",aOffset);
    //起始点
    UITextPosition *selectionBeginPosition;
    UITextPosition *targetPosition;
    if (aOffset>0) {
        //表示是应该向右边移动
        //光标向右移动那么就是向右选择，所以起始点应该是左边的，左边的是.start
        selectionBeginPosition = self.textField.selectedTextRange.start;
        targetPosition = [self.textField positionFromPosition:selectionBeginPosition offset:aOffset];
        //预计会移动到的位置距离末尾有多少个字符
        NSInteger targetOffset2End = [self.textField offsetFromPosition:targetPosition toPosition:self.textField.endOfDocument];
        //当前距离末尾还有多少个字符
        NSInteger currentRemainOffset2End = [self.textField offsetFromPosition:self.textField.selectedTextRange.start toPosition:self.textField.endOfDocument];
        if (targetOffset2End >= currentRemainOffset2End ) {
            //如果预计移动后距离末尾字符数大于现在还剩下的，说明超过了尾巴，修改targetPosition为末尾就好了
            targetPosition = self.textField.endOfDocument;
        }
        

    }else{
        //向左边移不用管，系统默认移动到最左边也不会到textField的末尾处
        //但是起始点就变了，向左选择，起始点应该是右边的.end
//        NSLog(@"左移%ld个",aOffset);
        selectionBeginPosition = self.textField.selectedTextRange.end;
        targetPosition = [self.textField positionFromPosition:selectionBeginPosition offset:aOffset];
    }
    self.textField.selectedTextRange = [self.textField textRangeFromPosition:selectionBeginPosition
                                                                  toPosition:targetPosition];
    
    if (aOffset>0) {
        /*
         *这里特意放在selectedTextRange修改后再来修改UIFieldEditor的偏移量
         *不然SelectedTextRange一变又会改掉UIFieldEdito的偏移量
         */
        //向右边选择文字会出现field不会自动右移的情况
        
        NSString *selectedStr2BeginOfDocument = [self.textField textInRange:[self.textField textRangeFromPosition:self.textField.beginningOfDocument
                                                                                                       toPosition:targetPosition]];
//        NSLog(@"选中的文字是:\n%@",selectedStr2BeginOfDocument);
        CGSize strSize = [selectedStr2BeginOfDocument sizeWithAttributes:@{NSFontAttributeName:self.textField.font}];
        
        UIScrollView *theUIFieldEditorContentView;
        for (id i in self.textField.subviews)
        {
            if ([i class] == NSClassFromString(@"UIFieldEditor")) {
                theUIFieldEditorContentView = i;
            }
        }
        CGFloat offsetX = (strSize.width - theUIFieldEditorContentView.frame.size.width)>0?strSize.width - theUIFieldEditorContentView.frame.size.width:0;
        theUIFieldEditorContentView.contentOffset =CGPointMake(offsetX,0);
    }
}

#pragma mark DoubleTap手势
//这两个是判断在双击全选之前，光标是在文本开头还是在文本末尾处
static int isHeadOfText = 0;
static int isTailOfText = 0;
- (void)doubleTap:(UITapGestureRecognizer *)aDoubleTap
{
    //开始选中前光标距离文本末尾的offset
    NSInteger offset2End = [self.textField offsetFromPosition:self.textField.selectedTextRange.start
                                                   toPosition:self.textField.endOfDocument];
    if (offset2End == 0) {
        //光标在末尾
        isTailOfText = 1;
    }else if(offset2End == [self.textField offsetFromPosition:self.textField.beginningOfDocument
                                                   toPosition:self.textField.endOfDocument])
    {
        //光标在开头
        isHeadOfText = 1;
    }
    //选中范围设置为全文
    self.textField.selectedTextRange = [self.textField textRangeFromPosition:self.textField.beginningOfDocument
                                                                  toPosition:self.textField.endOfDocument];
    
}
#pragma mark DoubleTap&Tap 手势
- (void)tapAfterDoubleTap:(UITapGestureRecognizer *)aTap
{
    //文字总的长度
    NSInteger totalOffset = [self.textField offsetFromPosition:self.textField.beginningOfDocument
                                                    toPosition:self.textField.endOfDocument];
    //当前选中的文字长度
    NSInteger currentOffset = [self.textField offsetFromPosition:self.textField.selectedTextRange.start
                                                      toPosition:self.textField.selectedTextRange.end];
    if(totalOffset == currentOffset){
        //表示是已经双击选中过了
        if (isHeadOfText) {
            //双击前，光标在开头，那么现在就让光标去末尾
            self.textField.selectedTextRange = [self.textField textRangeFromPosition:self.textField.endOfDocument
                                                                          toPosition:self.textField.endOfDocument];
            //并重置
            isHeadOfText = 0;
        }else if (isTailOfText){
            //双击前，光标在末尾，现在就让光标去开头
            self.textField.selectedTextRange = [self.textField textRangeFromPosition:self.textField.beginningOfDocument
                                                                          toPosition:self.textField.beginningOfDocument];
            //并重置
            isTailOfText = 0;
        }
    }
    
}
#pragma mark Pan手势
static CGFloat recorder4SquareOffsetChange = 0.0;
- (void)pan:(UIPanGestureRecognizer *)aPanGesture
{
    NSLog(@"--gesturePoint-pan-location-%@",NSStringFromCGPoint([aPanGesture locationInView:self.slideBar]));

        CGPoint gesturePoint = [aPanGesture translationInView:self.slideBar];
    NSLog(@"--gesturePoint-pan-translation-%@",NSStringFromCGPoint(gesturePoint));

    if (fabsl(gesturePoint.x)<0.5*self.slideBar.frame.size.width){
            //滑动范围还在slideBar里面==>方块移动 ==> 光标也要移动
            self.square.transform = CGAffineTransformMakeTranslation(gesturePoint.x, 0);
            recorder4SquareOffsetChange = self.square.transform.tx-recorder4SquareOffsetChange;
            [self makeOffset:recorder4SquareOffsetChange onTextField:self.textField];
            recorder4SquareOffsetChange = self.square.transform.tx;
        //要停止runloop
        [self.moveRightQueue cancelAllOperations];
        
    }else if(gesturePoint.x>=0.5*self.slideBar.frame.size.width){
        //滑动范围在slideBar右边==>方块停在了最右边==>光标自动向右移(预计这个offset大一点好，比如10)
        if (self.moveRightTimer.isValid) {
            
        }else{
            [self.moveRightTimer fire];
        }
        
    }else if(gesturePoint.x<=-0.5*self.slideBar.frame.size.width){
        //滑动范围在slideBar左边==>方块停在了最左边==>光标自动向左移
        if (self.moveLeftTimer.isValid) {
            
        }else{
            [self.moveLeftTimer fire];
        }
        
    }
    if (aPanGesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.square.transform = CGAffineTransformIdentity;
        }];
        recorder4SquareOffsetChange = 0.0;
    }
}

#pragma mark 移动方法
/*
 *判断移动的方向，因为系统有个默认的移动到最后再移就自动回到开头开始移，不希望有这个
 *所以判断一下，
 *如果aOffset是正数表示在往右移，那么距离末尾应该越来越近，即targetOffset2End越来越小
 *（反之，targetOffset2End应该越来越大，但是不用考虑这个，因为系统没有到开头再回到末尾这个毛病。）
 */
- (void)makeOffset:(NSInteger)aOffset onTextField:(UITextField *)textField
{
    UITextPosition *targetPosition = [textField positionFromPosition:textField.selectedTextRange.start offset:aOffset];
    //预计会移动到的位置距离末尾有多少个字符
    NSInteger targetOffset2End = [textField offsetFromPosition:targetPosition toPosition:textField.endOfDocument];
    //当前距离末尾还有多少个字符
    NSInteger currentRemainOffset2End = [textField offsetFromPosition:textField.selectedTextRange.start toPosition:textField.endOfDocument];
    NSLog(@"aOffset -- %ld",aOffset);
    NSLog(@"预计移动后距离末尾--%ld",targetOffset2End);
    NSLog(@"当前剩余--%ld",currentRemainOffset2End);
    if (aOffset>0) {
        //表示是应该向右边移动
        if (targetOffset2End > currentRemainOffset2End ) {
            //如果预计移动后距离末尾字符数大于现在还剩下的，说明超过了尾巴，要修改targetPosition为末尾就好了
            targetPosition = textField.endOfDocument;
        }
    }else{
        //向左边移不用管，系统默认移动到最左边也不会到textField的末尾处
    }
    textField.selectedTextRange = [textField textRangeFromPosition:targetPosition toPosition:targetPosition];
}
static int increasement4Offset = 0;
static float num4log = 1.2;
static int num4Increase = 1;
- (void)makeOffsetAutoIncreaseLeft
{
    NSLog(@"正在自动左移");
    if (self.square.frame.origin.x<=self.slideBar.frame.origin.x) {
        increasement4Offset += num4Increase;
        [self makeOffset:-(int)(log(increasement4Offset)/log(num4log)) onTextField:self.textField];
        NSLog(@"increasement %d  offset %d",increasement4Offset,(int)(log(increasement4Offset)/log(num4log)));
    }else{
        increasement4Offset = 0;
        [_moveLeftTimer invalidate];
        _moveLeftTimer = nil;
    }
    
}
- (void)makeOffsetAutoIncreaseRight
{
    NSLog(@"正在自动右移");
    if (self.square.frame.origin.x>self.slideBar.frame.size.width - self.square.frame.size.width) {
        increasement4Offset += num4Increase;
        [self makeOffset:(int)(log(increasement4Offset)/log(num4log)) onTextField:self.textField];
        NSLog(@"increasement %d  offset %d",increasement4Offset,(int)(log(increasement4Offset)/log(num4log)));
    }else{
        increasement4Offset = 0;
        [_moveRightTimer invalidate];
        _moveRightTimer = nil;
    }
    
}
#pragma mark 检测是否有中文
- (BOOL)isContainChineseCharacter:(NSString *)Str
{
    for (int i=0; i<[Str length]; i++) {
        int a = [Str characterAtIndex:i];
        if (a>0x4e00 && a<0x9fff) {
            return YES;
        }
    }
    return NO;
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIScrollView *theEditorView;
    if ([self isContainChineseCharacter:textField.text]) {
        for (UIScrollView *view in textField.subviews)
        {
            if ([view class] == NSClassFromString(@"UIFieldEditor")) {
                theEditorView = view;
            }
        }
    }
    theEditorView.contentOffset = CGPointMake(0, 3);
}
- (void)textDidChange:(id<UITextInput>)textInput
{
    
}
static CGRect caretRectForPosition;
static CGRect firstRectForRange;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    caretRectForPosition = [self.textField caretRectForPosition:self.textField.selectedTextRange.end];
    firstRectForRange = [self.textField firstRectForRange:self.textField.selectedTextRange];
    NSLog(@"caretRectForPosition:%@",NSStringFromCGRect(caretRectForPosition));
    NSLog(@"firstRectForRange:%@",NSStringFromCGRect(firstRectForRange));
    return YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)functionalBtn1:(id)sender {
    caretRectForPosition = [self.textField caretRectForPosition:self.textField.beginningOfDocument];
    firstRectForRange = [self.textField firstRectForRange:self.textField.selectedTextRange];
    NSLog(@"caretRectForPosition:%@",NSStringFromCGRect(caretRectForPosition));
    NSLog(@"firstRectForRange:%@",NSStringFromCGRect(firstRectForRange));
}

- (IBAction)functionalBtn2:(id)sender {
    UITextRange *aTextRange = self.textField.selectedTextRange;
    UITextPosition *headOfText = self.textField.beginningOfDocument;
    UITextPosition *tailOfText = self.textField.endOfDocument;
    NSLog(@"offsetFromPosition文首到光标%ld",(long)[self.textField offsetFromPosition:headOfText toPosition:aTextRange.start]);
    NSLog(@"offsetFromPosition文首到文尾%ld",(long)[self.textField offsetFromPosition:headOfText toPosition:tailOfText]);
    NSLog(@"offsetFromPosition选中的头到尾%ld",(long)[self.textField offsetFromPosition:aTextRange.start toPosition:aTextRange.end]);
    
    NSLog(@"comparePosition%ld",[self.textField comparePosition:aTextRange.start toPosition:aTextRange.end]);
}

- (IBAction)functionalBtn3:(id)sender {
    UITextRange *aTextRange = self.textField.selectedTextRange;
    
    UITextRange *newTextRange = [self.textField textRangeFromPosition:aTextRange.start toPosition:aTextRange.end];
    self.textField.selectedTextRange = [self.textField textRangeFromPosition:newTextRange.end toPosition:newTextRange.end];
}
static NSInteger deltaRight = 3;
static NSInteger deltaLeft = -3;
static NSInteger selection = 0;
- (IBAction)functionalBtn4:(id)sender {
    //测试向左选择3个
    selection += deltaLeft;
    [self makeSelectionWithOffset:selection];
    //测试左移3个
//    [self makeOffset:-3];
    /*
    //这里是测试光标右移3个
    NSInteger aOffset = 3;
    //注意这是光标没有选中任何东西时才行
    UITextPosition *caretPosition = self.textField.selectedTextRange.start;
    UITextPosition *targetPosition = [self.textField positionFromPosition:caretPosition
                                                                   offset:aOffset];
    UITextRange *newTextRange = [self.textField textRangeFromPosition:targetPosition
                                                           toPosition:targetPosition];
    self.textField.selectedTextRange = newTextRange;
     */
}
@end
