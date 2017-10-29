import UIKit

@objc public protocol ColorPickerViewDelegate {
    
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath)
    
    @objc optional func colorPickerView(_ colorPickerView: ColorPickerView, didDeselectItemAt indexPath: IndexPath)
    
}

