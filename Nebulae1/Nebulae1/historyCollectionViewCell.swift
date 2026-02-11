//
//  historyCollectionViewCell.swift
//  Nebulae1
//
//  Created by GEU on 07/02/26.
//

import UIKit

class historyCollectionViewCell: UICollectionViewCell,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    var spaceHistory: [SpaceHistory] = []
    var dataModel = DataModel()
    @IBOutlet weak var innerCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        spaceHistory = dataModel.spaceHistoryData()
        innerCollectionView.backgroundColor = .clear
        innerCollectionView.dataSource = self
        innerCollectionView.delegate = self
        // Initialization code
        print(spaceHistory)
        innerCollectionView.register(UINib(nibName: "innerFactCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "history_cell")
        let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.minimumLineSpacing = 10 // Space between rows
                layout.minimumInteritemSpacing = 0
                
                innerCollectionView.collectionViewLayout = layout
                innerCollectionView.backgroundColor = .clear
                innerCollectionView.reloadData()
        
    }
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spaceHistory.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "history_cell", for: indexPath) as! innerFactCollectionViewCell
        cell.configureCell(spaceHistory: spaceHistory[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = spaceHistory[indexPath.row]
        let text = item.description
        
        // 1. CALCULATE TRUE WIDTH
        // We must subtract the Left Padding (Timeline) and Right Padding.
        // Based on your screenshot, the text starts far to the right.
        // Subtracting 120 gives the text "less room" in math, forcing it to wrap to more lines.
        let approximateWidthOfTimeline: CGFloat = 180
        let availableWidth = collectionView.bounds.width - approximateWidthOfTimeline
        
        // 2. CALCULATE TEXT HEIGHT
        // Make sure this font size matches your XIB (System 13? 14?)
        let font = UIFont.systemFont(ofSize: 20)
        let textHeight = text.height(withConstrainedWidth: availableWidth, font: font)
        
        // 3. ADD VERTICAL BUFFER (For Year + Ago + Spacing)
        // You have "1967" (20pt) + "59 years ago" (15pt) + Spacing (20pt).
        // Let's use 80 to be safe.
        let staticContentHeight: CGFloat = 50
        
        return CGSize(width: collectionView.bounds.width, height: textHeight + staticContentHeight)
    }
    
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }}
