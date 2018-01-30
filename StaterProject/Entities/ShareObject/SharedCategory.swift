//
//  SharedCategory.swift
//  Alcohol
//
//  Created by Tops on 1/12/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class SharedCategory: NSObject {
        var strCategoryID = ""
        var strCategoryName = ""
        var strCategoryImage = ""
        var strCategoryThumbImage = ""
        var arrSubCategoryList = [AnyObject]()
}



class SharedSubCategory: NSObject {
    var strSubCategoryID = ""
    var strSubCategoryName = ""
    var strSubCategoryImage = ""
    var strSubCategoryThumbImage = ""
}

