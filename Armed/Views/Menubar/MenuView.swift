import AppKit
import Defaults
import Dependencies
import MacControlCenterUI
import SwiftUI
import UI

struct MenuView: View {
    @EnvironmentObject var armedVM: ArmedVM
    @Binding var isMenuPresented: Bool
    
    let persistenceController = PersistenceController.shared
    
    @Default(.siren) var siren
    @Default(.showInDock) var showInDock
    @Default(.maxVolume) var maxVolume
    @Default(.message) var message
    @Default(.sirenTimer) var sirenTimer
    
    var body: some View {
        NavigationStack {
            MacControlCenterMenu(isPresented: $isMenuPresented) {
                VStack(spacing: 8) {
                    menuHeader
                    statusSection
                    actionButtons
                    if !armedVM.armed {
                        additionalOptions
                    }
                }
                .floatingPanel(isPresented: $armedVM.armed) {
                    WarnTimerView().environmentObject(armedVM)
                }
                .onChange(of: armedVM.armed, perform: handleArmedStateChange)
            }
        }
    }
    
    private var menuHeader: some View {
        MenuHeader("Armed") {
            Text("1.0.0").foregroundColor(.secondary)
        }
    }
    
    private var statusSection: some View {
        Group {
            connectionStatus
            if armedVM.isConnected && siren && NSSound.systemVolume < 0.5 && !maxVolume {
                volumeWarning
            }
            if !armedVM.hasCameraAccess {
                EnableCameraLabel()
            }
        }
    }
    
    private var connectionStatus: some View {
        HStack {
            BlinkingSymbol(
                onSymbol: "bolt",
                offSymbol: "bolt.slash",
                state: armedVM.isConnected
            )
            Text("\(!armedVM.isConnected ? "Not" : "") Ready").bold()
            Spacer()
            Text("\(!armedVM.isConnected ? "connect" : "connected") to power source")
                .foregroundStyle(.secondary)
        }
    }
    
    private var volumeWarning: some View {
        HStack {
            BlinkingSymbol(onSymbol: "speaker.wave.2.fill", offSymbol: "speaker.fill", state: false)
            Spacer()
            Text("Sound Volume is only \(Int(NSSound.systemVolume * 100))%")
                .foregroundStyle(.secondary)
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 8) {
            if !armedVM.isConnected && !armedVM.armed {
                connectToChargerButton
            } else {
                armButton
            }
            
            if !armedVM.armed && armedVM.isConnected {
                ArmedOptions().environmentObject(armedVM)
            }
        }
    }
    
    private var connectToChargerButton: some View {
        ControlCenterButton(
            false,
            title: "Connect to charger",
            icon: "powerplug.fill",
            tint: .red,
            size: .title2
        ) {}
    }
    
    private var armButton: some View {
        ControlCenterButton(
            armedVM.armed,
            title: armedVM.armed ? "Unarm\nMacbook" : "Arm\nMacbook",
            icon: armedVM.armed ? "touchid" : "shield.lefthalf.filled",
            tint: .red
        ) {
            Task {
                await handleArmButtonTap()
            }
        }
    }
    
    private var additionalOptions: some View {
        VStack {
            SirenSlider(sirenTimer: $sirenTimer) {}
            cloudImagesLink
            infoAndQuitButtons
        }
    }
    
    private var cloudImagesLink: some View {
        NavigationLink(destination: CloudPhotosView()
            .padding(.top, -24)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        ) {
            HStack {
                Label("Cloud Images", systemImage: "icloud")
                Spacer()
                Image(systemName: "chevron.forward").foregroundStyle(.tertiary)
            }.ccGlassButton()
        }
        .buttonStyle(.plain)
    }
    
    private var infoAndQuitButtons: some View {
        HStack {
            Label("Info", systemImage: "info.circle")
                .frame(width: 124)
                .ccGlassButton()
                .onTapGesture(perform: showStandardAboutWindow)
            
            Label("Quit", systemImage: "power")
                .frame(width: 124)
                .ccGlassButton()
                .onTapGesture(perform: quit)
        }
        .labelStyle(.titleAndIcon)
    }
    
    // MARK: - Actions
    
    private func quit() {
        NSApp.terminate(nil)
    }
    
    private func showStandardAboutWindow() {
        NSApp.sendAction(#selector(NSApplication.orderFrontStandardAboutPanel(_:)), to: nil, from: nil)
    }
    
    private func handleArmButtonTap() async {
        if armedVM.armed {
            let success = await armedVM.authenticate()
            if success && !showInDock {
                NSApp.setActivationPolicy(.regular)
            }
        } else {
            if showInDock {
                NSApp.setActivationPolicy(.prohibited)
            }
            armedVM.armed.toggle()
        }
    }
    
    private func handleArmedStateChange(_ newValue: Bool) {
        Task {
            guard armedVM.hasCameraAccess else {
                print("Need access to camera")
                return
            }
            
            if newValue {
                armedVM.startCamera()
            } else {
                armedVM.stopCamera()
            }
        }
    }
}

// MARK: - Subviews

struct ArmedOptions: View {
    @Default(.showInDock) var showInDock
    @Default(.maxVolume) var maxVolume
    @Default(.captureImage) var captureImage
    @Default(.siren) var siren
    
    var body: some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 8) {
            GridRow {
                captureButton
                hideDockButton
            }
            GridRow {
                sirenButton
                maxVolumeButton
            }
        }
    }
    
    private var captureButton: some View {
        ControlCenterButton(captureImage, title: "Capture\nPlugged", icon: "camera") {
            captureImage.toggle()
        }
    }
    
    private var hideDockButton: some View {
        ControlCenterButton(!showInDock, title: "Hide\n Dock", icon: "dock.arrow.down.rectangle") {
            showInDock.toggle()
            NSApp.setActivationPolicy(showInDock ? .regular : .prohibited)
        }
    }
    
    private var sirenButton: some View {
        ControlCenterButton(siren, title: "Play\nSiren", icon: "light.beacon.max") {
            siren.toggle()
        }
    }
    
    private var maxVolumeButton: some View {
        ControlCenterButton(maxVolume, title: "Max\nVolume", icon: "speaker.wave.3.fill", tint: .red) {
            maxVolume.toggle()
        }
        .disabled(!siren)
        .opacity(siren ? 1 : 0.15)
    }
}

struct EnableCameraLabel: View {
    var body: some View {
        HStack {
            Image(systemName: "hand.raised.fill").foregroundColor(.red)
            Text("Not Ready").bold()
            Spacer()
            Text("Grant Access to Camera")
                .foregroundStyle(.secondary)
                .onTapGesture {}
        }
    }
}

// MARK: - Preview

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(isMenuPresented: .constant(true))
            .environmentObject(ArmedVM())
            .frame(width: 320, height: 420)
    }
}
