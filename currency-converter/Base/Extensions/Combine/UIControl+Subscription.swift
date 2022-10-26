//
//  UIControl+Subscription.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import Combine
import UIKit

// MARK: - Event Subscription

final class UIControlSubscription
<SubscriberType: Subscriber, Control: UIControl>: Subscription
    where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(
        subscriber: SubscriberType,
        control: Control,
        event: UIControl.Event
    ) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
        subscriber = nil
    }

    @objc
    private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

// MARK: - Notification Subscription

final class UIControlNotificationSubscription
<SubscriberType: Subscriber, Control: UIControl>: Subscription
    where SubscriberType.Input == Notification {
    private var subscriber: SubscriberType?
    private let control: Control
    private let notificationCenter: NotificationCenter = .default
    private var observer: AnyObject?

    init(subscriber: SubscriberType, control: Control, event: Notification.Name) {
        self.subscriber = subscriber
        self.control = control
        observer = notificationCenter.addObserver(
            forName: event,
            object: control,
            queue: nil
        ) { [weak self] in
            _ = self?.subscriber?.receive($0)
        }
    }

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
        subscriber = nil
        observer = nil
    }
}
