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
                ToolbarItemGroup(placement: .topBarTrailing) {
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
                    .confirmationDialog("Erase this page?", isPresented: $dialogErase) {
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
                                .tint(.secondary)
                        }
                    }
                    
                    Menu {
#if DEBUG
                        Text("\(vm.strokes ?? 0) strokes")
                            .numericTransition()
                            .secondary()
                            .padding(.leading, 10)
#endif
                        Button("Rename", systemImage: "pencil") {
                            alertRename = true
                        }
                        
                        Divider()
                        
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

extension View {
    func drawingToolbar(vm: DrawingVM, note: Note) -> some View {
        modifier(DrawingToolbar(vm: vm, note: note))
    }
}
