//
// Copyright (c) 2017 malkouz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

class ColorPickerCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// The reuse identifier used to register the UICollectionViewCell to the UICollectionView
    static let cellIdentifier = String(describing: ColorPickerCell.self)
    var colorLabel: UILabel
    //MARK: - Initializer
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
        colorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height:20))
        colorLabel.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
        colorLabel.font = UIFont(name: colorLabel.font.fontName, size: 10)
        contentView.addSubview(colorLabel)
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        colorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height:20))
        colorLabel.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
        colorLabel.font = UIFont(name: colorLabel.font.fontName, size: 10)
        contentView.addSubview(colorLabel)
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func commonInit() {
        colorLabel.text = "#FFFFFF"
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

