import UIKit
import PhoenixKitsuCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  private let decoder = JSONDecoder()
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    if let root = window?.rootViewController as? UITabBarController {
      handleInjection(for: root)
    }
    return true
  }
  
  private func handleInjection(for rootViewController: UITabBarController) {
    for tab in rootViewController.viewControllers ?? [] {
      if let nav = tab as? UINavigationController {
        handleInjection(for: nav)
      }
    }
  }
  private func handleInjection(for navigationController: UINavigationController) {
    for viewController in navigationController.viewControllers {
      injectKitsuHandler(into: viewController)
      injectImageFetcher(into: viewController)
      injectAuthenticationUtility(into: viewController)
    }
  }
  
  private func injectKitsuHandler(into viewController: UIViewController) {
    let kitsuHandler = KitsuHandler(decoder: decoder, session: nil)
    if let item = viewController as? HasKitsuHandler { item.setKitsuHandler(kitsuHandler) }
  }
  private func injectImageFetcher(into viewController: UIViewController) {
    let imageFetcher = ImageFetcher()
    if let item = viewController as? HasImageFetcher { item.setImageFetcher(imageFetcher) }
  }
  private func injectAuthenticationUtility(into viewController: UIViewController) {
    let authenticationUtility = AuthenticationUtility()
    if let item = viewController as? HasAuthenticationUtility { item.setAuthenticationUtility(authenticationUtility) }
  }

  func applicationWillResignActive(_ application: UIApplication) {
    /** 
     Sent when the application is about to move from active to inactive state. This can occur for 
     certain types of temporary interruptions (such as an incoming phone call or SMS message) or 
     when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering 
     callbacks. Games should use this method to pause the game.
     */
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    /**
     Use this method to release shared resources, save user data, invalidate timers, and store 
     enough application state information to restore your application to its current state in case 
     it is terminated later.
     If your application supports background execution, this method is called instead of 
     applicationWillTerminate: when the user quits.
     */
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    /** 
     Called as part of the transition from the background to the active state; here you can undo 
     many of the changes made on entering the background.
     */
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    /**
     Restart any tasks that were paused (or not yet started) while the application was inactive. If 
     the application was previously in the background, optionally refresh the user interface.
     */
  }

  func applicationWillTerminate(_ application: UIApplication) {
    /** Called when the application is about to terminate. Save data if appropriate. See also 
     applicationDidEnterBackground:.
     */
  }
}
