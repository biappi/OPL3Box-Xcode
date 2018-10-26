//
//  AppDelegate.swift
//  Box
//
//  Created by Antonio Malara on 26/10/2018.
//  Copyright © 2018 Antonio Malara. All rights reserved.
//

import Cocoa
import WebKit
import CoreMIDI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, WKScriptMessageHandler {

    @IBOutlet weak var window: NSWindow!
    
    var webView: WKWebView!
    var midiClient  = MIDIClientRef()
    var outEndpoint = MIDIEndpointRef()
    var midiWidgets = [String: (channel: UInt8, cc: UInt8)]()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let configuration = WKWebViewConfiguration()
        let controller = WKUserContentController()
        
        configuration.userContentController = controller
        webView = WKWebView(frame: window.contentView!.frame, configuration: configuration)
        webView.autoresizingMask = [.width, .height]
        window.contentView?.addSubview(webView)
        controller.add(self, name: "sendOsc")
        
        let base = Bundle.main.url(forResource: "browser", withExtension: nil)!
        webView.loadFileURL(base.appendingPathComponent("index.html"), allowingReadAccessTo: base)
        
        MIDIClientCreate("OPL3Box Panel" as CFString, nil, nil, &midiClient)
        MIDISourceCreate(midiClient, "OPL3Box Panel Source" as CFString, &outEndpoint)
    }

    func sendMidi(_ toSend: [UInt8]) {
        var data = Data(count: 1024)
        let dataCount = data.count
        data.withUnsafeMutableBytes { (packetListPointer: UnsafeMutablePointer<MIDIPacketList>) in
            let packetList = MIDIPacketListInit(packetListPointer)
            MIDIPacketListAdd(packetListPointer, dataCount, packetList, 0, toSend.count, toSend)
            MIDIReceived(outEndpoint, packetListPointer)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let bodyDict = message.body as? Dictionary<String, Any>
        let event = bodyDict?["event"] as? String
        
        switch event {
        case "addWidget":
            let event = bodyDict?["data"] as? Dictionary<String, Any>
            let data =  event?["data"] as? Dictionary<String, Any>
            if
                let hash = event?["hash"] as? String,
                let address = data?["address"] as? String,
                address == "/control",
                let preArgs = data?["preArgs"] as? [Int],
                let channel = preArgs.first,
                let control = preArgs.last
            {
                midiWidgets[hash] = (UInt8(channel), UInt8(control))
            }
            
        case "sendOsc":
            let event = bodyDict?["data"] as? Dictionary<String, Any>
            if
                let hash = event?["h"] as? String,
                let value = event?["v"] as? Double,
                let (channel, control) = midiWidgets[hash]
            {
                let v = UInt8(value)
                sendMidi([ 0xb0 | (channel & 0xf), control & 0x7f, v])
            }

        default:
            break
        }
    }
}
