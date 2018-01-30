//
//  NSString+FirstCharacter.swift
//  Lyst
//
//  Created by Tops on 3/25/16.
//  Copyright © 2016 Tops. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

extension String {
    
    func firstcharacter(_ str:String)->String{
        if(str.characters.count >= 1){
            //"llo, playgroun"
            return str.substring(with: (str.characters.index(str.startIndex, offsetBy: 0) ..< str.characters.index(str.endIndex, offsetBy: 1-str.characters.count))).capitalized
        }
        return str.capitalized
    }
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1","success":
            return true
        case "False", "false", "no", "0","error":
            return false
        default:
            return false
        }
    }
    
    func toDouble() -> Double {
        if let unwrappedNum = Double(self) {
            return unwrappedNum
        } else {
            // Handle a bad number
            print("Error converting \"" + self + "\" to Double")
            return 0.0
        }
    }
    
    func toCurrencyString_$() -> String {
        if let unwrappedNum = Double(self) {
            return String(format: "$ %.2f",unwrappedNum)
        } else {
            print("Error converting \"" + self + "\" to Double")
            return String(format: "$ %.2f",0.0)
        }
    }
    
    func toCurrencyStringWith_N_A_$() -> String {
        if let unwrappedNum = Double(self) {
            if unwrappedNum == 0.0{
                return String(format: "N/A")
            }else{
                return String(format: "$ %.2f",unwrappedNum)
            }
        } else {
            print("Error converting \"" + self + "\" to Double")
            return String(format: "N/A")
        }
    }
    
    func to_1fCurrencyString_$() -> String {
        if let unwrappedNum = Double(self) {
            return String(format: "$ %.2f",unwrappedNum)
        } else {
            print("Error converting \"" + self + "\" to Double")
            return String(format: "$ %.1f",0.0)
        }
    }
    
    
    
    func convertTODate() -> Date{
        //dateString = "2014-07-15 14:52:53"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)
        return date!
        
    }
    
    func convertTODateDDMMYYYY() -> Date{
        //dateString = "01/01/2016"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: self)
        return date!
    }
    
    func convertTODateUsingOnly() -> Date{
        //dateString = "2014-07-15"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        return date!
        
    }
    
    func filter(_ pred: (Character) -> Bool) -> String {
        var res = String()
        for c in self.characters {
            if pred(c) {
                res.append(c)
            }
        }
        return res
    }
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    
    func uppercaseFirst() -> String {
        return first.uppercased() + String(characters.dropFirst())
    }
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    /**
     Title:-  (Password at least eight characters long, one special characters, one uppercase, one lower case letter and one digit)
    */
    var isValidateSocialPassword : Bool {
        
        if(self.count>=8 && self.count<=20){
        }else{
            return false
        }
        let nonUpperCase = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
        let letters = self.components(separatedBy: nonUpperCase)
        let strUpper: String = letters.joined()
        
        let smallLetterRegEx  = ".*[a-z]+.*"
        let samlltest = NSPredicate(format:"SELF MATCHES %@", smallLetterRegEx)
        let smallresult = samlltest.evaluate(with: self)
        
        let numberRegEx  = ".*[0-9]+.*"
        let numbertest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = numbertest.evaluate(with: self)
        
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        var isSpecial :Bool = false
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.count)) != nil {
            print("could not handle special characters")
            isSpecial = true
        }else{
            isSpecial = false
        }
        return (strUpper.count >= 1) && smallresult && numberresult && isSpecial
    }
    
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil){
                
                if(self.count>=6 && self.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[-#$%^&*,+!@?=:/.();\\]\\'<>{\\[\\}_|~`])[A-Za-z0-9-#$%^&*,+!@?=:/.();\\]\\'<>{\\[\\}_|~`]{7,}")
        return passwordTest.evaluate(with: password)
        
    }
    
    var isValidPhone: Bool {
        if(self.count>=6 && self.count<=11){
            return true
        }else{
            return false
        }
    }
    
    var isAcceptedZeroDegitPhone: Bool {
        let str = self.replace("0", replacement:"")
        if str.count == 0 {
            return false
        }else{
            return true
        }
    }
}

extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
    
    func setTextFieldClearButtonColor(color: UIColor) {
        
//        if let textField = getSearchBarTextField() {
//            
//            let button = textField.value(forKey: "clearButton") as! UIButton
//            if let image = button.imageView?.image {
//                button.setImage(image.transform(withNewColor: color), for: .normal)
//            }
//        }
    }
    
    func setSearchImageColor(color: UIColor) {
        
//        if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
//            imageView.image = imageView.image?.transform(withNewColor: color)
//        }
    }
    
}
