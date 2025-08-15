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

@main
struct CoreDiscApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .overlay(alignment: .bottom) {
                    GlobalToastView()
                }
        }
    }
}
