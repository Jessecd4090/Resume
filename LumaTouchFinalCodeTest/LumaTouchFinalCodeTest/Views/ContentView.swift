    //
    //  ContentView.swift
    //  LumaTouchFinalCodeTest
    //
    //  Created by Jestin Dorius on 7/28/25.
    //

import SwiftUI

struct ContentView: View {
    @State var viewModel = JsonViewModel()
    @State var currentSelection: Percent = Percent(
        description: "Fake",
        percentValue: 0.0,
        backColor: "",
        foreColor: "")
    var body: some View {
        NavigationSplitView {
                // This is the sideBar
            if viewModel.percents.isEmpty {
                ProgressView()
                    .task {
                        do {
                            defer {
                                currentSelection = viewModel.percents[0]
                            }
                            let loadedPercents = try await viewModel.loadPercents(fileName: "PercentData")
                            viewModel.percents = loadedPercents
                        } catch {
                            print("Error loading items: \(error)")
                        }
                    }
            } else {
                List {
                    ForEach(viewModel.percents, id: \.percentValue) { percent in
                        GeometryReader { geometry in
                            Text(percent.description)
                                .frame(width: geometry.size.width - 8,
                                    height: geometry.size.height, alignment: .leading)
                                .padding(.leading, 5)
                                .foregroundStyle(percent == currentSelection ? Color.white : Color.black)
                                // Still need to figure out the selection state for the texts
                                .background(content: {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(percent == currentSelection ? Color.blue
                                                    .mix(with: .black, by: 0.5)
                                                    .opacity(0.9): Color.clear)
                                    })
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            currentSelection = percent
                            print(currentSelection)
                        }
                    }
                }
            }
        } detail: {
                // This is the detailView
            GeometryReader { geometry in
                    // DetailView Variables
                let number = (currentSelection.percentValue * 100)
                    .rounded()
                let numInt = Int(number)
                let backColor = Color.init(name: currentSelection.backColor)
                let foreColor = Color.init(name: currentSelection.foreColor)
                Text(currentSelection.description)
                    .font(.title)
                    .padding(.top, 20)
                    .padding(.leading, 10)
                ZStack {
                    // Background Circle
                    Circle()
                        .size(width: geometry.size.width / 2, height: geometry.size.height / 2)
                        .fill(backColor?.opacity(0.6) ?? Color.clear)
                        .padding(.leading, geometry.size.width / 4)
                        .padding(.trailing, geometry.size.width / 4)
                        .padding(.top, geometry.size.height / 4)
                        .padding(.bottom, geometry.size.height / 4)
                    // Foreground Circle
                    Circle()
                        .size(width: geometry.size.width / 2, height: geometry.size.height / 2)
                        .trim(from: 0.0, to: min(CGFloat(currentSelection.percentValue), 1.0))
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .fill(foreColor ?? Color.clear)
                        .rotationEffect(.degrees(-90))
                        .padding(.leading, geometry.size.width / 4)
                        .padding(.trailing, geometry.size.width / 4)
                        .padding(.top, geometry.size.height / 4)
                        .padding(.bottom, geometry.size.height / 4)
                    Label {
                        Text("\(numInt)%")
                            .font(.title2)
                    } icon: {
                        // Couldn't figure out how to get a label without an image or icon
                        Text("")
                    }
                }
                .navigationTitle("Percent Viewer")
            }
        }
    }
}

#Preview {
    ContentView()
}
