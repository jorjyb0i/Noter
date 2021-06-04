//
//  Note+CoreDataProperties.swift
//  Noter
//
//  Created by jorjyb0i on 15.02.2021.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var document_name: String?
    @NSManaged public var document_type: String?
    @NSManaged public var id: Int64
    @NSManaged public var serialized: String?

}

extension Note : Identifiable {

}
