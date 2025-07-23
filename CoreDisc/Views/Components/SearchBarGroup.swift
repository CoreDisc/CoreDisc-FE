//
//  SearchBarGroup.swift
//  CoreDisc
//
//  Created by 이채은 on 7/23/25.
//

import SwiftUI

struct SearchBarGroup: View {
    @Binding var query: String
    @Binding var isSearch: Bool
    var onSearch: () -> Void
    
    var body: some View{
        HStack {
            UnevenRoundedRectangle(cornerRadii: .init(
                topLeading: 0,
                bottomLeading: 0,
                bottomTrailing: 12,
                topTrailing: 12)
                                   
            )
            .foregroundStyle(.key)
            .frame(width: 14, height: 114)
            Spacer().frame(width: 11)
            
            VStack(alignment: .leading) {
                Text("Explore")
                    .textStyle(.Title_Text_Eng)
                    .foregroundStyle(.white)
                    .padding(.leading, 8)
                
                Spacer().frame(height: 14)
                
                HStack {
                    ZStack(alignment: .leading) {
                        TextEditor(text: $query)
                            .padding(.leading, 46)
                            .padding(.top, 5)
                            .background(.white)
                            .textStyle(.Pick_Q_Eng)
                            .cornerRadius(32)
                            .shadow(color: .white.opacity(0.5), radius: 4.8, x: 0, y: 0)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .frame(height: 45)
                        
                        HStack(spacing: 11) {
                            Button(action: {
                                if !query.isEmpty {
                                                onSearch() // 🔥 SearchView에서 path.append(UUID())
                                            }
                            }) {
                                Image(.iconSearch)
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .padding(.leading, 17)
                            }
                            
                            if query.isEmpty {
                                Text("Enter a user's name or ID")
                                    .textStyle(.Pick_Q_Eng)
                                    .foregroundStyle(.gray200)
                                    .padding(.vertical, 12.5)
                                    .padding(.leading, 2)
                            }
                        }
                        
                    }
                    .padding(.trailing, 25)
                    .onChange(of: query) { oldValue, newValue in
                        isSearch = !newValue.isEmpty
                    }
                }
                
            }
        }
        
    }
}
