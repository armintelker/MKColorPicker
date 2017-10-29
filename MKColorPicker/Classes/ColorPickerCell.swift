import UIKit

class ColorPickerCell: UICollectionViewCell {
    
    static let cellIdentifier = String(describing: ColorPickerCell.self)
    var colorLabel: UILabel? = nil
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func commonInit() {
        colorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height:18))
        colorLabel!.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.4)
        colorLabel!.font = UIFont(name: colorLabel!.font.fontName, size: 9)
        contentView.addSubview(colorLabel!)
        colorLabel!.text = ""
    }
    
    
    func setSelected(selected: Bool){
        if selected{
            self.layer.borderWidth = 2
            self.layer.borderColor = self.backgroundColor?.inverted.cgColor
        }else{
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
}

