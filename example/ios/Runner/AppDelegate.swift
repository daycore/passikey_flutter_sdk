import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
    let navigationController = UINavigationController(rootViewController: flutterViewController);
    navigationController.setNavigationBarHidden(true, animated: false);
        
    self.window = UIWindow(frame: UIScreen.main.bounds);
    self.window.rootViewController = navigationController;
    self.window.makeKeyAndVisible();

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
