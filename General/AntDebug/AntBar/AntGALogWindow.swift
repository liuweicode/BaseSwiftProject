//
//  AntGALogWindow.swift
//  AntDebug
//
//  Created by 刘伟 on 16/11/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit

class AntGALogObject: NSObject {
    var category: String = ""
    var action: String = ""
    var label: String = ""
    var value: Int = 0
    var extras: String = ""
    var time: Date = Date()
}

let kGALogCount = 20
let kGALogWindowHeight:CGFloat = 200
let kGALogFontSize:CGFloat = 14
var gaLogWindow: AntGALogWindow?

class AntGALogWindow: UIView {
    
    var timer: Timer?
    
    lazy var gaArray = [AntGALogObject]()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.alwaysBounceVertical = true
        return tableView
    }()
    
    private init() {
        super.init(frame: CGRect.zero)
        settingLayout()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        settingLayout()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func instance() -> AntGALogWindow
    {
        if gaLogWindow == nil
        {
            let screenSize = UIScreen.main.bounds.size
            let y = screenSize.height - kGALogWindowHeight - 50
            gaLogWindow = AntGALogWindow(frame: CGRect(x: 0, y: y, width: screenSize.width, height: kGALogWindowHeight))
            gaLogWindow?.isHidden = true
        }
        return gaLogWindow!
    }
    
    class func closeInstance()
    {
        gaLogWindow = nil
    }
    
    override var isHidden: Bool
    {
        get{
            return super.isHidden
        }
        set{
            super.isHidden = newValue
            if newValue
            {
                self.removeFromSuperview()
            }else{
                if self.superview == nil {
                    let window = UIApplication.shared.keyWindow
                    window?.addSubview(self)
                }
                self.superview!.bringSubview(toFront: self)
            }
        }
    }
    
    
    private func settingLayout() {
        
        self.alpha = 0.3
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func showGAEvent(withCategory ca:String?, action act:String?, label lab:String?, value val:Int?, extras ext:String?)
    {
        let obj = AntGALogObject()
        obj.category = ca ?? ""
        obj.action = act ?? ""
        obj.label = lab ?? ""
        obj.value = val ?? 0
        obj.extras = ext != nil ? ext!.replacingOccurrences(of: "\n", with: "") : ""
        obj.time = AntDateUtil.getCurrentDate()
        
        gaArray.insert(obj, at: 0)
        
        while gaArray.count > kGALogCount {
            gaArray.removeLast()
        }
        
        if !self.isHidden
        {
            self.isHidden = false
            self.alpha = 0.8
            self.backgroundColor = UIColor(white: 1, alpha: 0.8)
            self.isUserInteractionEnabled = true
            
            tableView.reloadData()
            if !tableView.isDragging
            {
                self.startTimer()
                self.tableView.scrollToRow(at:IndexPath(row: 0, section: 0) , at: UITableViewScrollPosition.top, animated: false)
            }
        }
    }
}

extension AntGALogWindow: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
            cell?.selectionStyle = .none
            
            let label = UILabel()
            label.tag = 1
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: kGALogFontSize)
            cell?.contentView.addSubview(label)
            
            label.snp.makeConstraints({ (make) in
                make.edges.equalTo(cell!.contentView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            })
        }
        
        guard let label = cell!.viewWithTag(1) as? UILabel else{ return cell! }
        
        let obj = self.gaArray[indexPath.row]
        let totalString = self.totalString(withCategory: obj.category, action: obj.action, label: obj.label, value: obj.value, extras: obj.extras)
        label.text = totalString
        
        return cell!
    }
    
    func totalString(withCategory ca:String, action act:String, label lab:String, value val:Int, extras ext:String) -> String
    {
        var totalString = "c:\(ca)"
        
        if act.lengthOfBytes(using: String.Encoding.utf8) > 0
        {
            totalString += "a:\(act)"
        }
        
        if lab.lengthOfBytes(using: String.Encoding.utf8) > 0
        {
            totalString += "a:\(lab)"
        }
        
        totalString += "v:\(val)"
        
        if ext.lengthOfBytes(using: String.Encoding.utf8) > 0
        {
            totalString += "e:\(ext)"
        }
        
        return totalString
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let obj = self.gaArray[indexPath.row]
        
        let totalString = self.totalString(withCategory: obj.category, action: obj.action, label: obj.label, value: obj.value, extras: obj.extras)
        let size = StringUtil.sizeWith(text: totalString, font: UIFont.systemFont(ofSize: kGALogFontSize), maxSize: CGSize(width: self.tableView.frame.size.width - 10, height: CGFloat(MAXFLOAT)))
        return size.height + 20
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.stopTimer()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.startTimer()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startTimer()
    }
}


extension AntGALogWindow
{
    func changeToHide()
    {
        timer?.invalidate()
        timer = nil
        
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.3
            self.backgroundColor = UIColor(white: 1, alpha: 0.3)
            
            for cell in self.tableView.visibleCells
            {
                cell.backgroundColor = UIColor.clear
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.layer.borderWidth = 0
            }
        }, completion: { (finished) in
        })
        
    }
    
    func startTimer()
    {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeToHide), userInfo: nil, repeats: false)
    }
    
    func stopTimer()
    {
        timer?.invalidate()
        timer = nil
    }
}
















