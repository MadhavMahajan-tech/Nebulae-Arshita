//
//  sectionHeaderView.swift
//  Nebulae1
//
//  Created by GEU on 09/02/26.
//

import UIKit

class sectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.textColor = .white
    }
    
}
