//
//  innerFactCollectionViewCell.swift
//  Nebulae1
//
//  Created by GEU on 09/02/26.
//

import UIKit

class innerFactCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var yearAgo: UILabel!
    @IBOutlet weak var year: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.text.numberOfLines = 0
            self.text.lineBreakMode = .byWordWrapping
        //self.text.preferredMaxLayoutWidth = 250
       // self.contentView.backgroundColor = .red
           // self.text.backgroundColor = .green
       // self.layoutIfNeeded()
    }
    func configureCell(spaceHistory: SpaceHistory) {
            // 1. Set the description
            self.text.text = spaceHistory.description
    
            // 2. Setup Date Formatter to read your JSON format
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd" // Matches "1982-02-05"
    
            // 3. Convert String to Date
            if let date = formatter.date(from: spaceHistory.date) {
                let calendar = Calendar.current
    
                // A. Get the Year (e.g., "1982")
                let year = calendar.component(.year, from: date)
                self.year.text = "\(year)"
    
                // B. Calculate "Years Ago"
                // This calculates the difference in years between 'date' and 'now'
                let currentYear = Date()
                let yearsPassed = calendar.dateComponents([.year], from: date, to: currentYear).year ?? 0
    
                self.yearAgo.text = "\(yearsPassed) years ago"
            } else {
                // Fallback if the date string is broken
                self.year.text = "----"
                self.yearAgo.text = ""
            }
        }
}
