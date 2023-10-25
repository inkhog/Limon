//
//  LMGamesControllerLayout.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import Foundation
import UIKit

class LMGamesControllerLayout {
    static let shared = LMGamesControllerLayout()
    
    func collectionViewLayout(_ sectionCount: Int) -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, layoutEnvironment in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3), heightDimension: .estimated(300)))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300)), subitems: [item])
            group.interItemSpacing = .fixed(20)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [
                .init(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            ]
            section.contentInsets = .init(top: sectionIndex == sectionCount ? 20 : 0, leading: 20, bottom: 20, trailing: 20)
            section.interGroupSpacing = 20
            
            return section
        }, configuration: configuration)
    }
}
