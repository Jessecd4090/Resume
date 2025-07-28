    //
    //  ContentView.swift
    //  LumaTouchFinalCodeTest
    //
    //  Created by Jestin Dorius on 7/28/25.
    //

import SwiftUI

struct ContentView: View {
    enum loadingErrors: LocalizedError, Error {
        case invalidFileName
        case invalidData
    }
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
//                    .onAppear(perform: {
//                        currentSelection = viewModel.percents[0]
//                    })
                    .task {
                        do {
                            defer {
                                currentSelection = viewModel.percents[0]
                            }
                            let loadedPercents = try await loadPercents(fileName: "PercentData")
                            viewModel.percents = loadedPercents
                        } catch {
                            print("Error loading items: \(error)")
                        }
                    }
                
                
                
            } else {
                List {
                    ForEach(viewModel.percents, id: \.percentValue) { percent in
                        GeometryReader { geometry in
                            HStack {
                                Text(percent.description)
                                    .padding(.top, 5)
                                    .padding(.leading, 5)
                                    
                                    .foregroundStyle(percent == currentSelection ? Color.white : Color.black)
                                    // Still need to figure out the selection state for the texts
                                
                            }
                        }
                        .background(
                            content: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(
                                        percent == currentSelection ? Color.blue
                                            .mix(with: .black, by: 0.5)
                                            .opacity(0.9): Color.clear
                                    )
                            })
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
                
                Text(currentSelection.description)
                    .font(.title)
                    .padding(.top, 20)
                    .padding(.leading, 10)
                VStack {
                    let color = Color.init(name: currentSelection.backColor)
                        Circle()
                            .size(
                                width: geometry.size.width / 2,
                                height: geometry.size
                                    .height / 2)
                            .fill(color ?? Color.clear)
                            .padding(.leading, geometry.size.width / 4)
                            .padding(.trailing, geometry.size.width / 4)
                            .padding(.top, geometry.size.height / 4)
                            .padding(.bottom, geometry.size.height / 4)
                    
                    
                }
                .navigationTitle("Percent Viewer")
            }
            
        }
        
        
        
        
    }
    func loadPercents(fileName: String) async throws -> [Percent] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw loadingErrors.invalidFileName
        }
        do {
            /* It is interesting that we don't recieve a response
             here, but that makes sense given that we aren't reaching
             to an API
             */
            let data = try Data(contentsOf: url)
            print("Data Successfully Retrieved: \(data.count) bytes")
            let percents = try JSONDecoder().decode([Percent].self, from: data)
            print("Percents converted from jsonFile")
            return percents
        } catch {
            throw loadingErrors.invalidData
        }
    }
}
@Observable
class JsonViewModel {
    var percents: [Percent] = []
}

#Preview {
    ContentView()
}


extension Color {
    init?(name: String) {
        switch name.lowercased() {
        case "red": self = .red
        case "green": self = .green
        case "gray": self = .gray
        case "orange": self = .orange
        case "cyan": self = .cyan
        case "yellow": self = .yellow
        case "mint": self = .mint
        // Add other cases as needed
        default: return nil
        }
    }
}
