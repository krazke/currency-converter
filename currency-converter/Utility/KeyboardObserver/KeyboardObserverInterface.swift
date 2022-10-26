//
//  KeyboardObserverInterface.swift
//  currency-converter
//
//  Created by krazke on 25.10.2022.
//

import Combine

protocol KeyboardObserverInterface: AnyObject {
    var onKeyboardEvent: AnyPublisher<KeyboardParameters, Never> { get }
    
    func startListening()
    func stopListening()
}
