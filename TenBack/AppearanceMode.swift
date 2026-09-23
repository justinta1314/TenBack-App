//
//  AppearanceMode.swift
//  TenBack
//
//  Created by Justin Ta on 9/23/26.
//

import SwiftUI
 
enum AppearanceMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
 
    var id: String { rawValue }
 
    var label: String {
        switch self {
        case .system: return "Follow Device"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
 
    /// Maps to SwiftUI's colorScheme override. `nil` means "don't override — follow system."
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
 
