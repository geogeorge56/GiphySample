

import UIKit
import SnapKit

class BorderedTextField: UITextField
{
    var borderView : UIView = UIView()
    
    
    @IBInspectable var shouldAddImage: Bool = false
    {
        didSet
        {
            self.addImage()
        }
    }
    
    @IBInspectable var image: UIImage? = UIImage(named: "user")
    {
        didSet
        {
            self.addImage()
        }
    }
    
    
    override func awakeFromNib()
    {
        self.addBorderView()

        self.addTarget(self, action:#selector(didBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action:#selector(didEndEditing), for: .editingDidEnd)
        
        self.changePlaceHolderColor()
    }
    
    
    /*
     * Created a border view and added it to the textfield
     */
    func addBorderView()
    {
        self.addSubview(borderView)
        borderView.backgroundColor = UIColor.lightGray
        borderView.snp.makeConstraints
        { (maker) in
            maker.left.equalTo(self)
            maker.right.equalTo(self)
            maker.bottom.equalTo(self)
            maker.height.equalTo(1)
        }
    }
    
    /*
     * Adds left image view if needed
     */
    func addImage()
    {
        if shouldAddImage
        {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.size.height))
            view.addSubview(imageView)
            imageView.center = view.center
            self.leftView = view
            self.leftViewMode = .always
        }
    }
    
    /*
     * Changing textfields default placeholder color
     */
    func changePlaceHolderColor()
    {
        let placeHolderColor = UIColor(white: 1, alpha: 0.6)
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
        attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        
    }

    
    @objc func didBeginEditing()
    {
        borderView.backgroundColor = UIColor.white
    }
    
    @objc func didEndEditing()
    {
        borderView.backgroundColor = UIColor.lightGray
    }
    
}















