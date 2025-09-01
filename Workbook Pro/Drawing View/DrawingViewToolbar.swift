import ScrechKit

struct DrawingToolbar: ViewModifier {
    @EnvironmentObject private var store: ValueStore
    
    @Bindable var vm: DrawingVM
    let note: Note
    
    @State private var dialogErase = false
    
    func body(content: Content) -> some View {
        content
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
                    
                    if vm.vc?.groupSession?.state != .joined, store.enableGroupActivities {
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
