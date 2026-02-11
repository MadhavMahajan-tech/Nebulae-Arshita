//
//  ViewController.swift
//  Nebulae1
//
//  Created by GEU on 07/02/26.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var dailyWonder: [DailyWonder] = []
  //  var spaceHistory: [SpaceHistory] = []
    var dataModel = DataModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dailyWonder = dataModel.getData()
        collectionView.backgroundColor = .clear
      //  spaceHistory = dataModel.spaceHistoryData()
        print(dailyWonder)
        //print(spaceHistory)
        register()
        collectionView.dataSource = self
        let headerNib = UINib(nibName: "sectionHeaderView", bundle: nil)
            
            // 2. Register the Nib for the Section Header (The Big "Today" Title)
            collectionView.register(
                headerNib,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "MainSectionHeader"
            )
            
            // 3. Register the SAME Nib for the Card Header (The Small titles)
            collectionView.register(
                headerNib,
                forSupplementaryViewOfKind: "CardHeader",
                withReuseIdentifier: "CardHeader"
            )
        collectionView.register(headerNib, forSupplementaryViewOfKind: "Header_Neighbour", withReuseIdentifier: "CardHeader")
            collectionView.register(headerNib, forSupplementaryViewOfKind: "Header_History", withReuseIdentifier: "CardHeader")
            collectionView.register(headerNib, forSupplementaryViewOfKind: "Header_Fact", withReuseIdentifier: "CardHeader")
        collectionView.setCollectionViewLayout(createBentoLayout(), animated: true)
    }
    func register(){
        collectionView.register(UINib(nibName: "neighbourViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "neighbour_cell")
        collectionView.register(UINib(nibName: "factCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "fact_cell")
        collectionView.register(UINib(nibName: "historyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "history_cell")
       
    }

}
extension ViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "neighbour_cell", for: indexPath) as! neighbourViewCollectionViewCell
            // Use the first item for the neighbor highlight
            if let data = dailyWonder.first {
                cell.configureCell(dailWonder: data)
            }
            return cell
        }
        else if indexPath.item == 2 {
            // You'll need to re-register and use your fact_cell here
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fact_cell", for: indexPath) as! factCollectionViewCell
            if let data = dailyWonder.first {
                    cell.configureCell(dailyWonder: data)
                }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "history_cell", for: indexPath) as! historyCollectionViewCell
            // Use indexPath.row to get the unique event for this specific row
            return cell
        }
    }
// func createLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
//            let firstItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                       heightDimension: .fractionalHeight(0.3))
//        }
//    }
    // MARK: - Bento Grid Layout
    func createBentoLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self?.createSectionLayout()
        }
    }
    func createSectionLayout() -> NSCollectionLayoutSection {

        // 1. Header Helper (Floats UP by 30 points)
        func makeHeader(uniqueId: String) -> NSCollectionLayoutSupplementaryItem {
                
                // Keep the anchor simple: float UP by 30, keep X at 0
                let headerAnchor = NSCollectionLayoutAnchor(edges: [.top], absoluteOffset: CGPoint(x: 0, y: -30))
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
                
                let headerItem = NSCollectionLayoutSupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: uniqueId,
                    containerAnchor: headerAnchor
                )
                
                // THE FIX: Use Content Insets to add padding
                // This forces the layout to push the view inward
                if uniqueId == "Header_Fact" {
                    headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 100, bottom: 0, trailing: 0)
                }
                
                return headerItem
            }
        
        // =========================================================
        // 2. LEFT COLUMN (Neighbour + History)
        // =========================================================
        
        // Top Left Item
        let topLeftItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        let topLeftGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.35)),
            subitems: [topLeftItem]
        )
        topLeftGroup.supplementaryItems = [makeHeader(uniqueId: "Header_Neighbour")]

        // Bottom Left Item
        let bottomLeftItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        let bottomLeftGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.65)),
            subitems: [bottomLeftItem]
        )
        bottomLeftGroup.supplementaryItems = [makeHeader(uniqueId: "Header_History")]
        
        // Combine Left Column
        let leftColumnGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.55), heightDimension: .fractionalHeight(1.0)),
            subitems: [topLeftGroup, bottomLeftGroup]
        )
        
        // --- FIX 1: GAP BETWEEN CARDS ---
        // Change this to 80. If you don't see a big gap, the code isn't updating.
        leftColumnGroup.interItemSpacing = .fixed(80)
        
        // =========================================================
        // 3. RIGHT COLUMN (Space Fact)
        // =========================================================
        
        let rightItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        let rightGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .fractionalHeight(1.0)),
            subitems: [rightItem]
        )
        // Attaching Header to the Right Column Group
        rightGroup.supplementaryItems = [makeHeader(uniqueId: "Header_Fact")]
        
        // =========================================================
        // 4. MAIN CONTAINER
        // =========================================================
        let mainGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(600)),
            subitems: [leftColumnGroup, rightGroup]
        )
        mainGroup.interItemSpacing = .fixed(20)
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        // Main Section Header ("Today")
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        // --- FIX 2: PUSH GRID DOWN ---
        // I set this to 120. This is HUGE.
        // You should see a very large empty space below "Today".
        section.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 20, bottom: 90, trailing: 20)
        
        return section
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // CASE 1: Main "Today" Header
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainSectionHeader", for: indexPath) as! sectionHeaderView // Make sure class name matches
            header.titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
            header.titleLabel.text = "Today"
            return header
        }
        
        // CASE 2: The Card Headers (Neighbour, History, Fact)
        else {
            // Reuse Identifier is "CardHeader" for all of them
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CardHeader", for: indexPath) as! sectionHeaderView
            
            header.titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
            header.titleLabel.textColor = .lightGray // Optional styling
            
            // Switch based on the UNIQUE KIND string
            if kind == "Header_Neighbour" {
                header.titleLabel.text = "Neighbour of the Day"
            }
            else if kind == "Header_History" {
                header.titleLabel.text = "On this Day in Space History"
            }
            else if kind == "Header_Fact" {
                header.titleLabel.text = "Space Fact of the Day"
                header.titleLabel.transform = CGAffineTransform(translationX: 260, y: 0)
            }
            
            return header
        }
    }
}

