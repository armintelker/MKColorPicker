import Foundation


class SecitonCollectionHeaderView: UICollectionViewCell {
    let sectionLabel: UILabel
    
    override init(frame: CGRect) {
        sectionLabel = UILabel(frame: CGRect(x: 15, y: 5, width: 200, height: 20))
        sectionLabel.text = ""
      
        super.init(frame: frame)
        addSubview(sectionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        sectionLabel = UILabel(frame: CGRect(x: 15, y: 5, width: 200, height: 20))
        sectionLabel.text = ""
        super.init(coder: aDecoder)
        addSubview(sectionLabel)
    }
    
}
