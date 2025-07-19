//
//  PostDetailMainView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/17/25.
//

import SwiftUI

enum postCategoryTap : String, CaseIterable {
    case all = "All"
    case followers = "Followers"
    case core = "Core"
    case privatePost = "Private"
}

struct PostDetailMainView: View {
    @State private var selectedTab: postCategoryTap = .all
    @Namespace private var animation
    
    var body: some View {
        ZStack{
            Image(.imgPostDetailMainBg)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                TitleGroup
                
                CategoryGroup
                
                ScrollView{
                    PostGroup
                }
            }
        }
    }
    
    // 로고 타이틀 섹션
     private var TitleGroup: some View {
         HStack{
             // TODO: 로고 디자인 완료 시 추가 예정
             Text("logo 추가 예정")
             
             Spacer()
             
             Button(action:{}){
                 Image(.iconAlert)
                     .resizable()
                     .frame(width:40, height: 48)
                     .foregroundStyle(.black000)
             }
     }

     .padding(.horizontal,19)
     }
    
    // 카테고리 메뉴바 섹션
    private var CategoryGroup: some View {
        HStack {
            PostTopTabView(selectedTab: $selectedTab, animation: animation)
        }
    }

    // 게시글 섹션
    private var PostGroup: some View {
        VStack(spacing: 16){
            Spacer().frame(height: 25)
            
            switch selectedTab {
                    case .all:
                        postSection()
                        postSection()
                        postSection()
                        postSection()
                    case .followers:
                        Text("Followers")
                    case .core:
                        Text("Core")
                    case .privatePost:
                        Text("Private")
                    }
        }
        .padding(.horizontal, 19)
    }
    
    private func postSection() -> some View {
        HStack (alignment: .center, spacing: 36) {
            PostCard(Thumbnail_text: "계절마다 떠오르는 음식이 있나요? 요즘 생각나는 건 뭐예요?", userID: "@coredisc.ko")
            PostCard(Thumbnail_text: "계절마다 떠오르는 음식이 있나요? 요즘 생각나는 건 뭐예요?", userID: "@coredisc.ko" )
        }
    }
}

// 게시물 카드
struct PostCard: View {
    var Thumbnail_text: String
    var userID: String
    
    var body: some View {
            ZStack{
                Rectangle()
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                    .frame(width: 164, height: 271)

                
                VStack(spacing: 8){
                    // 추후 게시물 사진으로 변경
                    Rectangle()
                        .frame(width: 164.25, height: 219)
                        .cornerRadius(12, corners: [.topLeft, .topRight])
                        .foregroundStyle(.gray200)
                    
                    HStack(spacing: 3) {
                        // 추후 프로필 사진으로 변경
                        Circle()
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(Thumbnail_text)")
                                .textStyle(.Post_Thumbnail_text)
                                .foregroundStyle(.black000)
                                .lineLimit(2)
                                .padding(.leading,1)
                                .padding(.trailing, 3)
                            
                            Text("\(userID)")
                                .textStyle(.Post_UserID)
                                .foregroundStyle(.gray200)
                        }
                        .frame(width: 120)
                        
                    }
                    .padding(.horizontal, 6.5)
                    .padding(.bottom,9)
                    
                    // Spacer()
                }
                VStack{
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Image(systemName: "globe")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundStyle(.gray800)
                    }
                    .padding(.trailing, 7)
                    .padding(.bottom, 8)
                }
        }
    }
}

// 특정 모서리 둥글게
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

// 카테고리 메뉴바 커스텀
// TODO: 메뉴바 디자인 완료시 수정 예정
struct PostTopTabView: View {
    @Binding var selectedTab: postCategoryTap
    var animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(postCategoryTap.allCases, id: \.self) { item in
                VStack(spacing: 4) {
                    Text(item.rawValue)
                        .font(.system(size: 14, weight: selectedTab == item ? .bold : .regular))
                        .foregroundColor(.black)

                    if selectedTab == item {
                        Capsule()
                            .fill(Color.black)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "tabIndicator", in: animation)
                    } else {
                        Color.clear.frame(height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedTab = item
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 19)
        .padding(.vertical, 10)
        .background(Color.white)
    }
}


#Preview {
    PostDetailMainView()
}
    
