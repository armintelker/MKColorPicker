import UIKit

public enum ColorPickerViewStyle {
    case square
    case circle
}

public enum ColorPickerViewSelectStyle {
    case check
    case none
}

open class ColorPickerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    open var headerTitles = [String]()  {
        didSet {
            collectionView.reloadData()
        }
    }
    
    open var colors = [[UIColor]]()  {
        didSet {
            if colors.isEmpty {
                fatalError("ERROR ColorPickerView - You must set at least 1 color!")
            }
            collectionView.reloadData()
        }
    }
    open var layoutDelegate: ColorPickerViewDelegateFlowLayout?
    open var delegate: ColorPickerViewDelegate?
    open var indexOfSelectedColor: Int? {
        return indexSelectedColor
    }
    
    open var preselectedIndex: IndexPath? = nil {
        didSet {
            indexSelectedColor = preselectedIndex!.item
            
            collectionView.selectItem(at: preselectedIndex, animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
    open var isSelectedColorTappable: Bool = true
    open var scrollToPreselectedIndex: Bool = false
    open var style: ColorPickerViewStyle = .circle{
        didSet{
            collectionView.reloadData()
        }
    }
    open var selectionStyle: ColorPickerViewSelectStyle = .check
    
    open var scrollDirection: UICollectionViewScrollDirection = .horizontal{
        didSet{
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = scrollDirection
            
            collectionView.collectionViewLayout = layout
            collectionView.reloadData()
            collectionView.contentOffset.x = 0
            collectionView.contentOffset.y = 0
        }
    }
    
    fileprivate var indexSelectedColor: Int?
    fileprivate lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorPickerCell.self, forCellWithReuseIdentifier: ColorPickerCell.cellIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.register(SecitonCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SecitonCollectionHeaderView")
        
        return collectionView
    }()
    
    open override func layoutSubviews() {
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        
        if let preselectedIndex = preselectedIndex, !scrollToPreselectedIndex {
            collectionView.scrollToItem(at: preselectedIndex, at: .top, animated: false)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors[section].count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return colors.count
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier:"SecitonCollectionHeaderView", for: indexPath) as! SecitonCollectionHeaderView
            headerView.sectionLabel.text = headerTitles[indexPath.section]
            headerView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
            
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.size.width, height:30)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorPickerCell.cellIdentifier, for: indexPath) as! ColorPickerCell
        
        cell.backgroundColor = colors[indexPath.section][indexPath.item]
        cell.colorLabel!.text = " #\(colors[indexPath.section][indexPath.item].rgbString.uppercased())"
        if style == .circle {
            cell.layer.cornerRadius = cell.bounds.width / 2
        }else{
            cell.layer.cornerRadius = 0
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let colorPickerCell = cell as! ColorPickerCell
        
        guard selectionStyle == .check else { return }
        
        guard indexPath.item == indexSelectedColor else {
            colorPickerCell.setSelected(selected: false)
            
            return
        }
        
        colorPickerCell.setSelected(selected: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorPickerCell = collectionView.cellForItem(at: indexPath) as! ColorPickerCell
        
        if indexPath.item == indexSelectedColor, !isSelectedColorTappable {
            return
        }
        
        if selectionStyle == .check {
            
            if indexPath.item == indexSelectedColor {
                if isSelectedColorTappable {
                    indexSelectedColor = nil
                    colorPickerCell.setSelected(selected: false)
                }
                return
            }
            
            indexSelectedColor = indexPath.item
            
            colorPickerCell.setSelected(selected: true)
            
        }
        
        delegate?.colorPickerView(self, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let oldColorCell = collectionView.cellForItem(at: indexPath) as? ColorPickerCell else {
            return
        }
        
        if selectionStyle == .check {
            
            oldColorCell.setSelected(selected: false)
            
        }
        
        delegate?.colorPickerView?(self, didDeselectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layoutDelegate = layoutDelegate, let sizeForItemAt = layoutDelegate.colorPickerView?(self, sizeForItemAt: indexPath) {
            return sizeForItemAt
        }
        return CGSize(width: 48, height: 48)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let layoutDelegate = layoutDelegate, let minimumLineSpacingForSectionAt = layoutDelegate.colorPickerView?(self, minimumLineSpacingForSectionAt: section) {
            return minimumLineSpacingForSectionAt
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let layoutDelegate = layoutDelegate, let minimumInteritemSpacingForSectionAt = layoutDelegate.colorPickerView?(self, minimumInteritemSpacingForSectionAt: section) {
            return minimumInteritemSpacingForSectionAt
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let layoutDelegate = layoutDelegate, let insetForSectionAt = layoutDelegate.colorPickerView?(self, insetForSectionAt: section) {
            return insetForSectionAt
        }
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
}



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

