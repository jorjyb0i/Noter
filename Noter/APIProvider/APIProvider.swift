import Foundation
import CoreData

class APIProvider {
    
    func getAllNotes() -> NSFetchedResultsController<Note>? {
        updateNotes()
        let controller = CoreDataStack.controllerObjects("Note", withPredicate: nil, sortDescriptors: [NSSortDescriptor(key: "document_name", ascending: true)], sectionNameKeyPath: nil)
        return controller as? NSFetchedResultsController<Note>
    }
    
    func changeNote(changingNote: Note, serverElement: [String : Any]) {
        if changingNote.document_name != serverElement["document_name"] as? String {
            changingNote.document_name = serverElement["document_name"] as? String
        }
        if changingNote.document_type != serverElement["docunent_type"] as? String {
            changingNote.document_type = serverElement["docunent_type"] as? String
        }
    }
    
    func getOrCreateNote(currentId: Int64) -> Note {
        if let existingNote = CoreDataStack.singleObject("Note", withPredicate: NSPredicate(format: "id == %ld", currentId), sortDescriptors: nil) as? Note {
            return existingNote
        } else {
            let newNote = Note(context: CoreDataStack.getBackgroundContext())
            newNote.id = currentId
            return newNote
        }
    }
    
    func processNote(serverElement: [String : Any]) {
        if let currentId = serverElement["id"] as? Int64 {
            self.changeNote(changingNote: self.getOrCreateNote(currentId: currentId), serverElement: serverElement)
        }
    }
    
    // MARK: Server Calling
    
    func updateNotes() {
        ServerProvider.fetchNoteData(method: "list/", requestMethod: "GET", sendingData: nil) { (recievedData, error) in
            if let castedtoArrayData = recievedData as? [[String: Any]] {
                CoreDataStack.write {
                    for element in castedtoArrayData {
                        self.processNote(serverElement: element)
                    }
                }
            }
        }
    }
    
    func createNote(note: Note, recievedAPIData: @escaping (_ recievedData: Note) -> Void) {
        let serializedData = try? JSONEncoder().encode(note)
        ServerProvider.fetchNoteData(method: "", requestMethod: "POST", sendingData: serializedData) { (recievedData, error) in
            if let castedToDictionaryData = recievedData as? [String : Any] {
                CoreDataStack.write {
                    self.processNote(serverElement: castedToDictionaryData)
                }
            }
        }
    }
    
    func deleteNote(note: Note) {
        ServerProvider.fetchNoteData(method: "\(note.id)/", requestMethod: "DELETE", sendingData: nil) { (recievedData, error) in
            if let error = error {
                print("Unable to delete data \(error)")
            } else {
                let noteId = note.id
                CoreDataStack.getBackgroundContext().perform {
                    if let noteToDelete = CoreDataStack.singleObject("Note", withPredicate: NSPredicate(format: "id == %ld", noteId), sortDescriptors: nil) as? Note {
                        CoreDataStack.getBackgroundContext().delete(noteToDelete)
                        CoreDataStack.save()
                    }
                }
            }
        }
    }
    
    func updateNote(note: NoteModel) {
        let serializedData = try? JSONEncoder().encode(note)
        ServerProvider.fetchNoteData(method: "", requestMethod: "PUT", sendingData: serializedData) { (recievedData, error) in
            
        }
    }
    
    func getDetails(id: Int, recievedAPIData: @escaping (_ recievedData: NoteModel) -> Void) {
        ServerProvider.fetchNoteData(method: "\(id)/", requestMethod: "GET", sendingData: nil) { (recievedData, error) in
            if let castedRecievedData = recievedData as? [String : Any] {
                let recievedElement = NoteModel(recievedData: castedRecievedData)
                recievedAPIData(recievedElement)
            }
        }
    }
    
}
