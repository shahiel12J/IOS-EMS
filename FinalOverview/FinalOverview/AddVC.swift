//
//  AddVC.swift
//  FinalOverview
//
//  Created by DA MAC M1 126 on 2023/05/24.
//

import UIKit


class AddVC: UIViewController {
    
    @Published var isCreated = false
    
  


    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var cellNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var salary: UITextField!
    @IBOutlet weak var btnRole: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        btnRole.addAction(UIAction(title: "", handler: { (_) in
                    //print("Default")
                    self.btnRole.menu = self.addMenuItem()

                    //self.addMenuItem()
                }), for: .touchUpInside)
                btnRole.showsMenuAsPrimaryAction = true
                btnRole.menu = addMenuItem()
        // Do any additional setup after loading the view.
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
    
    @IBAction func btnAdd(_ sender: Any) {
        
        print(firstName.text ?? "value")
        print(lastName.text ?? "value")
        print(cellNumber.text ?? "value")
        print(email.text ?? "value")
        print(role.text ?? "value")
        print(salary.text ?? "value")
        
        let validateEmail = validateEmail(enteredEmail: email.text!)
        let validatePhone = validatePhone(enteredPhone: cellNumber.text!)
        let validateName = validName(enteredName: firstName.text!)
        let validateSurname = validName(enteredName: lastName.text!)
        let validateRole = validName(enteredName: role.text!)
        let validateSalary = validSalary(enteredSalary:salary.text!)
        
                                           
        if(validateName == false)
        {
            addAlert(message: "Enter Name", title: "Enter Name")
        }
        if(validateSurname == false)
        {
            addAlert(message: "Enter Surname", title: "Enter Surname")
        }
        if(validateEmail == false)
        {
            addAlert(message: "Enter correct email", title: "Invalid email")
        }
        if(validatePhone == false)
        {
            addAlert(message: "Enter correct number", title: "Invalid number")
        }
        if(validateRole == false)
        {
            addAlert(message: "Enter Role", title: "Enter Role")
        }
        if(validateSalary == false)
        {
            addAlert(message: "Enter correct salary", title: "Enter Correct Salary")
        }
        else
        {
            let randomInt1 = Int.random(in: 1..<10)
            let randomInt2 = Int.random(in: 1..<10)
            let newEmp: Todo = Todo(empID: Int(0), employeeNumber: randomInt1 + randomInt2, empName: String(firstName.text ?? "value"), empLastName: String(lastName.text ?? "value"), cellNumber: String(cellNumber.text ?? "value"), email:String(email.text ?? "value"), role: String(role.text ?? "value"), salary: Int(salary.text ?? "value") ?? 0)
            
            createNew(employee: newEmp)
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TableVC") as? TableVC

        self.navigationController?.pushViewController(vc!, animated: true)
        
     
        }
    
    func createNew(employee:Todo)  {
        
        var request = URLRequest(url:URL(string: "http://localhost:8080/employee/addEmployee")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "employeeNumber": employee.employeeNumber,
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
            guard let _ = data else {return}
            if err == nil,let response = res as? HTTPURLResponse {
                if response.statusCode == 201
                {
                    DispatchQueue.main.async {
                        self.isCreated = true
                        self.addAlert(message: "Successfully Added", title: "Success")
                    }
                    
                }
            }
         
        }.resume()
        
    }
    
    func addAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message,preferredStyle: UIAlertController.Style.alert)

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
