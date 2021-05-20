//
//  AppDelegate.swift
//  BirthdaysTracker
//
//  Created by Даниил Миронов on 23.03.2021.
//

import UIKit
import CoreData
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Вызывается при запуске приложения.
    // Если требуется, чтобы приложение делало что-то сразу после запуска,
    // напишите соответствующий код в этой функции.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Возвращает общий объект центра уведомлений пользователя для приложения
        let center = UNUserNotificationCenter.current()
        
        // Запросить у пользователя доступ к отправке уведомлений
        // 1) options (UNAuthorizationOptions):
        //    это байт из битов, которые описывают стиль уведомлений
        // 2) completionHandler: @escaping (Bool, Error?) -> Void
        //    замыкание, первый параметр которого хранит решение пользователя,
        //    а второй содержит информацию по ошибке
        
        center.requestAuthorization(options: [.alert, .sound],
        completionHandler: {(granted, error) in
           if granted {
               print("Разрешение на отправку уведомлений получено!")
           } else {
               print("В разрешении на отправку уведомлений отказано.")
        } })
        
        
        
        return true
    }
    
    
    // Вызывается, когда приложение выходит из активного состояния
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    
    // Вызывается, когда приложение перешло в фоновый режим,
    // где может продолжать какую-то работу,
    // однако может быть приостановлено в любой момент
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    
    // Вызывается, когда приложение выходит из фонового режима
    // и вот-вот перейдет в активное состояние
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    
    // Вызывается, когда приложение, работающее в активном или фоновом режиме,
    // закрывается. Оно не будет вызываться, если приложение приостановлено
    func applicationWillTerminate(_ application: UIApplication) {
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    // Необходимо для сохранения данных и получения к ним доступа
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BirthdaysTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

