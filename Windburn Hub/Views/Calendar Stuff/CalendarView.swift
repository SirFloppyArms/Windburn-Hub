//
//  CalendarView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: CalendarViewModel

    @State private var selectedDate = Date()
    @State private var selectedEvent: Event? = nil
    @State private var selectedRace: RaceLog? = nil

    @State private var showEventForm = false
    @State private var eventToEdit: Event? = nil

    @State private var showRaceDetail = false
    @State private var showEventDetail = false

    init() {
        _viewModel = StateObject(wrappedValue: CalendarViewModel(authVM: AuthViewModel()))
    }

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
                    let dayItems = viewModel.calendarItems(for: selectedDate)

                    if dayItems.isEmpty {
                        Text("No events or races for this day.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(dayItems) { item in
                            Button {
                                switch item {
                                case .event(let event):
                                    selectedEvent = event
                                    showEventDetail = true
                                case .race(let race):
                                    selectedRace = race
                                    showRaceDetail = true
                                }
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Image(systemName: item.typeIcon)
                                        Text(item.title).bold()
                                    }
                                    Text(item.date.formatted(date: .omitted, time: .shortened))
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
                        showEventForm = true
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
            .sheet(isPresented: $showEventForm) {
                EventFormView(viewModel: viewModel, editingEvent: eventToEdit)
            }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(
                    event: event,
                    isEditable: authViewModel.role == "coach" || authViewModel.role == "admin",
                    onEdit: {
                        eventToEdit = event
                        showEventForm = true
                        selectedEvent = nil
                    },
                    onDelete: {
                        viewModel.deleteEvent(event)
                        selectedEvent = nil
                    }
                )
            }
            .sheet(item: $selectedRace) { race in
                RaceDetailView(race: race)
            }
            .onAppear {
                viewModel.fetchAll()
            }
        }
    }
}
