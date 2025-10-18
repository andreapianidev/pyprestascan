//
//  macOSPrestaScanApp.swift
//  macOSPrestaScan
//
//  Created by Andrea Piani on 15/10/25.
//

import SwiftUI

@main
struct macOSPrestaScanApp: App {
    @StateObject private var scanManager = ScanManager()
    // @StateObject private var updaterViewModel = UpdaterViewModel()
    
    init() {
        // Request notification permissions on app launch
        Task {
            await NotificationManager.shared.requestAuthorization()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(scanManager)
                .onAppear {
                    // Check notification status on appear
                    NotificationManager.shared.checkAuthorizationStatus()
                    
                    // App a pagamento: nessuna modalità test
                }
                .frame(minWidth: 1200, minHeight: 800)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1400, height: 900)
        .commands {
            CommandGroup(replacing: .newItem) {}
            
            // Check for Updates menu (disabled temporarily)
            // CommandGroup(after: .appInfo) {
            //     Button("Controlla Aggiornamenti...") {
            //         updaterViewModel.checkForUpdates()
            //     }
            //     .disabled(!updaterViewModel.canCheckForUpdates || updaterViewModel.isCheckingForUpdates)
            //     
            //     Divider()
            // }
        }
    }
}
