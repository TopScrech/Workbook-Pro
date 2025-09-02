import ScrechKit

struct DrawingToolbar: ViewModifier {
    @EnvironmentObject private var store: ValueStore
    
    @Bindable var vm: DrawingVM
    @Bindable var note: Note
    
    @State private var dialogErase = false
    @State private var alertRename = false
    
    func body(content: Content) -> some View {
        content
            .alert("Rename", isPresented: $alertRename) {
                TextField("New note", text: $note.name)
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
                        
                        Text(vm.toolWidth)
                        
                        Slider(value: $vm.toolWidth, in: 1...100, step: 0.1)
                            .padding()
                        
                        Button("Set Tool Width", systemImage: "paintbrush.pointed") {
                            vm.changeToolWidth(to: vm.toolWidth)
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
    }
}

extension View {
    func drawingToolbar(vm: DrawingVM, note: Note) -> some View {
        modifier(DrawingToolbar(vm: vm, note: note))
    }
}
