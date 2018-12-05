//
//  AppExtensions.swift
//  MarcoApp
//
//  Created by Nabeel Hayat on 28/10/2017.
//  Copyright © 2017 GrayScaleLogic. All rights reserved.
//

import UIKit
import PKHUD



private var AssociatedObjectHandle: UInt8 = 0


//class AppExtensions: NSObject {
//
//    
//}

extension NSMutableAttributedString {

    func setFont(font:UIFont, kerningValue:CGFloat = 0.0) -> NSMutableAttributedString {
    
        let characterSpacing: Float = Float(font.pointSize * kerningValue/1000);
        self.addAttribute(NSAttributedStringKey.kern, value: NSNumber(value: characterSpacing), range: NSRange(location: 0, length: self.length))
        

//        self.addAttribute(NSKernAttributeName, value: font, range: NSRange(location: 0, length: self.length))

        self.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location: 0, length: self.length))

        
        return self;
    }
    
}

public extension UISearchBar {
    
    func changeSearchBarColor(color : UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                if subSubView.conforms(to: UITextInputTraits.self) {
                    let textField = subSubView as! UITextField
                    textField.backgroundColor = color
                    break
                }
            }
        }
    }
    
    public func setSearchBackgroundColor(_ color: UIColor) {
        guard let tf = (value(forKey: "searchField") as? UITextField) else { return }
        tf.backgroundColor = color
    }
}

extension UIImage {
    
    public func blendedByColor(_ color: UIColor) -> UIImage {
        let scale = UIScreen.main.scale
        if scale > 1 {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
        } else {
            UIGraphicsBeginImageContext(size)
        }
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
        draw(in: bounds, blendMode: .destinationIn, alpha: 1)
        let blendedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return blendedImage!
    }

    class func getImage(withName imageName: String, imageColor color: UIColor = AppTheme.grayColor) -> UIImage {
        
        let namedImage = UIImage(named: imageName)
        
        return (namedImage?.imageMaskedWithColor(color))!
    }
    
    func changeColor(_ maskColor: UIColor?) -> UIImage {
    
        return self.imageMaskedWithColor(maskColor!)
    }
    
    fileprivate func imageMaskedWithColor(_ maskColor: UIColor?) -> UIImage {
        
        assert(maskColor != nil, "Invalid parameter not satisfying: maskColor != nil")
        let imageRect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(self.size.width), height: CGFloat(self.size.height))
        var newImage: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        do {
            let context: CGContext? = UIGraphicsGetCurrentContext()
            context?.scaleBy(x: 1.0, y: -1.0)
            context?.translateBy(x: 0.0, y: -(imageRect.size.height))
            context?.clip(to: imageRect, mask: self.cgImage!)
            context?.setFillColor((maskColor?.cgColor)!)
            context?.fill(imageRect)
            newImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return newImage!
    }
    

    func resizeImage(_ offset: CGFloat) -> UIImage {
        
        var resizeFactor: CGFloat = 1;
        
        let imageWidth: CGFloat = self.size.width
        let imageHeight: CGFloat = self.size.height
        
        if imageWidth > offset || imageHeight > offset {
            
            resizeFactor = 5
        }
        
        if imageWidth > 10000 {
            
            resizeFactor = 16
        }
        
        let resizedImage: UIImage = UIImage.resizeImage(with: self, scaledTo: CGSize(width: self.size.width/resizeFactor, height: self.size.height/resizeFactor))
        
        return resizedImage
    }
    
    class func resizeImage(with image: UIImage, scaledTo size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
//    + (UIImage *)resizeImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
//    {
//    //UIGraphicsBeginImageContext(newSize);
//    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
//    // Pass 1.0 to force exact pixel size.
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//    }
    
//    - (UIImage*)resizeImage:(UIImage*)image
//    {
//    CGFloat resizeFactor = 1;
//    CGFloat imageW = image.size.width;
//    CGFloat imageH = image.size.height;
//
//    if (imageW > 900 || imageH > 900) {
//    resizeFactor = 5;
//    }
//    if (imageW > 10000) {
//    resizeFactor = 16;
//    }
//
//    UIImage *resizedImage = [UIImage resizeImageWithImage:image
//    scaledToSize:CGSizeMake(image.size.width / resizeFactor, image.size.height / resizeFactor)];
//    return resizedImage;
//    }
}

extension UIApplication {
    
