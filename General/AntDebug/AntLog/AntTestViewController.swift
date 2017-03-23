//
//  AntTestViewController.swift
//  BingLiYun
//
//  Created by 刘伟 on 23/11/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit

class AntTestViewController: BaseViewController {

    fileprivate var dataListModels = [String]()
    
    fileprivate let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = COLOR_BACKGROUND_LIGHT_GRAY
        tableView.cellLineHidden()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationItem(withLeftObject: nil, rightObject: nil, titleObject: "测试页面")
        
        dataListModels.append("查看日志")
        dataListModels.append("查看事件日志")
        dataListModels.append("查看网络日志")
        dataListModels.append("Crash Log")
        dataListModels.append("编译信息")
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }
}

extension AntTestViewController: UITableViewDataSource, UITableViewDelegate
{
    // MARK : - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataListModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "InfoCell")
            cell?.accessoryType = .disclosureIndicator
        }
        
        let model = self.dataListModels[indexPath.row]
        
        cell?.textLabel?.text = model
        
        return cell!
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 0
        {
            let vc = AntLogViewController()
            APPCONTROLLER.pushViewController(vc)
        }
        
        if indexPath.row == 1
        {
            let vc = AntLogViewController()
            vc.filePath = ANT_LOG_CLICK_EVENT_FILE_PATH
            APPCONTROLLER.pushViewController(vc)
        }
        
        if indexPath.row == 2
        {
            let vc = AntLogViewController()
            vc.filePath = ANT_LOG_NETWORK_FILE_PATH
            APPCONTROLLER.pushViewController(vc)
        }
        
        if indexPath.row == 3
        {
            let vc = AntLogViewController()
            vc.filePath = ANT_LOG_CRASH_FILE_PATH
            APPCONTROLLER.pushViewController(vc)
        }
        if indexPath.row == 4
        {
            let vc = AntConfigurationViewController()
            APPCONTROLLER.pushViewController(vc)
        }
    }
    
}
