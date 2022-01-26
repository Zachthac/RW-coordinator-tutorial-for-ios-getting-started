import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private var applicationCoordinator: ApplicationCoordinator?  // 1

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions:
                     [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let window = UIWindow(frame: UIScreen.main.bounds)
    let applicationCoordinator = ApplicationCoordinator(window: window) // 2

    self.window = window
    self.applicationCoordinator = applicationCoordinator

    applicationCoordinator.start()  // 3
    return true
  }
}