    static var hasSafeAreaInsets: Bool {
        
        if #available(iOS 11.0, tvOS 11.0, *) {
            if (shared.keyWindow?.safeAreaInsets.top)! > CGFloat(0.0) || shared.keyWindow?.safeAreaInsets != .zero {
                print("iPhone X")
                
                return true
            }
            else {
                print("Not iPhone X")
                
                return false
            }
        }
        
        return false
    }
}

extension UIViewController {
    
    var appDelegate: AppDelegate {
        
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func subscribeToChannel(_ channel: String) {
        
        if self.appDelegate.clientPubNub != nil {
        
            self.appDelegate.clientPubNub.subscribeToChannels([channel], withPresence: true)
        }
    }

    func showPKHUD(WithMessage message: String) {
     
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: message)
        PKHUD.sharedHUD.dimsBackground = true
        PKHUD.sharedHUD.show()
    }
    
    func showPKHUD() {
        
        self.showPKHUD(WithMessage: "")
    }
    
    func hidePKHUD() {
        
        PKHUD.sharedHUD.hide()
    }
}

extension UINavigationController {

}

extension UIBarButtonItem {

}

extension UINavigationBar {
    
//    var height: CGFloat {
//        get {
//            if let h = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? CGFloat {
//                return h
//            }
//            return 0
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//
//        }
//    }
//    
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        if self.height > 0 {
//            return CGSize(width: self.superview!.bounds.size.width, height: self.height);
//        }
//        return super.sizeThatFits(size)
//    }
    
}


extension Notification.Name {
    
    static let OnUpdateUserProfile = Notification.Name("OnUpdateUserProfile")
    static let OnUpdateCoverPicture = Notification.Name("OnUpdateCoverPicture")
    static let DidDismissCardController = Notification.Name("DidDismissCardController")
    static let GOTOFeedNotification = Notification.Name("GOTOFeedNotification")
    static let DismissGroupControllerNotification = Notification.Name("DismissGroupControllerNotification")
    static let DidSubscribeUserNotification = Notification.Name("DidSubscribeUserNotification")
    static let DidReceiveMessageNotification = Notification.Name("DidReceiveMessageNotification")
    static let DidOpenChatNotification = Notification.Name("DidOpenChatNotification")
    static let DidSetUserIdNotification = Notification.Name("DidSetUserIdNotification")
}


public extension Date {
    
    func daysRemaining() -> String {
        
        let dateComponents: DateComponents = Calendar.current.dateComponents([.day,.month,.year], from: Date(), to: self)
        
        if dateComponents.year > 0 {
            
            if dateComponents.year == 1 {
                
                return localizedString("1 year remaining")
            }
            else {
                
                return localizedString("\(dateComponents.year ?? 2) years remaining")
            }
        }
        else if dateComponents.month > 0 {
            
            if dateComponents.month == 1 {
                
                return localizedString("1 month remaining")
            }
            else {
                
                return localizedString("\(dateComponents.month ?? 2) months remaining")
            }
        }
        else if dateComponents.day > 0 {
            
            if dateComponents.day == 1 {
                
                return localizedString("yesterday")
            }
            else {
                
                return localizedString("\(dateComponents.day ?? 2) days remaining")
            }
        }
        else  {
            
            return localizedString("today")
        }
    }

    func prettyDate() -> String {
        
        let dateComponents: DateComponents = Calendar.current.dateComponents([.hour,.minute,.second,.day,.month,.year], from: self, to: Date())
        
        if dateComponents.year > 0 {
            
            if dateComponents.year == 1 {
            
                return localizedString("last year")
            }
            else {
                
                return localizedString("\(dateComponents.year ?? 2) years ago")
            }
        }
        else if dateComponents.month > 0 {
            
            if dateComponents.month == 1 {
                
                return localizedString("last month")
            }
            else {
                
                return localizedString("\(dateComponents.month ?? 2) months ago")
            }
        }
        else if dateComponents.day > 0 {
         
            if dateComponents.day == 1 {
                
                return localizedString("yesterday")
            }
            else {
                
                return localizedString("\(dateComponents.day ?? 2) days ago")
            }
        }
        else if dateComponents.hour > 0 {
            
            if dateComponents.hour == 1 {
                
                return localizedString("last hour")
            }
            else {
                
                return localizedString("\(dateComponents.hour ?? 2) hours ago")
            }
        }
        else if dateComponents.minute > 0 {
            
            if dateComponents.minute == 1 {
                
                return localizedString("a minute ago")
            }
            else {
                
                return localizedString("\(dateComponents.minute ?? 2) minutes ago")
            }
        }
        else if dateComponents.second < 30 {
            
            return localizedString("just now")
        }
        else {
            
            return localizedString("\(dateComponents.second ?? 2) seconds ago")
        }
    }
    
