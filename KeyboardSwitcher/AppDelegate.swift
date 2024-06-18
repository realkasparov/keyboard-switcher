//
//  AppDelegate.swift
//  KeyboardSwitcher
//
//  Created by Aleksandr on 14/06/2024.
//

import Carbon
import Cocoa
import NaturalLanguage
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Создаем статусную иконку
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            let icon = NSImage(named: "AppIcon")
            icon?.size = NSSize(width: 18, height: 18) // Устанавливаем размер иконки
            button.image = icon
            //button.image?.isTemplate = true // Для корректного отображения в темной/светлой теме
            button.action = #selector(togglePopover(_:))
        }

        // Создаем popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 100, height: 20)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: StatusBarMenu())
        
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { (event) in
            if let chars = event.charactersIgnoringModifiers {
                self.handleKeyInput(chars)
            }
        }
    }

    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let button = statusItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
    
    func constructMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    @objc func quit() {
        NSApplication.shared.terminate(self)
    }

    func handleKeyInput(_ chars: String) {
        let detectedLanguage = detectLanguage(for: chars)
        if let languageCode = detectedLanguage {
            switch languageCode {
            case "en":
                switchToInputSource("com.apple.keylayout.US")
            case "ru":
                switchToInputSource("com.apple.keylayout.Russian")
            default:
                break
            }
        }
    }

    func detectLanguage(for text: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        return recognizer.dominantLanguage?.rawValue
    }

    func switchToInputSource(_ sourceID: String) {
        let sources = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
        for source in sources {
            let dict = source as! NSDictionary
            if let id = dict[kTISPropertyInputSourceID as String] as? String, id == sourceID {
                TISSelectInputSource(source as! TISInputSource)
            }
        }
    }
}
