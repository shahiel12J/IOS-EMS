//
//  DetailsVC.swift
//  FinalOverview
//
//  Created by DA MAC M1 126 on 2023/05/25.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var cellNumber: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var salary: UILabel!
    
    @Published var IdSet: Int = 0
    var empNumberSet: String?
    var cellSet: String?
    var roleSet: String?
    var salarySet: Int = 0
    var firstNameSet: String?
    var lastNameSet: String?
    var emailSet: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(IdSet)
        firstName.text = firstNameSet
        lastName.text = lastNameSet
        salary.text = "R" + String(salarySet)
        cellNumber.text = cellSet
        role.text = roleSet
        email.text = emailSet
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnToUpdate(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateVC") as? UpdateVC

        //print(IdSet)
        vc?.empId = IdSet
        
        vc?.firstNameSet = firstNameSet
        vc?.lastNameSet = lastNameSet
        vc?.emailSet = emailSet
        vc?.cellSet = cellSet
        vc?.roleSet = roleSet
        vc?.salarySet = salarySet
        //print(vc?.empId)

        self.navigationController?.pushViewController(vc!, animated: true)
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
