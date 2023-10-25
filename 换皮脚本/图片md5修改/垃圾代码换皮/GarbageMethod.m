{
    int qdd1 = 0;
    if (qdd1 == 1) {
        // gradient
        CAGradientLayer *qdd_gl1 = [CAGradientLayer layer];
        qdd_gl1.frame = CGRectMake(1,0,374,967);
        qdd_gl1.startPoint = CGPointMake(0.5, 0);
        qdd_gl1.endPoint = CGPointMake(0.5, 1);
        qdd_gl1.colors = @[(__bridge id)[UIColor colorWithRed:30/255.0 green:29/255.0 blue:44/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1.0].CGColor];
        qdd_gl1.locations = @[@(0), @(1.0f)];
    }
}
{
    int qdd2 = 0;
    if (qdd2 == 1) {
        UILabel *qdd_label2 = [[UILabel alloc] init];
        qdd_label2.frame = CGRectMake(58,173,258,72);
        qdd_label2.numberOfLines = 0;

        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"123124327482745" attributes: @{NSFontAttributeName: [UIFont fontWithName:@"Gilroy" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];

        qdd_label2.attributedText = string;
        qdd_label2.textAlignment = NSTextAlignmentLeft;
        qdd_label2.alpha = 1.0;
    }
}
{
    int qdd3 = 0;
    if (qdd3 == 1) {
        UIView *qdd_view3 = [[UIView alloc] init];
        qdd_view3.frame = CGRectMake(0,394,375,418);
        qdd_view3.layer.backgroundColor = [UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1.0].CGColor;
        qdd_view3.layer.cornerRadius = 16;
    }
}
{
    int qdd4 = 0;
    if (qdd4 == 1) {
        UITableView *qdd_tableView4 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        qdd_tableView4.backgroundColor = UIColor.whiteColor;
        qdd_tableView4.delegate = self;
        qdd_tableView4.dataSource = self;
        qdd_tableView4.showsVerticalScrollIndicator = NO;
        qdd_tableView4.showsHorizontalScrollIndicator = NO;
        qdd_tableView4.separatorStyle = UITableViewCellSeparatorStyleNone;
        qdd_tableView4.estimatedSectionFooterHeight = 0;
        qdd_tableView4.estimatedSectionHeaderHeight = 0;
        qdd_tableView4.estimatedRowHeight = 0;
    }
}
{
    int qdd5 = 0;
    if (qdd5 == 1) {
        UIView *qdd_view5 = [[UIView alloc] init];
        qdd_view5.frame = CGRectMake(100,112,174,34);

        qdd_view5.layer.backgroundColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0].CGColor;

        // blur
        UIBlurEffect *qdd_blurEffect5 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:qdd_blurEffect5];
        visualView.frame = CGRectMake(100,112,174,34);
        qdd_view5.layer.cornerRadius = 23;
    }
    
}
{
    int qdd6 = 0;
    if (qdd6 == 1) {
        UIImageView *qdd_imageView6 = [[UIImageView alloc] init];
        qdd_imageView6.frame = CGRectMake(65,484,50,50);
        qdd_imageView6.image = [UIImage imageNamed:@"位图.png"];
    }
}
{
    int qdd7 = 0;
    if (qdd7 == 1) {
        UIView *qdd_view7 = [[UIView alloc] init];
        qdd_view7.frame = CGRectMake(314,461,30,30.1);


        // gradient
        CAGradientLayer *qdd_gl7 = [CAGradientLayer layer];
        qdd_gl7.frame = CGRectMake(314,461,30,30.1);
        qdd_gl7.startPoint = CGPointMake(0.12, 0.06);
        qdd_gl7.endPoint = CGPointMake(0.91, 0.96);
        qdd_gl7.colors = @[(__bridge id)[UIColor colorWithRed:249/255.0 green:116/255.0 blue:122/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:84/255.0 blue:174/255.0 alpha:1.0].CGColor];
        qdd_gl7.locations = @[@(0), @(1.0f)];
        qdd_view7.layer.shadowColor = [UIColor colorWithRed:214/255.0 green:77/255.0 blue:89/255.0 alpha:1.0].CGColor;
        qdd_view7.layer.shadowOffset = CGSizeMake(0,0);
        qdd_view7.layer.shadowOpacity = 1;
        qdd_view7.layer.shadowRadius = 2;
    }
}
{
    int qdd8 = 0;
    if (qdd8 == 1) {
        UIButton *qdd_button8 = [[UIButton alloc] init];
        qdd_button8.backgroundColor = UIColor.whiteColor;
        qdd_button8.layer.cornerRadius = 22;
        qdd_button8.layer.borderWidth = 1;
        qdd_button8.layer.borderColor = UIColor.whiteColor.CGColor;
        [qdd_button8 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
}
