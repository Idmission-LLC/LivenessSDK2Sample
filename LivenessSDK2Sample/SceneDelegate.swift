//
//  SceneDelegate.swift
//  LivenessSDK2Sample
//
//  Created by Amol Deshmukh on 29/04/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var privacyShieldView: UIView?
    private var observers: [NSObjectProtocol] = []


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        // Observe screen capture (recording/mirroring), screenshots, and app activity transitions
        addObservers()

        // Apply initial protection state if capture is already active
        if UIScreen.main.isCaptured {
            showPrivacyShield(animated: false)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        // Remove shield unless a screen capture is ongoing
        if UIScreen.main.isCaptured == false {
            hidePrivacyShield(animated: true)
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        // Show shield to protect content in the app switcher snapshot
        showPrivacyShield(animated: false)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

// MARK: - Privacy Protection
extension SceneDelegate {
    private func addObservers() {
        let center = NotificationCenter.default

        // Screen recording / mirroring status changed
        let captureObserver = center.addObserver(forName: UIScreen.capturedDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            if UIScreen.main.isCaptured {
                self.showPrivacyShield(animated: true)
            } else {
                self.hidePrivacyShield(animated: true)
            }
        }
        observers.append(captureObserver)

        // User took a screenshot (cannot prevent, but obscure content immediately after)
        let screenshotObserver = center.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.flashPrivacyShield()
        }
        observers.append(screenshotObserver)

        // Clean up observers on termination
        let terminateObserver = center.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { [weak self] _ in
            self?.removeObservers()
        }
        observers.append(terminateObserver)
    }

    private func removeObservers() {
        let center = NotificationCenter.default
        observers.forEach { center.removeObserver($0) }
        observers.removeAll()
    }

    private func buildPrivacyShieldViewIfNeeded() {
        guard privacyShieldView == nil, let window = window else { return }

        let shield = UIView(frame: window.bounds)
        shield.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shield.backgroundColor = UIColor.systemBackground

        // Optional: add a subtle label to indicate protection
        let label = UILabel()
        label.text = "Screen capture disabled"
        label.textAlignment = .center
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        // Add a blur for nicer appearance
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = shield.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shield.addSubview(blurView)
        shield.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: shield.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: shield.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: shield.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(lessThanOrEqualTo: shield.trailingAnchor, constant: -24)
        ])

        // Start hidden
        shield.alpha = 0
        shield.isHidden = true

        window.addSubview(shield)
        privacyShieldView = shield
    }

    private func showPrivacyShield(animated: Bool) {
        buildPrivacyShieldViewIfNeeded()
        guard let shield = privacyShieldView else { return }
        shield.isHidden = false
        if animated {
            UIView.animate(withDuration: 0.2) {
                shield.alpha = 1
            }
        } else {
            shield.alpha = 1
        }
    }

    private func hidePrivacyShield(animated: Bool) {
        guard let shield = privacyShieldView, shield.isHidden == false else { return }
        let animations = {
            shield.alpha = 0
        }
        let completion: (Bool) -> Void = { _ in
            shield.isHidden = true
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: animations, completion: completion)
        } else {
            animations()
            completion(true)
        }
    }

    private func flashPrivacyShield() {
        // Briefly show the shield to discourage screenshots. This cannot prevent the OS capture.
        showPrivacyShield(animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            if UIScreen.main.isCaptured == false {
                self.hidePrivacyShield(animated: true)
            }
        }
    }
}

