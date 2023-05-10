//
//  CloudPhotosView.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-17.
//

import CloudKit
import CoreData
import SwiftUI

struct CloudPhotosView: View {
    @FetchRequest(
        entity: StoredImage.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \StoredImage.timestamp, ascending: false)],
        animation: .easeInOut
    )
    private var images: FetchedResults<StoredImage>

    @State private var confrimDelete: Bool = false
    var body: some View {
        NavigationStack {
            Group {
                if images.isEmpty {
                    EmptyCloudView()
                } else {
                    StoredImagesGrid(images)
                }
            }
            .toolbar {
                if !images.isEmpty {
                    Button(role: .destructive) {
                        confrimDelete.toggle()
                    } label: {
                        Label("Delete all", systemImage: "trash")
                            .tint(.red)
                    }
                }
            }
            .navigationTitle(Text("Cloud Photos"))
        }
        .alert(isPresented: $confrimDelete) {
            Alert(title: Text("Delete All"),
                  message: Text("Are you sure you want to delete all iCloud captures?"),
                  primaryButton: .destructive(Text("Delete")) {
                      deleteAllCloudPhotos()
                  },
                  secondaryButton: .cancel())
        }
    }

    struct StoredImagesGrid: View {
        @Environment(\.managedObjectContext) private var viewContext
        let images: FetchedResults<StoredImage>

        @State var columns = [
            GridItem(.adaptive(minimum: 128))
        ]

        init(_ images: FetchedResults<StoredImage>) {
            self.images = images
        }

        var body: some View {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(images) { image in
                            SingleStoredImage(image)
                            #if !os(watchOS)
                                .contextMenu {
                                    Button(action: {
                                        viewContext.delete(image)
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                            Text("Delete")
                                        }
                                    }
                                }
                            #endif
                        }
                    }.padding()
                }
            }
        }
    }
}

struct CloudPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CloudPhotosView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
        .frame(width: 360, height: 540)
    }
}

struct SingleStoredImage: View {
    let photo: StoredImage

    init(_ photo: StoredImage) {
        self.photo = photo
    }

    var body: some View {
        VStack {
            if let image = photo.image {
                VStack {
                    Group {
                        #if os(macOS)
                            Image(nsImage: NSImage(data: image)!)
                                .resizable()
                        #else
                            Image(uiImage: UIImage(data: image)!)
                                .resizable()
                        #endif
                    }
                    .scaledToFill()
                    .cornerRadius(16)
                    .shadow(radius: 10, y: 6)

                    Text(Date(timeIntervalSince1970: photo.timestamp), style: .relative)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .scaledToFit()
                .frame(minWidth: 128)
                .padding(4)
                .background(.gray.opacity(0.25))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(photo.connected ? .gray : .red, lineWidth: 2)
                )
            }
        }
        .padding(2)
    }
}

struct EmptyCloudView: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack { Spacer() }
            Spacer()
            Image(systemName: "icloud.fill")
                .symbolRenderingMode(.multicolor)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 128)
            Text("No Images found in iCloud yet.")
                .bold()
            Text("*Syncing might take a min or two.*")
                .font(.callout)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}
