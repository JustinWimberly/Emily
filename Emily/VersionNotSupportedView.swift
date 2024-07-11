//
//  VersionNotSupportedView.swift
//  Emily
//
//  Created by Justin Wimberly on 7/10/24.
//

import SwiftUI

struct VersionNotSupportedView: View {
    let iosVersion = UIDevice.current.systemVersion
    var body: some View {
        Text("Your iOS Version Is No Longer Supported")
            .font(.title)
            .multilineTextAlignment(.center)
            .padding(.top, 20)
        Text("Your Current iOS Version")
            .font(.title3)
            .padding(.top, 40)
        Text("iOS: \(iosVersion) ")
        Text("Please Update to iOS 18 or Higher ")
            .font(.title2)
            .padding(.top, 250)
    }
}

#Preview {
    VersionNotSupportedView()
}
