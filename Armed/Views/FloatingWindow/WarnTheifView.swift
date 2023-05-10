//
//  ArmedFloatingWindow.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import SwiftUI

import Defaults
struct WarnTheifView: View {
    @EnvironmentObject var armedVM: ArmedVM
    @EnvironmentObject var cameraVM: CameraVM

    @Default(.message) var message
    @Default(.flashes) var flashes

    var body: some View {
        ZStack {
            if self.armedVM.armed {
                if !self.armedVM.isConnected {
                    ZStack {
                        if self.flashes {
                            FlashLights()
                        }
                        TimerView(inputTime: self.armedVM.soundTimer)
                    }.ignoresSafeArea()

                } else {
                    Group {
                        CameraView(cameraVM: self.cameraVM)
                            .blur(radius: 16)
                            .ignoresSafeArea()
                    }
                    VStack {
                        DangerOverlay(self.message)
                        if !self.cameraVM.imageBuffer.isEmpty {
                            ImageBufferRow(self.cameraVM.imageBuffer)
                        }
                        TouchIDButton()
                            .environmentObject(self.armedVM)
                    }
                    .padding()
                }
            } else { NotMonitoringView() }
        }

        .frame(
            minWidth: NSScreen.main?.frame.width ?? 720,
            minHeight: NSScreen.main?.frame.height ?? 640
        )
    }
}

struct FlashLights: View {
    let colors: [Color] = [.red, .green]
    @State private var currentColorIndex = 0
    @State private var timer: Timer?

    var body: some View {
        Rectangle()
            .fill(self.colors[self.currentColorIndex])
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                self.startTimer()
            }
            .onDisappear {
                self.timer?.invalidate()
            }
    }

    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.01)) {
                self.currentColorIndex = (self.currentColorIndex + 1) % self.colors.count
            }
        }
    }
}

struct TimerView: View {
    @EnvironmentObject var armedVM: ArmedVM

    @State private var timeRemaining: TimeInterval
    @State private var timer: Timer?
    @State private var hovering: Bool = false

    init(inputTime: TimeInterval) {
        _timeRemaining = State(initialValue: inputTime * 30)
    }

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text(self.timeString(self.timeRemaining))
                        .font(.system(size: 128))
                        .bold()
                    Text("Seconds Remaning")
                        .font(.title3)
                        .foregroundStyle(.tertiary)
                }
                HStack {
                    Text("Please **plug charger** back in **immedietaly**")
                    Image(systemName: "powerplug.fill")
                }
                .padding(8)
                .background(.red.opacity(0.5))
                .cornerRadius(12)
            }
            if self.hovering {
                VStack {
                    Spacer()
                    Image(systemName: "touchid")
                        .imageScale(.large)
                        .foregroundStyle(.red)
                    HStack { Spacer() }
                    Text("Un-arm macbook")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .font(.largeTitle)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)

                .onTapGesture(perform: {
                    _ = self.armedVM.authenticate()
                })
            }
        }
        .onAppear {
            self.startTimer()
        }
        .onHover { state in
            withAnimation {
                self.hovering = state
            }
        }
    }

    func startTimer() {
        self.stopTimer()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
            }
        }
    }

    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }

    func timeString(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        return String(format: "%02i", seconds)
    }
}

struct DangerOverlay: View {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var body: some View {
        Group {
            if !self.message.isEmpty {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "exclamationmark.octagon.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 320)
                            .foregroundStyle(.red.opacity(0.5))
                        Spacer()
                    }
                    Text("Armed")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.secondary)
                    Text(self.message)
                        .font(.title.bold())
                }
            }
        }.padding()
    }
}

struct ArmedFloatingWindow_Previews: PreviewProvider {
    static var previews: some View {
        WarnTheifView()
            .environmentObject(ArmedVM())
            .environmentObject(CameraVM())
    }
}

struct ImageBufferRow: View {
    let imageBuffer: [BufferImageModel]

    init(_ imageBuffer: [BufferImageModel]) {
        self.imageBuffer = imageBuffer
    }

    var body: some View {
        HStack {
            ForEach(self.imageBuffer) { buffer in
                Group {
                    if let image = ciImageToImage(buffer.image) {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .cornerRadius(12)
                    }
                }
                .foregroundStyle(.tertiary)
                .padding(2)
            }
        }
        .padding(.horizontal, 2)
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
    }
}

struct TouchIDButton: View {
    @EnvironmentObject var armedVM: ArmedVM
    var body: some View {
        Button {
            withAnimation {
                _ = self.armedVM.authenticate()
            }
        } label: {
            GroupBox {
                VStack {
                    Label("Un-Arm with biometrics", systemImage: "touchid")
                        .labelStyle(.iconOnly)
                        .font(.largeTitle)
                        .foregroundStyle(.tertiary)
                        .padding(6)
                    Text("Un-arm macbook")
                }
                .padding(8)
            }
            .padding()
        }
        .buttonStyle(.plain)
    }
}

struct NotMonitoringView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "lock.open.laptopcomputer")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .foregroundColor(.secondary)

            Text("Unarmed")
                .font(.largeTitle)
            Spacer()
            Button {
                print("hid")
            } label: {
                HStack {
                    Spacer()
                    Text("Hide Window")
                    Spacer()
                }
                .padding()
                .background(.thickMaterial)
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .padding()

        .background(FluidView().ignoresSafeArea())
    }
}
