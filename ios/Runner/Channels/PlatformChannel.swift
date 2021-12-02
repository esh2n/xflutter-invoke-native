//
//  PlatformChannel.swift
//  Runner
//
//  Created by endo_shunya on 2021/12/01.
//

import Foundation
import Reachability
import Flutter

class PlatformChannel: NSObject {
    private let reachability = try! Reachability()
    private let methodChannelName = "platform_channel/method_channel"
    private let eventChannelName = "platform_channel/event_channel"
    
    public func handle(controller: FlutterViewController) -> Void {
        self.methodChannel(controller: controller)
        self.eventChannel(controller: controller)
    }
    
    public func methodChannel(controller: FlutterViewController) -> Void {
        let channel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "isReachable" {
                if self.reachability.connection == .unavailable {
                    result(false)
                }
                result(true)
            }
        })
    }
    
    public func eventChannel(controller: FlutterViewController) -> Void {
        let channel = FlutterEventChannel(name: eventChannelName, binaryMessenger: controller.binaryMessenger)
        channel.setStreamHandler(PlatformChannelStreamHandler(reachability: reachability))
    }
}
