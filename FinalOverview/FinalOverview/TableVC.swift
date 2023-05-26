//
//  TableVC.swift
//  FinalOverview
//
//  Created by DA MAC M1 126 on 2023/05/24.
//

import UIKit

class TableVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var Delete : Int = 0
    
    @Published var isDeleted = false
    
    var names = [["John","Doe","JD@gmail.com", "1"], ["Henry","Smith","HS@gmail.com", "2"], ["James","Johnson","JJ@gmail.com", "3"], ["Emma","Jones","EJ@gmail.com", "4"], ["Jack","Miller","JM@gmail.com", "5"], ["Adam","Davis","AD@gmail.com", "6"],["Tom","Martinez","TM@gmail.com", "7"]]
    
    var onEdit : (( _ tableReload : Bool,  _ nameText : String,  _ ageText : String,  _ dob : String ) -> Void)?

    var searchData = [Todo]()
    var apiData = [Todo]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        tableView.reloadData()
        tableView.dataSource = self
        tableView.delegate = self
        searchData = apiData
        // Do any additional setup after loading the view.
        FetchApiData(URL: "http://localhost:8080/employee/getEmployees") { result in
            //self.data = result
            self.apiData = result
            self.searchData = result
            //print(result)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        tableView.refreshControl = UIRefreshControl()
        // add target to UIRefreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        
    }
    
    
    func FetchApiData(URL url: String, completion: @escaping([Todo]) -> Void){
        
        guard let url = URL(string: url) else {return}
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            if data != nil, error == nil{
                do {
                    let parsingData = try JSONDecoder().decode([Todo].self, from:data!)
                    completion(parsingData)
                } catch {
                    print("parsing error")
                }
            }
        }
        dataTask.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        //cell.employeeNumber.text = String(searchData[indexPath.row].employeeNumber)
        do {
            cell.firstName.text = String(searchData[indexPath.row].empName)
            cell.lastName.text = searchData[indexPath.row].empLastName
            cell.email.text = String(searchData[indexPath.row].email)
            Delete = Int(searchData[indexPath.row].empID)
            
            return cell
        }catch is Error{
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC

        vc?.IdSet = apiData[indexPath.row].empID
        vc?.empNumberSet = String(apiData[indexPath.row].employeeNumber)
        vc?.firstNameSet = apiData[indexPath.row].empName
        vc?.lastNameSet = apiData[indexPath.row].empLastName
        vc?.emailSet = apiData[indexPath.row].email
        vc?.cellSet = apiData[indexPath.row].cellNumber
        vc?.roleSet = apiData[indexPath.row].role
        vc?.salarySet = apiData[indexPath.row].salary

        self.navigationController?.pushViewController(vc!, animated: true)
    }

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(id: Delete)
            searchData.remove(at: indexPath.row)
            apiData.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func delete(id: Int)  {
        let empId =  id
        print(empId)
        
        var request = URLRequest(url:URL(string: "http://localhost:8080/employee/deleteEmployee/\(empId)")!)
        
        request.httpMethod  = "DELETE"
        let session = URLSession(configuration: .default)
        session.dataTask(with: request){(data,res,err)in
            
            if err != nil {
                print(err!.localizedDescription)
                
            }
            if err == nil,let data = data, let response = res as? HTTPURLResponse {
                print(response.statusCode)
                print(data)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.searchData.removeAll{
                        (employee)-> Bool in
                        return employee.empID == id
                    }
                    self.isDeleted = true
                    self.deleteAlert()
                    //self.performRequest()
                }
                
            }
            
        }.resume()
        if(isDeleted == true)
        {
            tableView.reloadData()
        }
    }
    
    @objc func callPullToRefresh(){
            self.FetchApiData(URL: "http://localhost:8080/employee/getEmployees"){ result in
                //self.data = result
                self.apiData = result
                self.searchData = result
                //print(result)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                self.tableView.refreshControl?.endRefreshing()
                                //self.refreshLabel.isHidden = true
                                self.tableView.reloadData()
                            }
                
            }
        }
    
    func deleteAlert2() {
        let alert = UIAlertController(title: "2", message: "Employee Successfully Deleted!!",preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    func deleteAlert() {
        let alert = UIAlertController(title: "Deleted", message: "Employee Successfully Deleted!!",preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = []
        if searchText == ""{
            searchData = apiData
        }
        for word in apiData{
            if word.empName.description.lowercased().contains(searchText.description.lowercased()){
                searchData.append(word)
                //             }
            }
            self.tableView.reloadData()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchData = apiData
            searchBar.endEditing(true)
            self.tableView.reloadData()
        }
        
        
    }
}
