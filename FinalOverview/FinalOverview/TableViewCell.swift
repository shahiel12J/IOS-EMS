//
//  TableViewCell.swift
//  FinalOverview
//
//  Created by DA MAC M1 126 on 2023/05/24.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var employeeNumber: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profileIMG: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
