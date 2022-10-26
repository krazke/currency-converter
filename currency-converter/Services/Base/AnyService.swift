//
//  AnyService.swift
//  currency-converter
//
//  Created by krazke on 07.10.2022.
//

import Combine
import Dispatch

protocol AnyService: AnyObject {
    var workingQueue: DispatchQueue { get }
    var responseQueue: DispatchQueue { get }
}

extension AnyService {
    var workingQueue: DispatchQueue {
        .init(
            label: serviceQueueName,
            qos: .utility
        )
    }

    var responseQueue: DispatchQueue { .main }

    var serviceQueueName: String {
        "services.\(String(describing: self))"
    }

    func performInWorkingQueue(_ block: @escaping () -> Void) {
        workingQueue.async(execute: block)
    }

    func performInResponseQueue(_ block: @escaping () -> Void) {
        responseQueue.async(execute: block)
    }
}
