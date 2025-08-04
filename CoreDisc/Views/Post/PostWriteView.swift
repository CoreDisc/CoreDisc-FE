//
//  PostWriteView.swift
//  CoreDisc
//
//  Created by 신연주 on 7/3/25.
//

import SwiftUI

struct PostWriteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isCorelist: Bool = false
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                BackButtonGroup
                
                Spacer().frame(height: 4)
                
                PostGroup
                
                Spacer().frame(height: 42)
                
                BottomGroup
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // 뒤로가기 버튼 섹션
    private var BackButtonGroup: some View {
        HStack{
            Button(action: {
                dismiss()
            }){
                Image(.iconBack)
                    .resizable()
                    .frame(width: 42, height: 42)
            }
            
            Spacer()
        }
        .padding(.leading, 17)
    }
    
    // 게시물 작성 섹션
    private var PostGroup: some View {
        VStack (alignment: .center){
            // 개인정보, 저장버튼
            HStack {
                Circle() // TODO: 추후 프로필 사진으로 변경
                    .frame(width: 32, height: 32)
                
                Spacer().frame(width: 11)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("@music_sama")
                        .textStyle(.Pick_Q_Eng)
                        .foregroundStyle(.gray100)
                    
                    Text("2025-07-07")
                        .textStyle(.Button_s)
                        .foregroundStyle(.gray100)
                }
                
                Spacer()
                
                // 저장버튼
                Button(action: {
                    // TODO: 추가 예정
                }){
                    Text("저장")
                        .textStyle(.Q_Main)
                        .foregroundStyle(.highlight)
                        .underline()
                }
                
                Spacer().frame(width: 8)
                
                // 임시저장버튼
                Button(action: {
                    // TODO: 추가 예정
                }){
                    Image(.iconSave)
                        .frame(width:42, height: 42)
                    
                }
            }
            .padding(.horizontal,16)
            
            Spacer().frame(height: 33)
            
            // 게시물 작성란
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray400)
                            .frame(width: 308, height: 409)
                            .cornerRadius(20.83)
                        
                        VStack (alignment: .leading, spacing: 20) {
                            Button(action: {
                                // TODO:
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 60, height: 60)
                                    
                                    Image(.iconPhoto)
                                        .renderingMode(.original)
                                }
                            }
                            
                            
                            Button(action: {
                                // TODO:
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 60, height: 60)
                                    
                                    Image(.iconWriting)
                                        .renderingMode(.original)
                                }
                            }
                        }
                        .padding(.top, 240)
                        .padding(.leading, 225)
                        
                    }
                    
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.gray400)
                            .frame(width: 308, height: 409)
                            .cornerRadius(20.83)
                    }
                }
                .padding(.horizontal, 47)
            }
        }
    }
    
    // 하단섹션
    private var BottomGroup: some View {
        VStack (alignment: .center, spacing: 26){
            // 질문
            Text("계절마다 떠오르는 음식이 있나요? 요즘 생각나는 건 뭐예요?")
                .textStyle(.Q_Main)
                .foregroundStyle(.highlight)
                .multilineTextAlignment(.center)
                .frame(width: 348, height: 68)
                .background(.black000)
                .cornerRadius(12)
            
            // 공개범위 버튼
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCorelist.toggle()
                }
            }) {
                ZStack(alignment: isCorelist ? .trailing : .leading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.gray800)
                        .frame(width: 42, height: 42)
                    
                    RoundedRectangle(cornerRadius: 30)
                        .fill(isCorelist ? .gray600 : .black000)
                        .frame(width: 123, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.gray400, lineWidth: 2)
                        )
                        .padding(.horizontal, 2)
                    
                    HStack(spacing: 17) {
                                if isCorelist {
                                    // Circle 상태 (오른쪽)
                                    Text("Circle")
                                        .textStyle(.login_info)
                                        .foregroundColor(.white)

                                    ZStack {
                                        Circle()
                                            .fill(.key)
                                            .frame(width: 42, height: 42)

                                        Image(.iconCore)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 23, height: 16)
                                            .foregroundStyle(.gray600)
                                    }
                                    .padding(.vertical, 6)
                                    .padding(.trailing, 8)
                                    
                                } else {
                                    // Public 상태 (왼쪽)
                                    ZStack {
                                        Circle()
                                            .fill(.gray100)
                                            .frame(width: 42, height: 42)

                                        Image(systemName: "globe")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height:20)
                                            .foregroundStyle(.black000)
                                    }
                                    .padding(.vertical, 6)
                                    .padding(.leading, 8)

                                    Text("Public")
                                        .textStyle(.login_info)
                                        .foregroundColor(.white)
                                }
                            }
                }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    PostWriteView()
}
