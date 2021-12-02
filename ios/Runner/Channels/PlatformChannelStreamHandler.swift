//
//  PlatformChannelStreamHandler.swift
//  Runner
//
//  Created by endo_shunya on 2021/12/01.
//

import Flutter
import Reachability
import UIKit

class PlatformChannelStreamHandler: NSObject, FlutterStreamHandler {
    let reachability: Reachability?
    var eventSink: FlutterEventSink?
    private let cellular = 1
    private let wifi = 2
    private let disconnected = 0

    init(reachability: Reachability?) {
        self.reachability = reachability
    }

    public func onListen(withArguments _: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        
        onNetworkStatusChange()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNetworkStatusChange), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
            try reachability?.startNotifier()
        } catch {
           return FlutterError(code: "1", message: "Could not start notififer", details: nil)
        }
        return nil
    }

    public func onCancel(withArguments _: Any?) -> FlutterError? {
        eventSink = nil
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
        return nil
    }

    
    @objc private func onNetworkStatusChange() {
        guard let sink = eventSink else {
            return
        }
        switch reachability?.connection {
        case .wifi:
            sink(self.wifi)
        case .cellular:
            sink(self.cellular)
        case .unavailable:
            sink(self.disconnected)
        default:
            sink(self.disconnected)
        }
    }
}

