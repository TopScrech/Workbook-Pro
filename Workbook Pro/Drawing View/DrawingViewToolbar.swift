import ScrechKit

struct DrawingViewToolbar: ViewModifier {
    @EnvironmentObject private var store: ValueStore
    @Environment(DrawingVM.self) private var vm
    
    @Bindable private var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    @State private var dialogErase = false
    @State private var alertRename = false
    
    func body(content: Content) -> some View {
        @Bindable var vm = vm
        
        content
            .alert("Rename", isPresented: $alertRename) {
                TextField("New note", text: $note.name)
            }
            .onChange(of: vm.toolWidth) { _, newValue in
                vm.changeToolWidth(to: newValue)
            }
            .toolbar {
                ToolbarItemGroup {
                    //                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        vm.deletePage()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                    .disabled(note.pages.count == 1)
                    
                    SFButton("eraser.fill") {
                        dialogErase = true
                    }
                    .foregroundStyle(.primary)
                    .disabled((vm.strokes ?? 0) == 0)
                    .alert("Erase this page?", isPresented: $dialogErase) {
                        Button("Erase", role: .destructive) {
                            vm.clear()
                        }
                    }
                    
                    if store.enableGroupActivities, vm.vc?.groupSession?.state != .joined {
                        Menu {
                            Button("SharePlay", systemImage: "shareplay") {
                                vm.vc?.startSharing()
                            }
                        } label: {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .symbolRenderingMode(.multicolor)
                        }
                    }
                }
                
                if #available(iOS 26.0, *) {
                    ToolbarSpacer(.fixed)
                }
                
                ToolbarItemGroup {
                    Menu {
#if DEBUG
                        if let strokes = vm.strokes, strokes > 0 {
                            Text("\(strokes) strokes")
                                .numericTransition()
                                .secondary()
                                .padding(.leading, 10)
                            
                            Divider()
                        }
#endif
                        Button("Rename", systemImage: "pencil") {
                            alertRename = true
                        }
                        
                        Divider()
                        
                        Button("Clear", systemImage: "xmark") {
                            vm.clear()
                        }
                        
                        Button("Undo", systemImage: "arrow.uturn.backward") {
                            vm.undo()
                        }
                        
                        Button("Redo", systemImage: "arrow.uturn.forward") {
                            vm.redo()
                        }
                        
                        Divider()
                        
                        Slider(value: $vm.toolWidth, in: 1...100, step: 0.1) {
                            Label("Set Tool Width: \(String(format: "%.1f", vm.toolWidth))", systemImage: "paintbrush.pointed")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
    }
}

extension View {
    func drawingToolbar(_ note: Note) -> some View {
        modifier(DrawingViewToolbar(note))
    }
}
