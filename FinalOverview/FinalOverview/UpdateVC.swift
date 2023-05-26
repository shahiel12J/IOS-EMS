//
//  UpdateVC.swift
//  FinalOverview
//
//  Created by DA MAC M1 126 on 2023/05/25.
//

import UIKit

class UpdateVC: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var salary: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var cellNumber: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var btnRole1: UIButton!
    
    var apiData = [Todo]()
    var empId: Int = 0
    
    var cellSet: String?
    var roleSet: String?
    var salarySet: Int = 0
    var firstNameSet: String?
    var lastNameSet: String?
    var emailSet: String?
    
    var isUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRole1.addAction(UIAction(title: "", handler: { (_) in
                    //print("Default")
                    self.btnRole1.menu = self.addMenuItem()

                    //self.addMenuItem()
                }), for: .touchUpInside)
                btnRole1.showsMenuAsPrimaryAction = true
                btnRole1.menu = addMenuItem()
        // Do any additional setup after loading the view.
        
        firstName.text = firstNameSet
        lastName.text = lastNameSet
        salary.text = String(salarySet)
        cellNumber.text = cellSet
        role.text = roleSet
        email.text = emailSet

    }
    
    
    func addMenuItem() -> UIMenu {
            let menuItems = UIMenu(title: "", options: .displayInline, children: [

                UIAction(title: "IT", handler: { (_) in
                    print("IT")
                    self.role.text = "IT"

                }),
                UIAction(title: "Logistics", handler: { (_) in
                    print("Logistics")
                    self.role.text = "Logistics"

                }),
                UIAction(title: "Supply Chain", handler: { (_) in
                    print("Supply Chain")
                    self.role.text = "Supply Chain"

                }),
                UIAction(title: "HR", handler: { (_) in
                    print("HR")
                    self.role.text = "HR"

                })

                ])
            return menuItems
            // Do any additional setup after loading the view.
        }

    @IBAction func btnUpdate(_ sender: Any) {
        let validateEmail = validateEmail(enteredEmail: email.text!)
        let validatePhone = validatePhone(enteredPhone: cellNumber.text!)
        let validateName = validName(enteredName: firstName.text!)
        let validateSurname = validName(enteredName: lastName.text!)
        let validateRole = validName(enteredName: role.text!)
        let validateSalary = validSalary(enteredSalary:salary.text!)
        
                                           
        if(validateName == false)
        {
            updateAlert(message: "Enter Name", title: "Enter Name")
        }
        if(validateSurname == false)
        {
            updateAlert(message: "Enter Surname", title: "Enter Surname")
        }
        if(validateEmail == false)
        {
            updateAlert(message: "Enter correct email", title: "Invalid email")
        }
        if(validatePhone == false)
        {
            updateAlert(message: "Enter correct number", title: "Invalid number")
        }
        if(validateRole == false)
        {
            updateAlert(message: "Enter Role", title: "Enter Role")
        }
        if(validateSalary == false)
        {
            updateAlert(message: "Enter correct salary", title: "Enter Correct Salary")
        }
        else
        {
            
            let newEmp: Todo = Todo(empID: Int(0), employeeNumber: 77777, empName: String(firstName.text ?? "value"), empLastName: String(lastName.text ?? "value"), cellNumber: String(cellNumber.text ?? "value"), email:String(email.text ?? "value"), role: String(role.text ?? "value"), salary: Int(salary.text ?? "value") ?? 0)
            print(empId)
            update(Id:empId,employee: newEmp)
        }
    }
    
    func update(Id:Int, employee:Todo) {
        
        var request = URLRequest(url:URL(string: "http://localhost:8080/employee/updateEmployee/\(Id)")!)
        print("url request to update \(request)")
        request.httpMethod  = "PUT"
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "empName" : employee.empName,
            "empLastName": employee.empLastName,
            "cellNumber": employee.cellNumber,
            "email": employee.email,
            "role" : employee.role,
            "salary": employee.salary,
        ]
        // covert diectionary to json
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody =  jsonData
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request){(data,res,err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            if err == nil,let response = res as? HTTPURLResponse {
                if response.statusCode == 200
                {
                    DispatchQueue.main.async {
                        self.updateAlert(message: "Successfully Updated", title: "Success")
                    }
                }
            }
            guard let response = data else {return}
            let status = String(data:response,encoding: .utf8) ?? ""
            
            print(status)
            
        }.resume()
    }

    func updateAlert(message: String, title: String) {
        let alert = UIAlertController(title: message, message: title ,preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    
    func validatePhone(enteredPhone: String)->Bool {
            let phoneRegex = "\\d{10}"
            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return  predicate.evaluate(with: enteredPhone)
        }
    
    func validName(enteredName: String) -> Bool {
            let RegEx = "\\w{1,25}"
            let predicate = NSPredicate(format:"SELF MATCHES %@", RegEx)
            return predicate.evaluate(with: enteredName)
        }
    
    func validSalary(enteredSalary: String) -> Bool {
            let RegEx = "([1-9]|[1-9][0-9]|[1-9][0-9][0-9]|[1-9][0-9][0-9][0-9])"
            let predicate = NSPredicate(format:"SELF MATCHES %@", RegEx)
            return predicate.evaluate(with: enteredSalary)
        }

}

