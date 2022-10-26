//
//  KeyboardObserver.swift
//  currency-converter
//
//  Created by krazke on 25.10.2022.
//

import Combine
import Foundation
import UIKit

final class KeyboardObserver {
    // MARK: - Dependencies

    private let notificationCenter: NotificationCenter = .default

    // MARK: - Properties

    var onKeyboardEvent: AnyPublisher<KeyboardParameters, Never> {
        _onKeyboardEvent.eraseToAnyPublisher()
    }

    private let _onKeyboardEvent: PassthroughSubject<KeyboardParameters, Never> = .init()
    private var observers: [NSObjectProtocol] = .init()

    // MARK: - Lifecycle

    deinit {
        stopListening()
    }
}

// MARK: - KeyboardObserverInterface

extension KeyboardObserver: KeyboardObserverInterface {
    func startListening() {
        observers = [
            addObserver(UIResponder.keyboardWillShowNotification),
            addObserver(UIResponder.keyboardDidShowNotification),
            addObserver(UIResponder.keyboardWillHideNotification),
            addObserver(UIResponder.keyboardDidHideNotification)
        ]
    }

    func stopListening() {
        observers.forEach(notificationCenter.removeObserver)
        observers.removeAll()
    }
}

// MARK: - Private

private extension KeyboardObserver {
    func addObserver(_ name: Notification.Name) -> NSObjectProtocol {
        notificationCenter.addObserver(forName: name, object: nil, queue: nil) { [weak self] notification in
            guard let self = self,
                  let state: KeyboardState = self.fetchState(name),
                  let parameters: KeyboardParameters = self.fetchParameters(notification, state: state)
            else { return }
            self._onKeyboardEvent.send(parameters)
        }
    }

    func fetchState(_ name: Notification.Name) -> KeyboardState? {
        switch name {
        case UIResponder.keyboardWillShowNotification:
            return .willShow
        case UIResponder.keyboardDidShowNotification:
            return .didShow
        case UIResponder.keyboardWillHideNotification:
            return .willHide
        case UIResponder.keyboardDidHideNotification:
            return .didHide
        default:
            return nil
        }
    }

    func fetchParameters(_ notification: Notification, state: KeyboardState) -> KeyboardParameters? {
        guard let info: [AnyHashable: Any] = notification.userInfo,
              let rect: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let time: TimeInterval = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve: UInt = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return nil }
        return .init(
            rect: rect,
            animationTime: time,
            animationCurve: curve,
            state: state
        )
    }
}
