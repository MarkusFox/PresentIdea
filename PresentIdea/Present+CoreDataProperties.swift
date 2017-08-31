//
//  Present+CoreDataProperties.swift
//  PresentIdea
//
//  Created by Markus Fox on 29.08.17.
//  Copyright © 2017 Markus Fox. All rights reserved.
//

import Foundation
import CoreData


extension Present {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Present> {
        return NSFetchRequest<Present>(entityName: "Present")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var person: String?
    @NSManaged public var presentName: String?

}
