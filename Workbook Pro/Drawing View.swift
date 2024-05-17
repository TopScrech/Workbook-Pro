import SwiftUI

struct DrawingView: View {
    @StateObject private var vm = DrawingVM()
    @EnvironmentObject private var storage: Storage
    @Environment(\.dismiss) private var dismiss
    
    private var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    @State private var toolWidth = 5.0
    
    private var isFirstPage: Bool {
        vm.vc?.selectedPage == 0
    }
    
    private var strokes: Int? {
        vm.vc?.canvasView.drawing.strokes.count
    }
    
    var body: some View {
        DrawingRepresentable(note)
            .environmentObject(vm)
            .ignoresSafeArea()
            .toolbar(storage.showNavBar ? .visible : .hidden, for: .navigationBar)
            .statusBarHidden(!storage.showStatusBar)
            .task {
                for await session in WorkbookProGroupSession.sessions() {
                    vm.vc?.configureGroupSession(session)
                }
            }
            .overlay(alignment: .topLeading) {
                HStack(spacing: 4) {
                    Button {
                        vm.previous()
                    } label: {
                        Image(systemName: "arrow.backward")
                    }
                    .disabled(isFirstPage)
                    
                    Divider()
                        .frame(height: 20)
                    
                    if let selectedPage = vm.vc?.selectedPage {
                        Text("Page \(selectedPage + 1) of \(note.pages.count)")
                            .monospacedDigit()
                    }
                    
                    Divider()
                        .frame(height: 20)
                    
                    Button {
                        vm.next()
                    } label: {
                        Image(systemName: "arrow.forward")
                            .foregroundStyle(.foreground)
                    }
                }
                .footnote()
                .padding(.horizontal, 4)
                .background(.ultraThickMaterial, in: .rect(cornerRadius: 5))
                .padding(5)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let edgeWidth = 20.0
                        let minimumDragTranslation = 50.0
                        
                        if value.startLocation.x < edgeWidth && value.translation.width > minimumDragTranslation {
                            dismiss()
                        }
                    }
            )
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    if vm.vc?.groupSession?.state != .joined {
                        Button("Share") {
                            vm.vc?.startSharing()
                        }
                    }
                    
                    //                    if let selectedPage = drawingController.vc?.selectedPage {
                    //                        Text("Page \(selectedPage + 1) of \(note.pages.count)")
                    //                    }
                    //
                    //                    Button("Previous") {
                    //                        drawingController.previous()
                    //                    }
                    //                    .disabled(isFirstPage)
                    //
                    //                    Button("Next") {
                    //                        drawingController.next()
                    //                    }
                    
                    Button {
                        vm.deletePage()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                    .disabled(note.pages.count == 1)
                    
                    Button(role: .destructive) {
                        vm.clear()
                    } label: {
                        Label("Clear", systemImage: "eraser")
                            .foregroundStyle(.red)
                    }
                    .disabled(strokes == 0)
                    
                    Text("\(strokes ?? 0) strokes")
                        .numericTransition()
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
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
                        
                        Text(toolWidth)
                        
                        Slider(value: $toolWidth, in: 1...100, step: 0.1)
                            .padding()
                        
                        Button("Set Tool Width") {
                            vm.changeToolWidth(to: toolWidth)
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
        .environmentObject(Storage())
}
