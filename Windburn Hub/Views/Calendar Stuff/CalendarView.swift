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
    
    init() {
        _viewModel = StateObject(wrappedValue: CalendarViewModel(authVM: AuthViewModel()))
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    WindburnColors.darkBackground.ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Header
                        Text("📅 Windburn Calendar")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(WindburnColors.primary)
                            .padding(.top, geo.safeAreaInsets.top + 6)
                            .padding(.bottom, 4)

                        // Calendar Grid
                        CalendarGridView(
                            selectedDate: $selectedDate,
                            items: viewModel.events.map { CalendarItem.event($0) } +
                                   viewModel.raceLogs.map { CalendarItem.race($0) }
                        )
                        .id(selectedDate)
                        .frame(maxHeight: 300)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                        .frame(maxWidth: 700)

                        Divider()
                            .background(WindburnColors.primary.opacity(0.3))
                            .padding(.horizontal)

                        // Scrollable daily list
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 14) {
                                let dayItems = viewModel.calendarItems(for: selectedDate)
                                
                                if dayItems.isEmpty {
                                    Text("No events or races today.")
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 24)
                                } else {
                                    ForEach(dayItems) { item in
                                        Button {
                                            switch item {
                                            case .event(let event): selectedEvent = event
                                            case .race(let race): selectedRace = race
                                            }
                                        } label: {
                                            HStack(spacing: 12) {
                                                Image(systemName: item.typeIcon)
                                                    .font(.title3)
                                                    .foregroundColor(WindburnColors.primary)

                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(item.title)
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                        .lineLimit(2)

                                                    Text(item.date.formatted(date: .omitted, time: .shortened))
                                                        .foregroundColor(.gray)
                                                        .font(.caption)
                                                }

                                                Spacer()
                                            }
                                            .padding()
                                            .background(WindburnColors.cardDark)
                                            .cornerRadius(16)
                                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                        }
                                    }
                                }
                            }
                            .padding(.top, 12)
                            .padding(.horizontal)
                            .frame(maxWidth: 700)
                        }

                        Spacer(minLength: 0)
                    }
                    .safeAreaInset(edge: .bottom) {
                        if authViewModel.role == "coach" || authViewModel.role == "admin" {
                            WindburnButton(title: "➕ Add New Event") {
                                eventToEdit = nil
                                showEventForm = true
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                            .frame(maxWidth: 700)
                        }
                    }
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
