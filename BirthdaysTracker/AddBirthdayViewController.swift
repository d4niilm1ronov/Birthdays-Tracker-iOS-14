//
//  ViewController.swift
//  BirthdaysTracker
//
//  Created by Даниил Миронов on 23.03.2021.
//

import UIKit
import CoreData
import UserNotifications

protocol AddBirthdayViewControllerDelegate {
    
    func viewWillAppear(_ animated: Bool)
}


class AddBirthdayViewController: UIViewController {
        
    // ✍️ Чтобы использовать элементы View Controller как свойства класса,
    //    1) Перед var/let добавить ключевое слово @IBOutlet
    //    2) Связть элемент с свойством в Storyboard
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    
    var delegate: AddBirthdayViewControllerDelegate?
    
    
    override func viewDidLoad() {
        // Вызывается сразу после создания View Controller,
        // но перед его появлением на экране.
        // Используется для изначальной настройки представления,
        // которую вы менять не планируете.
        // ⚠️ Обязательный метод
        
        super.viewDidLoad()

        birthdatePicker.maximumDate = Date()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        // Вызывается после viewDidLoad() и перед каждым
        // появлением на экране View Controller;
        
        super.viewWillAppear(animated)
        
        
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
    // Аналогичен viewWillAppear(_:), за исключением того,
    // что он вызывается после того, как покажется View Controller
    
    super.viewDidAppear(animated)
    }
    */
    
    /*
    override func viewWillDisappear(_ animated: Bool) {
        // Вызывается перед исчезновением View Controller
    }
    */
    
    // ✍️ Чтобы связать метод с элементом View Controller:
    //    1) Перед func добавить ключевое слово @IBAction (Interface Build Action)
    //    2) Задать параметр (любое имя) с пустой меткой и типом UI-элемента
    //    3) Связать функцию с UI-элементом (например, UIBarButtonItem) в Storyboard
    //       (через control-меню, раздел Received Action)
    @IBAction func saveTapped (_ sender: UIButton) {
        
        /*
         
         📝 Это старый способ взаимодействия с данными через делегат
        
        // Формируем объект Birthday
        let newBirthday = Birthday(firstName: firstNameTextField.text ?? "", lastName: lastNameTextField.text ?? "", birthdate: birthdatePicker.date)
        
        // (Функция протокола AddBirthdayVCDelegate реализованная делегатом BirthdaysTableVC)
        delegate?.addBirthdayViewController(didAddBirthday: newBirthday)
 
        */
        
        
        // Получаем делегат приложения
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Получаем контекст приложения
        let context = appDelegate.persistentContainer.viewContext
        
        // Создаем пустой объект типа Birthday в context (в модели данных)
        let newBirthday = Birthday(context: context)
        
        // Меняем значения у объекта из context
        newBirthday.birthdate  = birthdatePicker.date
        newBirthday.firstName  = firstNameTextField.text ?? ""
        newBirthday.lastName   = lastNameTextField.text ?? ""
        newBirthday.birthdayId = UUID().uuidString
        
        do {
            
            // Сохраняем контекст
            try context.save()
            
        } catch {
            
        }
        
        // Нужно для обновления экрана со списком дней рождений
        delegate?.viewWillAppear(true)
        
        // Объект хранящий данные для будущего уведомления (полезная нагрузка)
        let newNotification = UNMutableNotificationContent()
        
        // Задаём текст для уведомления
        newNotification.body = "Сегодня \(firstNameTextField.text ?? "") \(lastNameTextField.text ?? "") празднует день рождения!"
        
        // Задаём звук для уведомления
        newNotification.sound = UNNotificationSound.default
        
        // Объект для инкапсулирования компонентов для представления (в будущем) даты
        // В первом аргументе указываются значения, которые надо захватить из второго аргумента
        var dateComponents = Calendar.current.dateComponents([.month, .day], from: newBirthday.birthdate!)
        
        // Задаем время (для уведомления)
        let curDateComponents = Calendar.current.dateComponents([.minute, .hour], from: Date())
        
        dateComponents.hour = curDateComponents.hour
        dateComponents.minute = curDateComponents.minute! + 2
        
        // Делаем тригер для уведомления из компоновщика свойств даты (DateComponents)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Делаем объект запроса (UNNotificationRequest) на добавление уведомления
        // (с помощью UNMutableNotificationContent и UNCalendarNotificationTrigger(DateComponents) )
        let request = UNNotificationRequest(identifier: newBirthday.birthdayId!, content: newNotification, trigger: trigger)
        
        // Получаем ссылку на Центр уведомлений
        let center = UNUserNotificationCenter.current()
        
        // Добавляем уведомление
        center.add(request, withCompletionHandler: nil)
        
        
        
        // Закрытие окна
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped (_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
}


