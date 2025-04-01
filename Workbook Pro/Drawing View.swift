import SwiftUI

struct DrawingView: View {
    @Bindable private var vm = DrawingVM()
    @EnvironmentObject private var store: ValueStore
    @Environment(\.dismiss) private var dismiss
    
    private var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    @State private var dialogErase = false
    
    var body: some View {
        DrawingRepresentable(note)
            .ignoresSafeArea()
            .toolbar(store.showNavBar ? .visible : .hidden, for: .navigationBar)
            .statusBarHidden(!store.showStatusBar)
            .overlay(alignment: .topLeading) {
                DrawingViewOverlay(note)
            }
            .environment(vm)
            .task {
                for await session in WorkbookProGroupSession.sessions() {
                    vm.vc?.configureGroupSession(session)
                }
            }
            .gesture(
                store.showNavBar ? nil : DragGesture()
                    .onChanged { value in
                        let edgeWidth = 20.0
                        let minimumDragTranslation = 50.0
                        
                        if value.startLocation.x < edgeWidth && value.translation.width > minimumDragTranslation {
                            print("Dismissed with a gesture")
                            dismiss()
                        }
                    }
            )
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        vm.deletePage()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                    .disabled(note.pages.count == 1)
                    
                    Button(role: .destructive) {
                        dialogErase = true
                    } label: {
                        Label("Clear", systemImage: "eraser")
                            .foregroundStyle(.red)
                    }
                    .disabled(vm.strokes == 0)
                    .confirmationDialog("Erase this page?", isPresented: $dialogErase) {
                        Button("Erase", role: .destructive) {
                            vm.clear()
                        }
                    }
                    
                    Text("\(vm.strokes ?? 0) strokes")
                        .numericTransition()
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if vm.vc?.groupSession?.state != .joined, store.enableGroupActivities {
                        Menu {
                            Button {
                                vm.vc?.startSharing()
                            } label: {
                                Label("SharePlay", systemImage: "shareplay")
                            }
                        } label: {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .symbolRenderingMode(.multicolor)
                                .tint(.secondary)
                        }
                    }
                    
                    Menu {
                        Button("Clear") {
                            vm.clear()
                        }
                        
                        Button("Undo") {
                            vm.undo()
                        }
                        
                        Button("Redo") {
                            vm.redo()
                        }
                        
                        Divider()
                        
                        Text(vm.toolWidth)
                        
                        Slider(value: $vm.toolWidth, in: 1...100, step: 0.1)
                            .padding()
                        
                        Button("Set Tool Width") {
                            vm.changeToolWidth(to: vm.toolWidth)
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
    }
}

#Preview {
    DrawingView(.init("Preview"))
        .environmentObject(ValueStore())
}
