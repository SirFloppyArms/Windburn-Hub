//
//  EventFormView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct EventFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CalendarViewModel

    @State var title: String = ""
    @State var date: Date = Date()
    @State var location: String = ""
    @State var type: String = "Training"
    @State var registrationLink: String = ""
    @State var courseMapURL: String = ""
    @State var details: String = ""
    
    var editingEvent: Event?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Title", text: $title)
                    DatePicker("Date & Time", selection: $date)
                    TextField("Location", text: $location)
                    TextField("Type", text: $type)
                }

                Section(header: Text("Links")) {
                    TextField("Registration Link", text: $registrationLink)
                    TextField("Course Map URL", text: $courseMapURL)
                }

                Section(header: Text("Details")) {
                    TextEditor(text: $details)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(editingEvent == nil ? "Add Event" : "Edit Event")
            .navigationBarItems(leading: Button("Cancel", action: { dismiss() }),
                                trailing: Button("Save") {
                let newEvent = Event(
                    id: editingEvent?.id,
                    title: title,
                    date: date,
                    type: type,
                    location: location,
                    registrationLink: registrationLink,
                    courseMapURL: courseMapURL,
                    details: details
                )

                if editingEvent != nil {
                    viewModel.updateEvent(newEvent)
                } else {
                    viewModel.addEvent(newEvent)
                }
                dismiss()
            })
            .onAppear {
                if let event = editingEvent {
                    title = event.title
                    date = event.date
                    location = event.location
                    type = event.type
                    registrationLink = event.registrationLink
                    courseMapURL = event.courseMapURL
                    details = event.details
                }
            }
        }
    }
}
