//
//  HealthKitViewModel.swift
//  Emily
//
//  Created by Justin Wimberly on 5/4/24.
//


import Foundation
import HealthKit

class HealthKitViewModel: ObservableObject {
    
    private var healthStore = HKHealthStore()
    private var healthKitManager = HealthKitManager()
    @Published var wristTemperature: String = ""
    @Published var isAuthorized: Bool = false

    
    func healthRequest() {
        healthKitManager.setUpHealthRequest(healthStore: healthStore) {
            self.changeAuthorizationStatus()
            self.readWristTemperatureToday()
        }
    }
    
    func readWristTemperatureToday() {
            healthKitManager.readWristTemperature(forDate: Date(), healthStore: healthStore) { temperature in
                DispatchQueue.main.async {
                    self.wristTemperature = String(format: "%.1f°F", temperature)
                }
            }
        }
    
    func changeAuthorizationStatus() {
        guard let wristTemperatureType = HKObjectType.quantityType(forIdentifier: .appleSleepingWristTemperature),
              let bodyTemperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature) else { return }
        let typesToRequest: Set<HKObjectType> = [wristTemperatureType, bodyTemperatureType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRequest) { (success, error) in
            if success {
                self.isAuthorized = true
            } else {
                self.isAuthorized = false
                if let error = error {
                    print("HealthKit authorization error: \(error.localizedDescription)")
                }
            }
        }
    }
}


