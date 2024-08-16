//
//  HomeView.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/5/24.
//

import SwiftUI

import Core

import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<HomeFeature>
    @State private var currentMonth: Date = Date()
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    navigationView
                    if viewStore.isLoading {
                        loadingView
                    } else {
                        calendarView(viewStore: viewStore)
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
    
    var navigationView: some View {
        HStack {
            Text(currentMonth.toYearString())
                .font(.pretendardSB(40))
            Spacer()
            HStack {
                NavigationLink(destination: ShopView(store: Store(initialState: ShopFeature.State(), reducer: { ShopFeature() }))) {
                    Image(systemName: "cart.fill")
                        .foregroundColor(.black)
                }
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    var loadingView: some View {
        VStack {
            Spacer()
                .frame(width: 300, height: 300)
            LoadingView()
                .frame(width: 50, height: 50)
            Spacer()
                .frame(width: 300, height: 300)
        }
    }
    
    func calendarView(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
            VStack {
                TabView(selection: $currentMonth) {
                    ForEach(generateMonths(startYear: 2021, endYear: 2024), id: \.self) { month in
                        CalendarView(commits: viewStore.commits, currentMonth: month)
                            .tag(month)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 500)
                .padding(.top, 5)
                .animation(.easeInOut, value: currentMonth)
                .onAppear {
                    currentMonth = Date().startOfMonth()
                }
                Spacer()
                    .frame(width: 300, height: 150)
            }
        }
    
    private func generateMonths(startYear: Int, endYear: Int) -> [Date] {
        var months: [Date] = []
        
        for year in startYear...endYear {
            for month in 1...12 {
                if let date = Calendar.current.date(from: DateComponents(year: year, month: month)) {
                    months.append(date)
                }
            }
        }
        return months
    }
}
