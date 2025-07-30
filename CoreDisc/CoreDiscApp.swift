//
//  CoreDiscApp.swift
//  CoreDisc
//
//  Created by 김미주 on 6/28/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct CoreDiscApp: App {
//    init() {
//        let kakaoNativeAppKey = (Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String) ?? ""
//        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
//    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
//                .onOpenURL { url in
//                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
//                        _ = AuthController.handleOpenUrl(url: url)
//                    }
//                }
        }
    }
}
