import PencilKit
import GroupActivities

extension DrawingVC {
    func reset() {
        // Tear down the existing groupSession
        messenger = nil
        journal = nil
        
        tasks.forEach {
            $0.cancel()
        }
        
        tasks = []
        subscriptions = []
        
        if groupSession != nil {
            groupSession?.leave()
            groupSession = nil
            startSharing()
        }
    }
    
    func sendUpdate() {
        print(#function)
        
        if let messenger: GroupSessionMessenger = self.messenger {
            Task {
                try? await messenger.send(
                    UpdateCommand(strokes: note?.pages.wrappedValue ?? [])
                )
            }
        }
    }
    
    func startSharing() {
        Task {
            do {
                _ = try await WorkbookProGroupSession().activate()
            } catch {
                print("Failed to activate DrawTogether activity:", error.localizedDescription)
            }
        }
    }
    
    func configureGroupSession(_ groupSession: GroupSession<WorkbookProGroupSession>) {
        print(#function)
        
        // Assign the passed group session to the instance variable
        self.groupSession = groupSession
        
        messenger = GroupSessionMessenger(session: groupSession)
        journal = GroupSessionJournal(session: groupSession)
        
        // Monitot group session state
        groupSession.$state
            .sink { [weak self] state in
                if case .invalidated = state {
                    self?.groupSession = nil
                    self?.reset()
                }
            }
            .store(in: &subscriptions)
        
        // Monitor active participants in the group session
        groupSession.$activeParticipants
            .sink { [weak self] activeParticipants in
                
                guard let self else {
                    return
                }
                
                let newParticipants = activeParticipants.subtracting(groupSession.activeParticipants)
                
                Task {
                    try? await self.messenger!.send(
                        UpdateCommand(strokes: self.note?.pages.wrappedValue ?? []),
                        to: .only(newParticipants)
                    )
                }
            }
            .store(in: &subscriptions)
        
        // Handle setup messages
        var task: Task<Void, Never> = Task {
            for await (message, _) in self.messenger!.messages(of: SetupCommand.self) {
                handle(message)
            }
        }
        
        tasks.insert(task)
        
        // Handle update messages
        task = Task {
            for await (message, _) in self.messenger!.messages(of: UpdateCommand.self) {
                handle(message)
            }
        }
        
        tasks.insert(task)
        
        // Uncomment this section if you need to handle images from journal attachments
        // task = Task {
        //     for await images in journal.attachments {
        //         await handle(images)
        //     }
        // }
        // tasks.insert(task)
        
        groupSession.join()
    }
    
    func handle(_ message: SetupCommand) {
        print(#function)
        
        
    }
    
    func handle(_ message: UpdateCommand) {
        print(#function)
        
        isRemoteUpdate = true
        
        if let updatedDrawing = try? PKDrawing(data: message.strokes.first!) {
            canvasView.drawing = updatedDrawing
        }
    }
}
