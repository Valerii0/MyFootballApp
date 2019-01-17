//
//  ExtensionsForUILocalizedIndexedCollation.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/9/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation
import UIKit

let collation = UILocalizedIndexedCollation.current()
//
//+current() func create a locale collation object, by which we can get section index titles of current locale.
//
//Add this extension of UILocalizedIndexedCollation in your project

extension UILocalizedIndexedCollation {
    //func for partition array in sections
    func partitionObjects(array: [AnyObject], collationStringSelector: Selector) -> ([AnyObject], [String]) {
        var unsortedSections = [[AnyObject]]()
        //1. Create a array to hold the data for each section
        for _ in self.sectionTitles {
            unsortedSections.append([]) //appending an empty array
        }
        //2. Put each objects into a section
        for item in array {
            let index:Int = self.section(for: item, collationStringSelector:collationStringSelector)
            unsortedSections[index].append(item)
        }
        //3. sorting the array of each sections
        var sectionTitles = [String]()
        var sections = [AnyObject]()
        for index in 0 ..< unsortedSections.count { if unsortedSections[index].count > 0 {
            sectionTitles.append(self.sectionTitles[index])
            sections.append(self.sortedArray(from: unsortedSections[index], collationStringSelector: collationStringSelector) as AnyObject)
            }
        }
        return (sections, sectionTitles)
    }
}



