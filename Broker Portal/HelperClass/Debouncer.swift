//
//  Debouncer.swift
//  Broker Portal
//
//  Created by Pankaj on 28/04/25.
//

import Foundation

final class Debouncer {
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    private let delay: TimeInterval

    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }

    func run(action: @escaping () -> Void) {
        // Cancel the previous work item if it exists
        workItem?.cancel()

        // Create a new work item
        workItem = DispatchWorkItem(block: action)

        // Execute the work item after the delay
        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}
