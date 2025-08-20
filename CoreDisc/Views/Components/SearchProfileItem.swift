//
//  SearchProfileItem.swift
//  CoreDisc
//
//  Created by 이채은 on 7/23/25.
//
import SwiftUI
import Kingfisher

struct SearchProfileItem: View {
    var nickname: String
    var username: String
    var imageURL: String? = nil
    var onTap: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 12) {
            if let url = URL(string: imageURL ?? "") {
                KFImage(url)
                    .downsampling(size: CGSize(width: 64, height: 64))
                    .cacheOriginalImage()
                    .retry(maxCount: 2, interval: .seconds(2))
                    .cancelOnDisappear(true)
                    .placeholder {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 32, height: 32)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(nickname)
                        .textStyle(.Button_s)
                    Spacer()
                }
                HStack {
                    Text(username)
                        .textStyle(.Pick_Q_Eng)
                    Spacer()
                }
            }
            .foregroundStyle(.white)
            .padding(.vertical, 16)
        }
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SearchProfileItem(
        nickname: "뮤직사마",
        username: "@music_sama",
        imageURL: "https://picsum.photos/80"
    )
}

