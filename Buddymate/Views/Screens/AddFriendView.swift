//
//  AddFriendView.swift
//  Buddymate
//
//  Created by Dylan Elliott on 30/9/21.
//

import SwiftUI

struct AddFriendView: View {
    @State var name: String
    @State var desiredFrequency: Int
    let buttonTitle: String
    var addDisabled: Bool { desiredFrequency == 0 || name.count == 0 }
    
    let onAdd: (String, Int) -> Void
    
    init(_ values: (name: String, desiredFrequency: Int)? = nil, onAdd: @escaping (String, Int) -> Void) {
        if let values = values {
            name = values.name
            desiredFrequency = values.desiredFrequency
            buttonTitle = "Save"
        } else {
            name = ""
            desiredFrequency = Constants.defaultFrequency
            buttonTitle = "Add"
        }
        
        self.onAdd = onAdd
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Group {
                TextField("Name", text: $name, prompt: Text("Name").font(.largeTitle.bold())).multilineTextAlignment(.center)
                    .font(.largeTitle.bold())
                NumberView(number: "\(desiredFrequency)", label: "desired meeting frequency")
                Stepper("", value: $desiredFrequency, in: 0...Int.max)
                    .labelsHidden()
                
                Text("You can't have an event every zero days, dingus")
                    .foregroundColor(desiredFrequency == 0 ? .primary : .clear)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.top)
            }
            .offset(y: 20)
            
            Spacer()
            
            Button {
                onAdd(name, desiredFrequency)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(addDisabled ? .gray : .blue)
                        .frame(height: 40)
                    Text("Add")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
            .disabled(addDisabled)
            .padding(.bottom)

        }
        .padding()
    }
}

extension AddFriendView {
    enum Constants {
        static let defaultFrequency: Int = 7
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView(onAdd: { _,_ in })
    }
}

