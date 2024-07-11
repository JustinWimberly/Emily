import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @State private var healthKitAuthorized = false
    @State private var selectedOption = 0
    @State private var selectedDate = Date()


    var body: some View {
        ZStack {
            AnimatedMeshView()
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                if currentStep == 0 {
                    WelcomeView()
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                } else if currentStep == 1 {
                    PrivacyView(healthKitAuthorized: $healthKitAuthorized)
                        .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity).animation(.easeInOut))
                } else if currentStep == 2 {
                    PersonalInfoView()
                        .transition(AnyTransition.move(edge: .leading).combined(with: .opacity).animation(.easeInOut))
                } else if currentStep == 3 {
                    PickerStepView(selectedDate: $selectedDate)
                                            .transition(AnyTransition.move(edge: .bottom)
                                                .combined(with: .opacity)
                                                .animation(.easeInOut))
                } else {
                    EmptyView()
                }
                
                Spacer()
                
                HStack {
                    if currentStep > 0 {
                        Button(action: {
                            withAnimation {
                                currentStep -= 1
                            }
                        }) {
                            Text("Back")
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            if currentStep == 3 {
                                hasCompletedOnboarding = true
                            } else {
                                currentStep += 1
                            }
                        }
                    }) {
                        Text(currentStep == 4 ? "Welcome to Emily!" : "Next")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(currentStep == 1 && !healthKitAuthorized)
                    .opacity((currentStep == 1 && !healthKitAuthorized) ? 0.5 : 1)
                }
                .padding(.horizontal)
            }
            .animation(.easeInOut, value: currentStep)
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to Emily!")
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding()
            Text("Your cycle tracking and fertility assistant.")
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

struct PrivacyView: View {
    @Binding var healthKitAuthorized: Bool
    
    var body: some View {
        VStack {
            Text("We Value Your Privacy")
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding()
            Text("To provide the best experience, we need access to some of your health data.")
                .font(.subheadline)
                .foregroundColor(.black)
                .multilineTextAlignment(.center).padding()
            Button(action: {
                HealthKitManager.shared.requestAuthorization { success in
                    DispatchQueue.main.async {
                        healthKitAuthorized = success
                    }
                }
            }) {
                Text("Authorize HealthKit")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(healthKitAuthorized)
            .opacity(healthKitAuthorized ? 0.5 : 1)
        }
    }
}

struct PickerStepView: View {
    @Binding var selectedDate: Date

    var body: some View {
        VStack {
            Text("Select Your Birthday")
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding()

            DatePicker(
                "Select your date of birth",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            .datePickerTextColor(.black) // Apply custom text color modifier
        }
    }
}


import SwiftUI

struct DatePickerTextColor: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .accentColor(color)
            .colorScheme(.dark)
    }
}

extension View {
    func datePickerTextColor(_ color: Color) -> some View {
        self.modifier(DatePickerTextColor(color: color))
    }
}



struct PersonalInfoView: View {
    @State private var name = ""
    @State private var height = ""
    @State private var weight = ""
    
    var body: some View {
        VStack {
            Text("Tell Us About Yourself!")
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding()
            Text("Help us personalize your experience.")
                .font(.subheadline)
                .foregroundColor(.black)
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .foregroundColor(.white)
            TextField("Height (ex. 510)", text: $height)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .foregroundColor(.white)
            TextField("Weight in pounds", text: $weight)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .foregroundColor(.white)
        }
    }
}

struct AnimatedMeshView: View {
    @State var t: Float = 0.0
    @State var timer: Timer?

    var body: some View {
        if #available(iOS 18.0, *) {
            MeshGradient(width: 3, height: 3, points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                
                [sinInRange(-0.8...(-0.2), offset: 0.439, timeScale: 0.342, t: t), sinInRange(0.3...0.7, offset: 3.42, timeScale: 0.984, t: t)],
                [sinInRange(0.1...0.8, offset: 0.239, timeScale: 0.084, t: t), sinInRange(0.2...0.8, offset: 5.21, timeScale: 0.242, t: t)],
                [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.084, t: t), sinInRange(0.4...0.8, offset: 0.25, timeScale: 0.642, t: t)],
                [sinInRange(-0.8...0.0, offset: 1.439, timeScale: 0.442, t: t), sinInRange(1.4...1.9, offset: 3.42, timeScale: 0.984, t: t)],
                [sinInRange(0.3...0.6, offset: 0.339, timeScale: 0.784, t: t), sinInRange(1.0...1.2, offset: 1.22, timeScale: 0.772, t: t)],
                [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.056, t: t), sinInRange(1.3...1.7, offset: 0.939, timeScale: 0.342, t: t)]
            ], colors: [
                .pink, .pink, .pink,
                .pink, .white, .pink,
                .white, .pink, .white
            ])
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                    t += 0.02
                }
            }
            .background(.black)
            .ignoresSafeArea()
        } else {
            VersionNotSupportedView()
        }
    }

    func sinInRange(_ range: ClosedRange<Float>, offset: Float, timeScale: Float, t: Float) -> Float {
        let amplitude = (range.upperBound - range.lowerBound) / 2
        let midPoint = (range.upperBound + range.lowerBound) / 2
        return midPoint + amplitude * sin(timeScale * t + offset)
    }
}


#Preview {
    OnboardingView()
}
