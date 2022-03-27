//
//  DateExtensions.swift
//  ToDo
//
//  Created by Nitesh on 27/03/22.
//

import Foundation
public extension Date {
    
    var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier)
    }
    
    var isInToday: Bool {
        return calendar.isDateInToday(self)
    }
    
    var isInTomorrow: Bool {
        return calendar.isDateInTomorrow(self)
    }
    
    var tomorrow: Date {
        return calendar.date(byAdding: .day, value: 1, to: self) ?? Date()
    }
}
