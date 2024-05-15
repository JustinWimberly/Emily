//
//  HealthKitManager.swift
//  Emily
//
//  Created by Justin Wimberly on 5/4/24.
//

import SwiftUI
import HealthKit

class HealthKitManager {
    
    let healthStore = HKHealthStore()
    let allTypes: Set<HKSampleType> = [
        HKSampleType.quantityType(forIdentifier: .basalBodyTemperature)!,
        HKSampleType.quantityType(forIdentifier: .bodyTemperature)!
    ]
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { success, error in
            completion(success, error)
        }
    }
}

    struct MyHealthAccessView: View {
    @Binding var healthDataObtained: Bool
    @State private var authenticated = false
    @State private var trigger = false
    let healthKitManager = HealthKitManager()

    var body: some View {
        Button("Access health data") {
            // Request HealthKit authorization when the button is pressed
            healthKitManager.requestAuthorization { success, error in
                if let error = error {
                    // Handle the error
                    fatalError("*** An error occurred while requesting authentication: \(error.localizedDescription) ***")
                } else {
                    // Authorization successful
                    authenticated = success
                    if success {
                        // Set healthDataObtained to true when health data is obtained
                        healthDataObtained = true
                    }
                }
            }
        }
        .disabled(authenticated) // Disable the button if already authenticated
    }
}


