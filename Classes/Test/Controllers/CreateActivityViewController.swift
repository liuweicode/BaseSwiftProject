//
//  CreateActivityViewController.swift
//  BaseSwiftProject
//
//  Created by 刘伟 on 2017/4/21.
//  Copyright © 2017年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol SwiftJavaScriptDelegate: JSExport
{
    func enterOneLineText(_ id: String, _ originText: String)
    func enterMultipleLineText(_ id: String, _ originText: String)
    func pickDate(_ id: String, _ originText: String)
    func saveTemplate(_ title: String, _ time: String, _ address: String, _ introduce: String)
}

@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate {
    
    weak var controller: CreateActivityViewController?
    weak var jsContext: JSContext?
    
    func enterOneLineText(_ id: String, _ originText: String)
    {
        print("==>：id = \(id), originText = \(originText)")
        // TODO 调用文本输入框
    }
    
    func enterMultipleLineText(_ id: String, _ originText: String)
    {
        print("==>：id = \(id), originText = \(originText)")
        
        DispatchQueue.main.safeAsync {
            let tvController = TextViewViewController()
            tvController.elementId = id
            tvController.elementOriginVal = originText.replacingOccurrences(of: "<br>", with: "\n")
            tvController.delegate = self.controller
            let navi = BaseNavigationController(rootViewController: tvController)
            self.controller?.present(navi, animated: true, completion: nil)
        }
    }
    
    func pickDate(_ id: String, _ originText: String) {
        print("==>：id = \(id), originText = \(originText)")
        // TODO 调用日期选择控件
    }
    
    func saveTemplate(_ title: String, _ time: String, _ address: String, _ introduce: String) {
        print("\(title) \(time), \(address), \(introduce)")
        // TODO 调用保存模板接口
    }
}

class CreateActivityViewController: BaseViewController {

    var jsContext: JSContext?
    
    var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = COLOR_WHITE
        webView.scrollView.bounces = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR_WHITE
        self.navigationController?.isNavigationBarHidden = false
        
        self.setNavigationItem(withLeftObject: nil, rightObject: nil, titleObject: "创建")
        
        webView.delegate = self
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        doLoadTemplateRequest()
    }
}

extension CreateActivityViewController: UIWebViewDelegate
{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        ANT_LOG_INFO("webViewDidStartLoad")
        ToastView.showProgressLoading()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        ANT_LOG_INFO("webViewDidFinishLoad")
        
        ToastView.hide()
        
        // 禁用长按事件
        self.webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitUserSelect='none';")
        self.webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitTouchCallout='none';")
        
        guard let context = self.webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else{  return }
        
        self.jsContext = context
        
        let jsModel = SwiftJavaScriptModel()
        jsModel.controller = self
        jsModel.jsContext = self.jsContext
        
        self.jsContext!.setObject(jsModel, forKeyedSubscript: "WebViewJavascriptBridge" as (NSCopying & NSObjectProtocol)!)
        
        if let curUrl = self.webView.request?.url?.absoluteString
        {
            self.jsContext!.evaluateScript(curUrl)
        }
        
        self.jsContext!.exceptionHandler = { (context, exception) in
            //JSContext.current().exception = exception
            print("报错了:\(String(describing: exception?.description))")
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        ANT_LOG_INFO("didFailLoadWithError")
        
        ToastView.hide()
        
        let ok = AlertViewButtonItem(inLabel: "确定")
        let alertView = AlertView(title: "提示", message: "网络连接失败", cancelButtonItem: ok, otherButtonItems: nil)
        alertView.show()
    }
}

extension CreateActivityViewController: TextViewViewControllerDelegate
{
    func onInputCompleted(_ elementId: String, _ elementOriginValue: String, _ newValue: String) {
        let jsHandlerFunc = self.jsContext?.objectForKeyedSubscript("_native_enterMultipleLineTextCompleted")
        let html = newValue.replacingOccurrences(of: "\n", with: "<br>")
        _ = jsHandlerFunc?.call(withArguments: [elementId,html])
    }
}

extension CreateActivityViewController
{
    func doLoadTemplateRequest()
    {
        ToastView.showProgressLoading()
        
        let param: [String : Any] = [
            "id": 1
        ];
        
        _ = NC_POST(self).send(params: param, url: API(service: "Template.view", notEncrypt: true, isPrintSql: true), successBlock: { (message) in
            ToastView.hide()
            let model = TemplateDetailModel(json: message.responseJson["data"]["responsedata"])
            self.webView.loadHTMLString(model.template_content, baseURL: nil)
            
        }) { (message) in
            ToastView.showError(message.networkError!)
        }
    }
}
