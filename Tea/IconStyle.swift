//
//  IconStyle.swift
//  Tea
//

import Foundation

enum IconStyle: String, CaseIterable, Identifiable {
    case leaf
    case cupAndSaucer
    case sunMax
    case carrot

    var id: String { rawValue }

    static let appStorageKey = "iconStyle"

    var menuTitle: String {
        switch self {
        case .leaf: return "Leaf"
        case .cupAndSaucer: return "Cup & Saucer"
        case .sunMax: return "Sun"
        case .carrot: return "Carrot"
        }
    }

    func systemImage(isActive: Bool) -> String {
        switch self {
        case .leaf:
            return isActive ? "leaf.fill" : "leaf"
        case .cupAndSaucer:
            return isActive ? "cup.and.saucer.fill" : "cup.and.saucer"
        case .sunMax:
            return isActive ? "sun.max.fill" : "sun.max"
        case .carrot:
            return isActive ? "carrot.fill" : "carrot"
        }
    }
}
