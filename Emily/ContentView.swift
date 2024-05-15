//
//  ContentView.swift
//  Emily
//
//  Created by Justin Wimberly on 5/8/24.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State var shouldShowOnboarding: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                Text("You are in the main app")
                    .padding()
            }
            .navigationTitle("Home")
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding) {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        }
    }
}

struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    @State private var selectedTab: Int = 0 // Track the selected tab index
    @State private var birthday: Date = Date()
    @State private var healthDataObtained: Bool = false // Track health data obtained
    @State private var name: String = "" // Track user's name

    var body: some View {
        VStack {
            TabView(selection: $selectedTab) { // Add selection binding
                if !healthDataObtained {
                    HealthRequestView(title: "Welcome to Emily!",
                                      subtitle: "Emily needs to access your Health Data to properly predict your cycle.",
                                      imageName: "heart.square.fill",
                                      showsDismissButton: false,
                                      healthDataObtained: $healthDataObtained,
                                      shouldShowOnboarding: $shouldShowOnboarding)
                        .tag(0) // Set tag for the tab
                } else {
                    BirthdayView(birthday: $birthday, shouldShowOnboarding: $shouldShowOnboarding)
                        .tag(1) // Set tag for the tab
                    NameView(name: $name) // Pass the name binding
                        .tag(2) // Set tag for the tab
                }
            }
            .tabViewStyle(PageTabViewStyle()) // Set PageTabViewStyle
            
            // Next button appears when health access is granted
            if selectedTab == 0 && healthDataObtained {
                Button("Next") {
                    withAnimation {
                        selectedTab = 1 // Move to the next tab
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding()
                .transition(.opacity) // Apply fade animation
            } else if selectedTab == 1 {
                Button("Next") {
                    withAnimation {
                        selectedTab = 2 // Move to the next tab
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding()
                .transition(.opacity) // Apply fade animation
            } else if selectedTab == 2 {
                Button("Finish") {
                    withAnimation {
                        shouldShowOnboarding = false // Dismiss onboarding
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding()
                .transition(.opacity) // Apply fade animation
            }
        }
    }
}



struct HealthRequestView: View {
    let title: String
    let subtitle: String
    let imageName: String
    let showsDismissButton: Bool
    @Binding var healthDataObtained: Bool
    @Binding var shouldShowOnboarding: Bool

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            Text(subtitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            Image(systemName: imageName)
                .font(.largeTitle)
                .padding()
                .foregroundColor(.blue)
            
            if !healthDataObtained {
                Button("Allow Health Access") {
                    // Perform HealthKit operations to obtain data
                    HealthKitManager().requestAuthorization { success, error in
                        if let error = error {
                            // Handle the error
                            print("Error: \(error.localizedDescription)")
                        } else {
                            // Authorization successful
                            self.healthDataObtained = success
                        }
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct BirthdayView: View {
    @Binding var birthday: Date
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        VStack {
            Text("Please enter your birthday")
                .font(.title)
            DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
        }
        .padding()
    }
}

struct NameView: View {
    @Binding var name: String // Define the binding for the name

    var body: some View {
        VStack {
            Text("What is your name?")
                .font(.title)
                .padding()
            
            TextField("Enter your name", text: $name) // Bind the text field to the name binding
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        Spacer()
    }
}

