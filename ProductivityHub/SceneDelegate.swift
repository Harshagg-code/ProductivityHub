//
//  SceneDelegate.swift
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        
        // Load existing storyboard controllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tasksNav = storyboard.instantiateViewController(withIdentifier: "TasksNav")
        let calendarVC = storyboard.instantiateViewController(withIdentifier: "CalendarNav")
        let pomodoroVC = storyboard.instantiateViewController(withIdentifier: "PomodoroNav")
        let focusVC = storyboard.instantiateViewController(withIdentifier: "FocusNav")
        
        // Create Habits tab programmatically
        let habitVC = HabitListViewController()
        let habitNav = UINavigationController(rootViewController: habitVC)
        habitNav.tabBarItem = UITabBarItem(
            title: "Habits",
            image: UIImage(systemName: "checkmark.seal"),
            tag: 4
        )
        
        tabBar.viewControllers = [tasksNav, calendarVC, pomodoroVC, focusVC, habitNav]
        return tabBar
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
