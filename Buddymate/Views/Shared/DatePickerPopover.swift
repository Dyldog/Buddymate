//
//  DatePickerPopover.swift
//  Buddymate
//
//  Created by Dylan Elliott on 30/9/21.
//

import SwiftUI
import SwiftUIDatePickerDialog


struct DatePickerPopover: View {
    @State var date: Date
    let onSelection: (Date) -> Void
    var body: some View {
        EmptyView()
            .dateTimePickerDialog(
                isShowing: .constant(true),
                selection: $date,
                style: .graphical,
                buttons: [
                    .default(label: "Add", action: { dialog in
                        dialog.confirm()
                        onSelection(dialog.selection)
                    })
                ]
            )
    }
}

struct DatePickerPopover_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerPopover(date: .now, onSelection: { _ in })
    }
}
