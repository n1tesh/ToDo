//
//  StringExtensions.swift
//  ToDo
//
//  Created by Nitesh on 27/03/22.
//

import Foundation

extension String {
    
    var isWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}
