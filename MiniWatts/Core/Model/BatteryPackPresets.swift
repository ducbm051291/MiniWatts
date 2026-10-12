import Foundation

/// Approximate usable pack energy for the %-rate discharge estimate.
///
/// Apple does not publish Wh for every model, and the sandbox usually withholds
/// `DesignCapacity`. These figures are community / teardown estimates — good enough
/// for order-of-magnitude watts from %/h, not a laboratory rating.
nonisolated enum BatteryPackPreset: String, CaseIterable, Identifiable, Sendable {
    case custom
    case iPhone15
    case iPhone15Plus
    case iPhone15Pro
    case iPhone15ProMax
    case iPhone16
    case iPhone16Plus
    case iPhone16Pro
    case iPhone16ProMax
    case iPhone17
    case iPhoneAir
    case iPhone17Pro
    case iPhone17ProMax

    var id: String { rawValue }

    /// Nil only for `.custom` — the user types Wh with the stepper.
    var wattHours: Double? {
        switch self {
        case .custom: return nil
        case .iPhone15: return 12.5
        case .iPhone15Plus: return 13.0
        case .iPhone15Pro: return 12.7
        case .iPhone15ProMax: return 17.3
        case .iPhone16: return 13.0
        case .iPhone16Plus: return 14.5
        case .iPhone16Pro: return 13.8
        case .iPhone16ProMax: return 17.5
        case .iPhone17: return 14.0
        case .iPhoneAir: return 12.0
        case .iPhone17Pro: return 15.0
        case .iPhone17ProMax: return 19.7
        }
    }

    /// `utsname.machine` identifiers this preset belongs to.
    var machineIdentifiers: Set<String> {
        switch self {
        case .custom: return []
        case .iPhone15: return ["iPhone15,4"]
        case .iPhone15Plus: return ["iPhone15,5"]
        case .iPhone15Pro: return ["iPhone16,1"]
        case .iPhone15ProMax: return ["iPhone16,2"]
        case .iPhone16: return ["iPhone17,3"]
        case .iPhone16Plus: return ["iPhone17,4"]
        case .iPhone16Pro: return ["iPhone17,1"]
        case .iPhone16ProMax: return ["iPhone17,2"]
        case .iPhone17: return ["iPhone18,3"]
        case .iPhoneAir: return ["iPhone18,4"]
        case .iPhone17Pro: return ["iPhone18,1"]
        case .iPhone17ProMax: return ["iPhone18,2"]
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .custom: return "Custom"
        case .iPhone15: return "iPhone 15"
        case .iPhone15Plus: return "iPhone 15 Plus"
        case .iPhone15Pro: return "iPhone 15 Pro"
        case .iPhone15ProMax: return "iPhone 15 Pro Max"
        case .iPhone16: return "iPhone 16"
        case .iPhone16Plus: return "iPhone 16 Plus"
        case .iPhone16Pro: return "iPhone 16 Pro"
        case .iPhone16ProMax: return "iPhone 16 Pro Max"
        case .iPhone17: return "iPhone 17"
        case .iPhoneAir: return "iPhone Air"
        case .iPhone17Pro: return "iPhone 17 Pro"
        case .iPhone17ProMax: return "iPhone 17 Pro Max"
        }
    }

    static var selectable: [BatteryPackPreset] {
        allCases
    }

    static func matching(machineIdentifier: String) -> BatteryPackPreset? {
        allCases.first { $0.machineIdentifiers.contains(machineIdentifier) }
    }

    /// Which menu row matches the value the stepper currently holds.
    static func matching(wattHours: Double, tolerance: Double = 0.05) -> BatteryPackPreset {
        for preset in allCases where preset != .custom {
            if let target = preset.wattHours, abs(target - wattHours) <= tolerance {
                return preset
            }
        }
        return .custom
    }
}
