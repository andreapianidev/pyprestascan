//
//  ContentView.swift
//  macOSPrestaScan
//
//  Created by Andrea Piani on 15/10/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var scanManager: ScanManager
    @State private var selectedTab = 0
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Main Tab view (only visible tabs)
                TabView(selection: $selectedTab) {
                    ConfigurationView(selectedTab: $selectedTab)
                        .tabItem {
                            Label(LocalizedStringKey("tab.configuration"), systemImage: "gear")
                        }
                        .tag(0)
                    
                    ScanProgressView(selectedTab: $selectedTab)
                        .tabItem {
                            Label(LocalizedStringKey("tab.progress"), systemImage: "chart.bar.fill")
                        }
                        .tag(1)
                    
                    ResultsView()
                        .tabItem {
                            Label(LocalizedStringKey("tab.results"), systemImage: "list.bullet.clipboard")
                        }
                        .tag(2)
                }
                .opacity(selectedTab <= 2 ? 1 : 0)
            }
            
            // Advanced Features Overlay
            if selectedTab > 2 {
                VStack(spacing: 0) {
                    switch selectedTab {
                    case 3:
                        FixesView()
                    case 4:
                        AIDebugBotView()
                    case 5:
                        ApplyFixesView()
                    case 6:
                        MonitoringView()
                    case 7:
                        SearchConsoleView()
                    case 8:
                        CompetitiveAnalysisView()
                    case 9:
                        AIAnalysisView()
                    case 10:
                        NotificationSettingsView()
                    case 11:
                        HelpView()
                    case 12:
                        PrestaShopSettingsView()
                    default:
                        EmptyView()
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
        }
        .frame(minWidth: 1000, minHeight: 700)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToFixSuggeriti"))) { _ in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = 3
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToConfiguration"))) { _ in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = 0
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToResults"))) { _ in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = 2
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToApplyFixes"))) { _ in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = 5
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ExportReport"))) { _ in
            // Switch to results and trigger export
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = 2
            }
            // Trigger export after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: NSNotification.Name("TriggerExport"), object: nil)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RetryScan"))) { _ in
            // Switch to configuration and trigger last scan
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = 0
            }
            // Trigger retry after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: NSNotification.Name("RetryLastScan"), object: nil)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("StartScheduledScan"))) { notification in
            if let projectName = notification.userInfo?["projectName"] as? String {
                // Load project and start scan
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    selectedTab = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(
                        name: NSNotification.Name("LoadAndStartProject"),
                        object: nil,
                        userInfo: ["projectName": projectName]
                    )
                }
            }
        }
        .toolbarBackground(.hidden, for: .windowToolbar)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                HStack(spacing: 12) {
                    // Back button for advanced features - sempre presente ma invisibile
                    Button(action: {
                        if selectedTab > 2 {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                selectedTab = 0
                            }
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.brandAccent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.brandAccent.opacity(0.1))
                        )
                    }
                    .buttonStyle(.plain)
                    .opacity(selectedTab > 2 ? 1 : 0)
                    .disabled(selectedTab <= 2)
                    
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.brandPrimary, Color.brandSecondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("PrestaScan AI")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(LocalizedStringKey("app.subtitle"))
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                .padding(.trailing, 12)
            }
            
            ToolbarItem(placement: .automatic) {
                if scanManager.isScanning {
                    HStack(spacing: 8) {
                        ProgressView()
                            .scaleEffect(0.7)
                            .controlSize(.small)
                        Text(LocalizedStringKey("progress.scanning"))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.brandAccent)
                    }
                }
            }
            
            
            // Fix Suggeriti Button - Sempre visibile
            ToolbarItem(placement: .automatic) {
                Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedTab = 3
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.orange, .red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Text("Fix Suggeriti")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(NSColor.controlBackgroundColor))
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.orange.opacity(0.08),
                                                Color.red.opacity(0.08)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [
                                                Color.orange.opacity(0.25),
                                                Color.red.opacity(0.25)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            }
                        )
                        .shadow(color: Color.orange.opacity(0.15), radius: 4, x: 0, y: 2)
                        .scaleEffect(selectedTab == 3 ? 1.05 : 1.0)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 4)
            }
            
            // AI Debug Bot Button - Sempre visibile
            ToolbarItem(placement: .automatic) {
                Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedTab = 4
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple, .pink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Text("AI Debug Bot")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(NSColor.controlBackgroundColor))
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.purple.opacity(0.08),
                                                Color.pink.opacity(0.08)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [
                                                Color.purple.opacity(0.25),
                                                Color.pink.opacity(0.25)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            }
                        )
                        .shadow(color: Color.purple.opacity(0.15), radius: 4, x: 0, y: 2)
                        .scaleEffect(selectedTab == 4 ? 1.05 : 1.0)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 4)
            }
            
            // Advanced Menu - Sempre visibile
            ToolbarItem(placement: .automatic) {
                AdvancedFeaturesMenu(selectedTab: $selectedTab)
                    .padding(.horizontal, 4)
            }
            
            // Divider
            ToolbarItem(placement: .automatic) {
                Divider()
                    .frame(height: 20)
                    .padding(.horizontal, 4)
            }
            
            // Dark mode toggle - Sempre visibile
            ToolbarItem(placement: .automatic) {
                // Dark mode toggle - Modern design (separato)
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            isDarkMode.toggle()
                        }
                    }) {
                        ZStack {
                            // Background capsule
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: isDarkMode ? 
                                            [Color.purple.opacity(0.3), Color.blue.opacity(0.3)] :
                                            [Color.orange.opacity(0.3), Color.yellow.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 70, height: 36)
                            
                            // Icon container
                            HStack(spacing: 0) {
                                // Sun icon
                                ZStack {
                                    Circle()
                                        .fill(isDarkMode ? Color.clear : Color.orange)
                                        .frame(width: 28, height: 28)
                                    Image(systemName: "sun.max.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(isDarkMode ? .secondary : .white)
                                }
                                .opacity(isDarkMode ? 0.5 : 1.0)
                                .scaleEffect(isDarkMode ? 0.8 : 1.0)
                                
                                Spacer()
                                
                                // Moon icon
                                ZStack {
                                    Circle()
                                        .fill(isDarkMode ? Color.indigo : Color.clear)
                                        .frame(width: 28, height: 28)
                                    Image(systemName: "moon.stars.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(isDarkMode ? .yellow : .secondary)
                                }
                                .opacity(isDarkMode ? 1.0 : 0.5)
                                .scaleEffect(isDarkMode ? 1.0 : 0.8)
                            }
                            .padding(.horizontal, 4)
                            .frame(width: 70)
                        }
                        .overlay(
                            Capsule()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: isDarkMode ?
                                            [Color.purple.opacity(0.5), Color.blue.opacity(0.5)] :
                                            [Color.orange.opacity(0.5), Color.yellow.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(
                            color: isDarkMode ? Color.blue.opacity(0.3) : Color.orange.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 2
                        )
                    }
                    .buttonStyle(.plain)
                    .help(isDarkMode ? "Passa a Light Mode" : "Passa a Dark Mode")
                    .padding(.horizontal, 4)
            }
            
            // Version - Sempre visibile
            ToolbarItem(placement: .automatic) {
                Text("v2.8.0")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.textTertiary)
                    .padding(.leading, 8)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    private var headerView: some View {
        HStack(spacing: 16) {
            // Icon and title
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.brandPrimary, Color.brandSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: DesignTokens.shadowMedium, radius: 8, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedStringKey("app.name"))
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Text(LocalizedStringKey("app.subtitle"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Status indicator
            if scanManager.isScanning {
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.8)
                        .controlSize(.small)
                    Text(LocalizedStringKey("progress.scanning"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.brandAccent)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.brandAccent.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.brandAccent.opacity(0.3), lineWidth: 1)
                )
                .transition(.scale.combined(with: .opacity))
            }
            
            // Version badge
            Text("v1.0.0")
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(12)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            ZStack {
                Color(NSColor.controlBackgroundColor)
                
                LinearGradient(
                    colors: [
                        Color.brandPrimary.opacity(0.05),
                        Color.brandSecondary.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.2)),
            alignment: .bottom
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(ScanManager())
}
