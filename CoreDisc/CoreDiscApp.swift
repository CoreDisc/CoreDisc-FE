//
//  CoreDiscApp.swift
//  CoreDisc
//
//  Created by 김미주 on 6/28/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import NidThirdPartyLogin

@main
struct CoreDiscApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        NidOAuth.shared.initialize()
        NidOAuth.shared.setLoginBehavior(.appPreferredWithInAppBrowserFallback)
    }
    
    var body: some Scene {
        WindowGroup {
            OnboardingTabContainer()
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                    if (NidOAuth.shared.handleURL(url) == true) {
                      return
                    }
                }
                .overlay(alignment: .bottom) {
                    GlobalToastView()
                }
                .environmentObject(TabBarVisibility())
        }
    }
}
