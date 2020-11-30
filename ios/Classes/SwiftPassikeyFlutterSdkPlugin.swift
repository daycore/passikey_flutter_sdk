import Flutter
import UIKit
import PASSIKEYauth

public class SwiftPassikeyFlutterSdkPlugin: NSObject, FlutterPlugin, FlutterPassikeyDelegate {
    
    private var loginMethodCall: FlutterMethodCall?
    private var loginResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "passikey_flutter_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftPassikeyFlutterSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch(call.method) {
        
        case "Passikey#init":
            PassikeyManager.getInstance().setAppScheme("pk\(PassikeyManager.getInstance().getClientId())")
            break
            
        case "Passikey#login":
            if let args = call.arguments as? Dictionary<String, Any>,
               let stateToken = args["stateToken"] as? String {
                
                if let window = UIApplication.shared.windows.filter({ (w) -> Bool in return w.isHidden == false}).first{
                    if let controller : UINavigationController = window.rootViewController as? UINavigationController {
                        self.loginMethodCall = call
                        self.loginResult = result
                        
                        let newController = PassikeyTemporaryViewController()
                        newController.passikeyDelegate = self
                        controller.pushViewController(newController, animated: false)

                        PassikeyManager.getInstance().login(newController, withStateToken: stateToken)
                    } else {
                        result(FlutterError.init(code: "passikey_sdk", message: "rootViewController가 UINavigationController로 설정해주세요", details: nil))
                    }
                }
            } else {
                result(FlutterError.init(code: "passikey_sdk", message: "stateToken을 설정해주세요", details: nil))
            }
            break
            
        case "Passikey#getClientId":
            result(PassikeyManager.getInstance().getClientId())
            break
            
        case "Passikey#getSecretKey":
            result(PassikeyManager.getInstance().getSecretKey())
            break
            
        case "Passikey#startStore":
            PassikeyManager.getInstance().startStore()
            result(true)
            break
            
        case "Passikey#isInstalledPassikey":
            result(PassikeyManager.getInstance().isInstalledPassikey())
            break
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == PassikeyManager.getInstance().getAppScheme() {
            if let presentedController =  UIApplication.shared.keyWindow?.rootViewController {
                let isPassikeyWebViewController = presentedController.isKind(of: PassikeyWebViewController.self)
                if isPassikeyWebViewController {
                    guard let passikeyWebViewController = presentedController as? PassikeyWebViewController else { return true }
                    
                    let strParsingDic = PassikeyManager.getInstance().passikeyResultParsing(url)
                    passikeyWebViewController.resultProcess(strParsingDic)
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    public func onCallback(_ successAuthValue: NSMutableDictionary?, withErrInfo errInfo: NSMutableDictionary?) {
        if let window = UIApplication.shared.windows.filter({ (w) -> Bool in return w.isHidden == false}).first{
            if let controller : UINavigationController = window.rootViewController as? UINavigationController {
                controller.popToRootViewController(animated: false)
            }
        }

        guard let loginResult = self.loginResult else { return }
        
        if successAuthValue != nil {
            if PassikeyManager.getInstance().getReciveStateToken().isEmpty {
                loginResult(FlutterError.init(code: "passikey_sdk", message: "상태 토큰이 비어있습니다", details: nil))
                return
            } else if PassikeyManager.getInstance().getReciveStateToken() != PassikeyManager.getInstance().getStateToken() {
                loginResult(FlutterError.init(code: "passikey_sdk", message: "로그인 요청시 전달한 상태토큰 불일치", details: nil))
                return
            } else if PassikeyManager.getInstance().getPartnerToken().isEmpty {
                loginResult(FlutterError.init(code: "passikey_sdk", message: "파트너 토큰이 비어있습니다", details: nil))
                return
            }
            loginResult([
                "statToken":PassikeyManager.getInstance().getReciveStateToken(),
                "ptnToken":PassikeyManager.getInstance().getPartnerToken()
            ])
        } else {
            var message: String?
            
            if errInfo?.object(forKey:"result_code") != nil {
                if errInfo?.object(forKey:"err_code") != nil {
                    message = "ResultValue:\(errInfo?.object(forKey:"result_code") ?? "") (\(errInfo?.object(forKey:"err_code") ?? ""))"
                } else {
                    message = "ResultValue:\(errInfo?.object(forKey:"result_code") ?? "")"
                }
            } else if errInfo?.object(forKey:"result_code") == nil &&  errInfo?.object(forKey:"err_code") != nil {
                message = "ResultValue:\(errInfo?.object(forKey:"err_code") ?? "")"
            } else if errInfo?.object(forKey:"code") != nil {
                message = "ResultValue:\(errInfo?.object(forKey:"code") ?? "")"
            }
            
            loginResult(FlutterError.init(code: "passikey_sdk", message: message ?? "로그인에 실패하였습니다", details: errInfo))
        }
    }
}

protocol FlutterPassikeyDelegate {
    func onCallback(_ successAuthValue: NSMutableDictionary?, withErrInfo errInfo: NSMutableDictionary?)
}

class PassikeyTemporaryViewController: UIViewController, PassikeyWebViewControllerDelegate {
    
    var passikeyDelegate: FlutterPassikeyDelegate? = nil
    
    func onCallback(_ successAuthValue: NSMutableDictionary, withErrInfo errInfo: NSMutableDictionary) {
        self.passikeyDelegate?.onCallback(successAuthValue, withErrInfo: errInfo)
    }
}
