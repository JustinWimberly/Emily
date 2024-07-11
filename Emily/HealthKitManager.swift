//
//  HealthKitManager.swift
//  Emily
//
//  Created by Justin Wimberly on 7/10/24.
//

import HealthKit

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { success, error in
            completion(success)
        }
    }
}
