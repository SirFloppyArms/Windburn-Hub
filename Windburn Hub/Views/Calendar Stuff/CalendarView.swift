//
//  CalendarView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = CalendarViewModel()

    @State private var selectedDate = Date()
    @State private var selectedEvent: Event? = nil
    @State private var showDetail = false

    @State private var showForm = false
    @State private var eventToEdit: Event? = nil

    var body: some View {
        NavigationView {
            VStack {
                Text("Windburn Calendar")
                    .font(.title)
                    .padding(.top)

                CalendarGridView(
                    selectedDate: $selectedDate,
                    events: viewModel.events
                )

                Divider().padding(.top)

                ScrollView {
                    let dayEvents = viewModel.events(for: selectedDate)

                    if dayEvents.isEmpty {
                        Text("No events for this day.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(dayEvents) { event in
                            Button {
                                selectedEvent = event
                                showDetail = true
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(event.title).bold()
                                    Text(event.date.formatted(date: .omitted, time: .shortened))
                                }
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                    }
                }

                if authViewModel.role == "coach" || authViewModel.role == "admin" {
                    Button(action: {
                        eventToEdit = nil
                        showForm = true
                    }) {
                        Label("Add New Event", systemImage: "plus")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
            }
            .sheet(isPresented: $showForm) {
                EventFormView(viewModel: viewModel, editingEvent: eventToEdit)
            }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(
                    event: event,
                    isEditable: authViewModel.role == "coach" || authViewModel.role == "admin",
                    onEdit: {
                        eventToEdit = event
                        showForm = true
                        selectedEvent = nil
                    },
                    onDelete: {
                        viewModel.deleteEvent(event)
                        selectedEvent = nil
                    }
                )
            }
            .onAppear {
                viewModel.fetchEvents()
            }
        }
    }
}
