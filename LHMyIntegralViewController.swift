//
//  LHMyIntegralViewController.swift
//  LHMyIntegralViewController
//
//  Created by Corotata on 2023/3/29.
//
//

import UIKit
import QuickSwiftExtensions
import LHThemeModule

// MARK: Life Cycle
class LHMyIntegralViewController: UIViewController,StoryboardInitialAble {

    lazy var viewModel:LHMyIntegralViewModel = {
        let viewModel = LHMyIntegralViewModel()
        return viewModel
    }()
    
    lazy var integralHeaderView: LHMyIntegralHeaderView = {
        let integralHeaderView = LHMyIntegralHeaderView.quick.viewFromNib()
        integralHeaderView.delegate = self
        return integralHeaderView
    }()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.quick.registerHeaderFooterViewByNib(LHSettingTagHeaderView.self)
        }
    }
    
    @IBOutlet weak var gradientView: LHGradientView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        integralHeaderView.integralValue = AppContext.instance.homePageInfo?.user?.wallet?.goldCoin
    }
    
    deinit {
        #if DEBUG
        print("\(self) is dealloc")
        #endif
    }
    
}

// MARK: Init
extension LHMyIntegralViewController {
    /// 类初始化方法
    static func viewController() -> LHMyIntegralViewController {
        let viewController = LHMyIntegralViewController.quick_instantiateInitialViewController()
        viewController.viewModel = LHMyIntegralViewModel()
        return viewController
    }
}

// MARK: BindUI
extension LHMyIntegralViewController {
    /// 添加UI绑定
    func bindUI() {
        viewModel.requester.bind(to: self.tableView)
    }
    
}



// MARK: Handle action method
extension LHMyIntegralViewController {

    
}


// MARK: SetupUI
extension LHMyIntegralViewController {
    /// 初始化导航条
    func setupNavigationBar() {
        
    }
    
    /// 初始化纯代码写入的UI或者设置属性、添加代理等
    func setupView() {
        tableView.tableHeaderView = integralHeaderView
        tableView.backgroundColor = UIColor.clear
        tableView.dataSource = self
    }
    
    /// 初始化纯代码UI约束
    func setupConstraints() {
        
    }
    
    /// 添加本地化的内容
    func setupLocalizableString() {
        
    }

    /// 初始化UI
    func setupUI() {
        setupNavigationBar()
        setupView()
        setupConstraints()
        setupLocalizableString()
    }
}


// MARK: - UITableViewDataSource
extension LHMyIntegralViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.requester.models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let section = viewModel.requester.models[section]
        return section.tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = viewModel.requester.models[indexPath.section].tasks[indexPath.row]
        
        let cell = tableView.quick.dequeueReusableCell(LHIntegralTaskCell.self, indexPath: indexPath)
        if indexPath.row == 0 {
            cell.topMarginConstraint.constant = 20
            cell.bottomMarginConstraint.constant = 10
        }else if indexPath.row == viewModel.requester.models[indexPath.section].tasks.count - 1{
            cell.bottomMarginConstraint.constant = 20
            cell.topMarginConstraint.constant = 10
        }else {
            cell.topMarginConstraint.constant = 10
            cell.bottomMarginConstraint.constant = 10
        }
        
        cell.titleLabel.text = task.integralTaskType.title
        
        cell.contentLabel.text = "积分 +\(task.goldCoins)"
        
        let isFinish = task.integralTaskType.isFinished(userEntity: viewModel.integralConfigDto?.userEntity)
        
        cell.toFinishButton.isEnabled = !isFinish
        if isFinish {
            cell.toFinishButton.setTitle(task.integralTaskType.buttonTitle(isFinish: true), for: .disabled)
        }else {
            cell.toFinishButton.setTitle(task.integralTaskType.buttonTitle(isFinish: false), for: .normal)
        }
        
        
        return cell
    }
}

extension LHMyIntegralViewController: LHMyIntegralHeaderViewDelegate {
    func myIntegralHeaderViewDidClockInButtonClick() {
        print("点击了签到")
    }
    
    func myIntegralHeaderViewDidExchangeButtonClick(){
        print("点击了兑换")
    }
    
    func myIntegralHeaderViewDidIntegralDetailButtonClick(){
        print("点击了积分详情")
    }
    
    func myIntegralHeaderViewDidRuleButtonClick(){
        print("点击了规则说明")
    }
}

extension LHMyIntegralViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.quick.dequeueReusableHeaderFooterView(LHSettingTagHeaderView.self)
        
        headerView.titleLabel.textColor = LHThemeConfigure.color_Text_333333
        headerView.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        headerView.backgroundColor = UIColor.clear
        if section == 0 {
            headerView.title = "新手任务"
        }else {
            headerView.title = "日常任务"
        }
       
        return headerView
    }
}
