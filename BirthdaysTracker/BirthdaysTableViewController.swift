//
//  BirthdaysTableViewController.swift
//  BirthdaysTracker
//
//  Created by Даниил Миронов on 25.03.2021.
//

import UIKit
import CoreData

class BirthdaysTableViewController: UITableViewController, AddBirthdayViewControllerDelegate {
    
    // Дни рождения
    var birthdays = [Birthday]()
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "d MMMM"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Вызывается после viewDidLoad() и перед каждым
        // появлением на экране View Controller;
        
        super.viewWillAppear(animated)
        
        // # Получаем объекты Birthday через запрос к контексту
        
        // Получаем делегат приложения
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Получаем контекст (данные) приложения
        let context = appDelegate.persistentContainer.viewContext
        
        // Формируем запрос на получение элементов Birthday
        // из CoreData (модели данных) с помощью контекста
        let fetchRequest: NSFetchRequest<Birthday> = Birthday.fetchRequest()
        
        // Формируем сортировки для объектов NSObject
        let sortDescriptor1 = NSSortDescriptor(key: "firstName", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "lastName", ascending: true)
        
        // Добавляем сформированные сортировки для запроса
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        do {
            
            // Получаем объекты через запрос к context
            try birthdays = context.fetch(fetchRequest)
        } catch {
            
            // ¯\_(ツ)_/¯
        }
        
        // Перегрузка отображения данных
        tableView.reloadData()
    }

    // MARK: - Table view data source

    // Сообщает Table View Controller, сколько Section он должен иметь;
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    // Сообщает Table View Controller, сколько рядов будет отображаться в каждом разделе
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return birthdays.count
    }

    // Вызывается для каждой ячейки, возвращает измененную (телом функции) ячейку
    //  - indexPath - структура, хранящая данные о ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Получение ячейки (исходя из идентификатора (из Storyboard) и indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCellIdentifier", for: indexPath)
        
        // Получить ДР из массива (индекс берется из ряда ячейки)
        let birthday = birthdays[indexPath.row]
        
        // Добавить текст в основную графу ячейки
        cell.textLabel?.text = (birthday.firstName ?? "") + " " + (birthday.lastName ?? "")
        
        // Добавить текст в дополнительную графу в ячейки
        cell.detailTextLabel?.text = dateFormatter.string(from: birthday.birthdate!)

        return cell
    }

    
    // Просит источник данных проверить, что данная строка доступна для редактирования
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    // Вызывается при изменении ячейки в Table View
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            
            let birthday = birthdays[indexPath.row]
            
            // Запрос на удалении ожидающих уведомлений об дне рождении
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [birthday.birthdayId!])
            
            // Получаем делегат приложения
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            // Получаем контекст (данные) приложения
            let context = appDelegate.persistentContainer.viewContext
            
            // Удаление объекта из модели данных (CoreData) с помощью контекста
            context.delete(birthday)
            
            // Удаление из массива birthdays
            birthdays.remove(at: indexPath.row)
            
            // Удаление из View Controller
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                
                try context.save()
            } catch {
                
                // ¯\_(ツ)_/¯
            }
        }
        
        

    }
    

    // MARK: - Navigation

    // Запускается при переходе к следующему View Controller (делегирующему объекту)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Параметры
    // 1. segue  – Объект, который подготавливает и выполняет визуальный переход
    //             между двумя контроллерами представления. Содержит информцию о
    //             контроллерах, участвующих в переходах
    // 2. sender – Объект, который инициировал сегмент. Этот параметр можно использовать
    //             для выполнения различных действий, основанных на том,
    //             какой элемент управления (или другой объект) начал переход.
        
        // Получаем следующий View Controller
        let navigationController = segue.destination as! UINavigationController
        // segue.destination           – Возвращает следующий View Controller в типе UIViewController
        //  as! UINavigationController – Делает нисходящие преобразование до UINavigationController,
        //                               т.к. именно он является следующим View Controller'ом
        
        
        // Тоже самое, что и строка выше, но для AddBirthdayViewController
        let addBirthdayViewController = navigationController.topViewController as! AddBirthdayViewController
        
        // Говорим AddBirthdayViewController, что BirthdaysTableViewController – его делегат
        addBirthdayViewController.delegate = self
    }

}
