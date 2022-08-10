//
//  CustomDateFormatter.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 09.08.2022.
//

import Foundation

final class CustomDateFormatter: DateFormatter {
    
    static let shared = CustomDateFormatter()
    
    private override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var day: DateFormatter {
        self.dateFormat = "E"
        return self
    }
    
    var date: DateFormatter {
        self.dateFormat = "MM.dd"
        return self
    }
    
    var hour: DateFormatter {
        self.dateFormat = "HH:mm"
        return self
    }
}
