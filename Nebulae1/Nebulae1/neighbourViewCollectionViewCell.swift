//
//  neighbourViewCollectionViewCell.swift
//  Nebulae1
//
//  Created by GEU on 07/02/26.
//

import UIKit

class neighbourViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(dailWonder: DailyWonder) {
        self.title.text = dailWonder.neighbour_title
        self.text.text = dailWonder.neighbour_text
    }
}
