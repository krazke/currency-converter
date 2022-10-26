//
//  UIControl+Publisher.swift
//  currency-converter
//
//  Created by krazke on 09.10.2022.
//

import Combine
import UIKit
import Foundation

// MARK: - Event Publisher

struct UIControlPublisher<Control: UIControl>: Publisher {
    typealias Output = Control
    typealias Failure = Never

    let control: Control
    let controlEvent: UIControl.Event

    init(
        control: Control,
        event: UIControl.Event
    ) {
        self.control = control
        self.controlEvent = event
    }

    func receive<S>(subscriber: S) where
        S: Subscriber,
        S.Failure == Self.Failure,
        S.Input == Self.Output {
        let subscription: UIControlSubscription = .init(
            subscriber: subscriber,
            control: control,
            event: controlEvent
        )
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - Notification Publisher

struct UIControlNotifcationPublisher<Control: UIControl>: Publisher {
    typealias Output = Notification
    typealias Failure = Never

    let control: Control
    let controlNotificationEvent: Notification.Name

    init(
        control: Control,
        event: Notification.Name
    ) {
        self.control = control
        self.controlNotificationEvent = event
    }

    func receive<S>(subscriber: S) where
        S: Subscriber,
        S.Failure == Self.Failure,
        S.Input == Self.Output {
        let subscription: UIControlNotificationSubscription = .init(
            subscriber: subscriber,
            control: control,
            event: controlNotificationEvent
        )
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - Extension

extension CombineCompatible where Self: UIControl {
    func publisher(for event: UIControl.Event) -> UIControlPublisher<Self> {
        .init(
            control: self,
            event: event
        )
    }

    func publisher(for event: Notification.Name) -> UIControlNotifcationPublisher<Self> {
        .init(
            control: self,
            event: event
        )
    }
}
