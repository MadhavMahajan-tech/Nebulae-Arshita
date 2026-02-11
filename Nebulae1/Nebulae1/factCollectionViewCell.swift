//
//  factCollectionViewCell.swift
//  Nebulae1
//
//  Created by GEU on 07/02/26.
//

import UIKit

class factCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        text.textColor = .white
        title.textColor = .white
    }
    func configureCell(dailyWonder: DailyWonder){
        self.text.text = dailyWonder.fact_text
        self.title.text = dailyWonder.fact_title
        self.imageView.image = UIImage(named: dailyWonder.fact_image_url)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // This ensures it is always a circle, no matter what size the layout decides
        self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
        self.imageView.layer.masksToBounds = true
    }
}
