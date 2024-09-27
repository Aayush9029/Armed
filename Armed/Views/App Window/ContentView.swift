import AppKit
import CameraClient
import Defaults
import Dependencies
import InformationKit
import MacControlCenterUI
import MenuBarExtraAccess
import SwiftUI
import UI

struct ContentView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var armedVM: ArmedVM
    @Binding var isMenuPresented: Bool
    @Default(.showInDock) var showInDock
    @State private var confirmHide: Bool = false
    @Dependency(\.cameraClient) var cameraClient

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 12) {
                    headerView
                    informationBannerView
                    VStack {
                        menuBarToggleView
                            
                        SingleVideo(.demo)
                    }
                    Divider()
                    hideWindowButton
                    Text("To view this window again, simply close and open Armed app again")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Divider()
                    
                    footerButtons
                }
                .padding(12)
                .overlay(alignment: .top) {
                    if !armedVM.hasCameraAccess { cameraBannerView }
                }
            }
            .background(VisualEffect.popoverWindow().ignoresSafeArea())
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Armed")
                .font(.largeTitle)
                .fontDesign(.serif)
            Spacer()
        }
    }
    
    private var cameraBannerView: some View {
        MessageBanner(.camera) {
            cameraClient.openCameraSettings()
        }
    }
    
    private var informationBannerView: some View {
        InformationBanner(style: .init(showBorder: true))
    }
    
    private var menuBarToggleView: some View {
        HStack {
            VStack {
                menuBarIcon
                menuBarInstructions
                
                menuBarToggle
            }
            .padding()
            .background(isMenuPresented ? Color.blue : Color.gray.opacity(0.125))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.tertiary, lineWidth: 2)
            )
        }
    }
    
    private var menuBarIcon: some View {
        Image(systemName: !armedVM.armed ? "lock.shield" : "lock.shield.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 64)
            .foregroundColor(.secondary)
    }
    
    private var menuBarInstructions: some View {
        Text("You can click on the sheild icon, it should be on your menu bar.")
            .foregroundStyle(.secondary)
            .font(.caption)
            .multilineTextAlignment(.center)
    }
    
    private var menuBarToggle: some View {
        VStack {
            HStack { Spacer() }
            Text("Show menu bar app")
            Toggle("", isOn: $isMenuPresented)
                .toggleStyle(.switch)
                .labelsHidden()
        }
    }
    
    private var hideWindowButton: some View {
        CustomCleanButton(
            "Hide Window\(showInDock ? " + Dock Icon" : "")",
            symbol: "dock.rectangle",
            tint: .blue
        ) {
            if showInDock {
                confirmHide.toggle()
            } else {
                NSApp.keyWindow?.close()
            }
        }
        .alert(isPresented: $confirmHide) {
            Alert(
                title: Text("Hide Armed Dock icon."),
                message: Text("This will hide the Armed app icon from the dock. (recommended)"),
                primaryButton: .default(Text("Hide Dock Icon + Main Window")) {
                    showInDock = false
                    NSApp.setActivationPolicy(.prohibited)
                    NSApp.keyWindow?.close()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var footerButtons: some View {
        HStack {
            CustomCleanButton("Website", symbol: "safari") {
                openURL(URL(string: "https://armed.aayush.art")!)
            }
            CustomCleanButton("Release Notes", symbol: "list.bullet.clipboard") {
                openURL(URL(string: "https://github.com/Aayush9029/Armed/releases")!)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isMenuPresented: .constant(false))
            .environmentObject(ArmedVM())
            .frame(width: 380, height: 640)
    }
}
