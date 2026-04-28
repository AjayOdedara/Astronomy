//
//  DatePickerSheet.swift
//  Astronomy
//
//  Created by Ajay Odedara on 28/04/2026.
//

import SwiftUI

struct DatePickerSheet: View {
    
    @Binding var selectedDate: Date
    let buttonTitle: String
    let onSubmit: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            DatePicker("Select Date", selection: $selectedDate, in: ...Date.now, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { onCancel() }
                            .accessibilitySpeak(HomeAccessibility.Speak.cancelButton)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(buttonTitle) { onSubmit() }
                            .accessibilitySpeak(HomeAccessibility.Speak.confirmButton)
                    }
                }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
