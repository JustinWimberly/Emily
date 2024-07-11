//
//  EmilyApp.swift
//  Emily
//
//  Created by Justin Wimberly on 5/4/24.
//

import SwiftUI

@main
struct PeriodTrackingApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                DashboardView()
            } else {
                OnboardingView()
            }
        }
    }
}





