//
//  TaskTableViewCell.swift
//  ToDo
//
//  Created by Nitesh on 27/03/22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "TaskCell"
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskDesciptionLabel: UILabel!
    
    var task: Task!{
        didSet{
            self.taskLabel.text = task.title
            self.taskDesciptionLabel.text = task.taskDescription
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
