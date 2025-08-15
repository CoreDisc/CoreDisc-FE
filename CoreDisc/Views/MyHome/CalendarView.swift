//
//  CalendarView.swift
//  CoreDisc
//
//  Created by 이채은 on 8/9/25.
//

import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel: CalendarContentsViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var dragOffset: CGFloat = 0
    private let swipeThreshold: CGFloat = 50
    
    init(viewModel: CalendarContentsViewModel = CalendarContentsViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Image(.imgShortBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                TopGroup
                
                Spacer().frame(height: 19)
                ScrollView{
                    TodayGroup
                    
                    
                    Spacer().frame(height: 39)
                    
                    mainCalendarView
                        .padding(.horizontal, 23)
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var monthSwipeGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onChanged { value in
                dragOffset = value.translation.width
            }
            .onEnded { value in
                let translation = value.translation.width
                let predicted = value.predictedEndTranslation.width
                let final = abs(predicted) > abs(translation) ? predicted : translation
                
                if final <= -swipeThreshold {
                    withAnimation { dragOffset = -200 }
                    viewModel.changeMonth(by: +1)
                    dragOffset = 200
                    withAnimation { dragOffset = 0 }
                } else if final >= swipeThreshold {
                    withAnimation { dragOffset = 200 }
                    viewModel.changeMonth(by: -1)
                    dragOffset = -200
                    withAnimation { dragOffset = 0 }
                } else {
                    withAnimation { dragOffset = 0 }
                }
            }
    }
    
    var TopGroup: some View {
        VStack {
            HStack {
                UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: 0,
                    bottomLeading: 0,
                    bottomTrailing: 12,
                    topTrailing: 12)
                )
                .foregroundStyle(.key)
                .frame(width: 14, height: 55)
                
                Spacer().frame(width: 3)
                
                Button(action: {
                    dismiss()
                }) {
                    Image(.iconBack)
                        .resizable()
                        .frame(width: 42, height: 42)
                }
                .padding(.bottom, 2)
                
                Spacer().frame(width: 87)
                
                Text("Disc Calendar")
                    .textStyle(.Pick_Q_Eng)
                    .foregroundStyle(.gray200)
                    .padding(.top, 11)
                Spacer()
            }
            
            
            Spacer().frame(height: 11)
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 1)
                        .foregroundStyle(.clear)
                    
                    HStack {
                        Text(monthTitle(viewModel.currentMonth))
                            .textStyle(.Pick_Q_Eng)
                            .foregroundStyle(.white)
                            .padding(.leading, 8)
                            .padding(.trailing, 4)
                        Text(yearOnly(viewModel.currentMonth))
                            .textStyle(.Button)
                            .foregroundStyle(.white)
                            .padding(.trailing, 8)
                    }
                }
                .padding(.leading, 28)
                .frame(height: 28)
                
                
                Spacer().frame(width: 120)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 1)
                        .foregroundStyle(.clear)
                    
                    HStack {
                        Text("\(viewModel.totalDays)")
                            .textStyle(.Button)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                        Text("posts")
                            .textStyle(.Pick_Q_Eng)
                            .foregroundStyle(.white)
                            .padding(.trailing, 4)
                    }
                }
                .padding(.trailing, 28)
                .frame(height: 28)
                
            }
        }
    }
    
    var TodayGroup: some View {
        ZStack(alignment: .top) {
            EllipticalGradient(
                stops: [
                    .init(color: .gray400.opacity(0.0), location: 0.2692),
                    .init(color: .white, location: 0.8125)
                ],
                center: .center,
                startRadiusFraction: 0,
                endRadiusFraction: 0.7431
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 28)
            .frame(height: 194)
            
            VStack {
                Text("Today")
                    .textStyle(.Button)
                    .foregroundStyle(.gray100)
                    .padding(.top, 17)
                
                Spacer().frame(height: 24)
                
                Text(todayString())
                    .textStyle(.Title_Text_Eng)
                    .foregroundStyle(.white)
                
                Spacer().frame(height: 18)
                
                HStack(spacing: 11) {
                    Text("\(viewModel.continuesDays)일")
                        .textStyle(.Title2_Text_Ko)
                        .foregroundStyle(.key)
                    Text("연속으로 기록 중이예요!")
                        .textStyle(.Button)
                        .foregroundStyle(.key)
                }
            }
        }
        
    }
    
    let weekDay: [String] = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.shortWeekdaySymbols ?? []
    }()
    
    var mainCalendarView: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(weekDay, id: \.self) {text in
                    Text(text)
                        .foregroundStyle(.white)
                        .textStyle(.Button_s)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
            
            Rectangle()
                .fill(Color.white)
                .frame(height: 0.5)
                .padding(.horizontal, 8)
                .padding(.top, 7)
            
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                ForEach(viewModel.daysForCurrentGrid(), id: \.id) { calendarDay in
                    let isSelectedDate = viewModel.calendar.isDate(calendarDay.date, inSameDayAs: viewModel.selectedDate)
                    Cell(calendarDay: calendarDay, isSelected: isSelectedDate, viewModel: viewModel)
                }
            }
            .padding(.top, 11)
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
            .offset(x: dragOffset)
            .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.85), value: dragOffset)
            .highPriorityGesture(monthSwipeGesture)
        }
    }
    
    
    private func todayString() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "M월 d일 EEEE"
        return f.string(from: Date())
    }
    
    private func monthTitle(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "MMM"
        return f.string(from: date)
    }
    
    private func yearOnly(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy"
        return f.string(from: date)
    }
}

#Preview {
    CalendarView(viewModel: CalendarContentsViewModel())
}