    func getZodiacSign() -> String {
        
        let calendar = Calendar.current
        let d = calendar.component(.day, from: self)
        let m = calendar.component(.month, from: self)
        
        switch (d,m) {
        case (21...31,1),(1...19,2):
            return "Aquarius"
        case (20...29,2),(1...20,3):
            return "Pisces"
        case (21...31,3),(1...20,4):
            return "Aries"
        case (21...30,4),(1...21,5):
            return "Taurus"
        case (22...31,5),(1...21,6):
            return "Gemini"
        case (22...30,6),(1...22,7):
            return "Cancer"
        case (23...31,7),(1...22,8):
            return "Leo"
        case (23...31,8),(1...23,9):
            return "Virgo"
        case (24...30,9),(1...23,10):
            return "Libra"
        case (24...31,10),(1...22,11):
            return "Scorpio"
        case (23...30,11),(1...21,12):
            return "Sagittarius"
        default:
            return "Capricorn"
        }
    }
    
    /// Date string from date.
    ///
    /// - Parameter format: Date format (default is "MMM dd, yyyy")
    /// - Returns: date string
    func dateString(ofFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (format == "") ? "MMM dd, yyyy" : format;
        return dateFormatter.string(from: self)
    }
}


public extension Int {

    var stringValue: String {
        return "\(self)"
    }
    
    func getMaritalStatus() -> String {
        
        if let maritalStatusListEntity: [MaritalStatusEntity] = MaritalStatusEntity.mr_findAll(in: .mr_default()) as? [MaritalStatusEntity] {
            
            for maritalStatus in maritalStatusListEntity {
                
                if maritalStatus.statusId == self {
                    
                    return maritalStatus.statusTitle!
                }
            }
        }
        
        return "Single"
    }
}

public extension Double {
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func getGroupPriceId() -> NSInteger {
        
        if self == 0 {
            
            return 0
        }
        else {
            
            if let groupPricesListEntity: [GroupPriceEntity] = GroupPriceEntity.mr_findAll(in: .mr_default()) as? [GroupPriceEntity] {
                
                for groupPrice in groupPricesListEntity {
                    
                    if groupPrice.price?.doubleValue == self {
                        
                        return NSInteger(groupPrice.priceId)
                    }
                }
            }
            
            return 1
        }
    }
}

public extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var intValue: Int { return Int(self)! }
    
    func removeFormatAmount() -> Double {
        let formatter = NumberFormatter()
        
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.decimalSeparator = ","
        
        return formatter.number(from: self) as! Double? ?? 0
    }
    
    var isValidEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    func toDate() -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS"
        let date = dateFormatter.date(from:self)!
        return date
    }
    
    func stringDate(ofFormat format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)!
    }
    
    func stringDate(ofFormat format: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let currentDate: Date = dateFormatter.date(from: self)!
        
        return currentDate.dateString(ofFormat: toFormat)
    }
    
    func getZodiacSign() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let currentDate: Date = dateFormatter.date(from: self)!
        
        return currentDate.getZodiacSign()
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func getMaritalStatusId() -> NSInteger {
        
        if let maritalStatusListEntity: [MaritalStatusEntity] = MaritalStatusEntity.mr_findAll(in: .mr_default()) as? [MaritalStatusEntity] {
            
            for maritalStatus in maritalStatusListEntity {
                
                if maritalStatus.statusTitle == self {
                    
                    return NSInteger(maritalStatus.statusId)
                }
            }
        }
        
        return 1
    }
    
    func getGroupCategoryId() -> NSInteger {
        
        if let groupCategoriesListEntity: [GroupCategoryEntity] = GroupCategoryEntity.mr_findAll(in: .mr_default()) as? [GroupCategoryEntity] {
            
            for groupCategory in groupCategoriesListEntity {
                
                if groupCategory.categoryTitle == self {
                    
                    return NSInteger(groupCategory.categoryId)
                }
            }
        }
        
        return 1
    }
    
}
