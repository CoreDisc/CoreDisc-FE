//
//  OnboardingTabContainer.swift
//  CoreDisc
//
//  Created by 김미주 on 8/18/25.
//

import SwiftUI

struct OnboardingTabContainer: View {
    @State private var router = NavigationRouter<OnboardingRoute>()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            LoginView()
                .navigationDestination(for: OnboardingRoute.self) { route in
                    switch route {
                    case .login:
                        LoginView()
                    case .signup:
                        SignupView()
                    case .findId:
                        FindIdView()
                    case .findPw:
                        FindPwView()
                    }
                }
        }
        .environment(router)
    }
}

#Preview {
    OnboardingTabContainer()
}
