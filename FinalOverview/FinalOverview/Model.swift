//
//  Model.swift
//  FinalOverview
//
//  Created by DA MAC M1 126 on 2023/05/24.
//

import Foundation

struct Todo: Codable {
    let empID, employeeNumber: Int
    let empName, empLastName, cellNumber, email: String
    let role: String
    let salary: Int

    enum CodingKeys: String, CodingKey {
        case empID = "empId"
        case employeeNumber, empName, empLastName, cellNumber, email, role, salary
    }
}

