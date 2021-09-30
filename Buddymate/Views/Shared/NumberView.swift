//
//  NumberView.swift
//  Buddymate
//
//  Created by Dylan Elliott on 30/9/21.
//

import SwiftUI

struct NumberView: View {
    let number: String
    let label: String
    var body: some View {
        VStack(alignment: .center) {
            Text(number)
                .font(.system(size: 80))
                .fontWeight(.bold)
                .minimumScaleFactor(0.5)
            Text(label)
                .font(.footnote)
                .multilineTextAlignment(.center)
        }
    }
}

struct NumberView_Previews: PreviewProvider {
    static var previews: some View {
        NumberView(number: "0", label: "days since covid")
    }
}
