//
//  ApiTestViewController.swift
//  BaseSwiftProject
//
//  Created by 刘伟 on 2017/4/21.
//  Copyright © 2017年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class ApiTestViewController: BaseViewController {
    
    fileprivate var dataListModels = [String]()
    
    fileprivate let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = COLOR_BACKGROUND_LIGHT_GRAY
        tableView.cellLineHidden()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationItem(withLeftObject: nil, rightObject: nil, titleObject: "API 测试")
        
        dataListModels.append("登录")
        dataListModels.append("活动详情")
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }
}

extension ApiTestViewController: UITableViewDataSource, UITableViewDelegate
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
            doLoginRequest()
        }
        
        if indexPath.row == 1
        {
           viewActivity()
        }
        
        if indexPath.row == 2
        {
           
        }
        
        if indexPath.row == 3
        {
           
        }
        
        if indexPath.row == 4
        {
           
        }
    }
    
}

extension ApiTestViewController
{
    func doLoginRequest()
    {
        ToastView.showProgressLoading()
        
        let param: [String : Any] = [
            "phone": "18521531024",
            "code": "111111"
        ];
        
        _ = NC_POST(self).send(params: param, url: API(service: API_USER_SIGN, notEncrypt: true, isPrintSql: true), successBlock: { (message) in
            
            ToastView.showSuccess("登录成功")
            
        }) { (message) in
            ToastView.showError(message.networkError!)
        }
    }
    
    func viewActivity()
    {
        ToastView.showProgressLoading()
        
        let param: [String : Any] = [
            "id": 1
        ];
        
        _ = NC_POST(self).send(params: param, url: API(service: "Activity.view", notEncrypt: true, isPrintSql: true), successBlock: { (message) in
            
            ToastView.showSuccess("成功")
            
        }) { (message) in
            ToastView.showError(message.networkError!)
        }
    }
}
