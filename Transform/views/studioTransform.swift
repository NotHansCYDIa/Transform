//
//  studioTransform.swift
//  Transform
//
//  Created by NotHansCYDIA on 5/14/24.
//

import SwiftUI

enum wrap_view_type {
    case regular
    case scroll
    case navView
    case navStack
}

struct wrap_view: Identifiable {
    var mainView: Bool
    var title: String
    var num: Int
    
    var bgCol: Color
    var elements: Array<wrap_elements>
    var statusBar: Bool
    var paddingEnabled: Bool
    var padding: Int?
    
    var view_type: wrap_view_type
    
    let id = UUID()
}

struct wrap_elements: Identifiable {
    let id = UUID()
}

struct IdentifiableColor: Identifiable {
    let id = UUID()
    var name: String
    var color: Color
}

struct studioTransform: View {
    
    @State private var dragOffset = CGSize.zero
    @State private var lastDragPosition = CGSize.zero
    
    @State private var creator_playing = false
    @State private var tutorial = true
    
    @State private var creator_sheet = true
    
    @State private var creator: Array<wrap_view> = [
        wrap_view(mainView: true, title: "Page 1", num: 1, bgCol: .white, elements: [], statusBar: true, paddingEnabled: false, view_type: .regular),
    ]
    @State private var creator_viewSelection: wrap_view = wrap_view(mainView: false, title: "debug", num: 0, bgCol: .white, elements: [], statusBar: true, paddingEnabled: false, view_type: .regular)
    
    @State private var creator_control: Array<Bool> = [false]
    // FOR VIEWS: [BACKGROUND COLOR]
    
    @State var creator_colors: [IdentifiableColor] = [
            IdentifiableColor(name: "Red", color: .red),
            IdentifiableColor(name: "Orange", color: .orange),
            IdentifiableColor(name: "Yellow", color: .yellow),
            IdentifiableColor(name: "Green", color: .green),
            IdentifiableColor(name: "Blue", color: .blue),
            IdentifiableColor(name: "Cyan", color: .cyan),
            IdentifiableColor(name: "Mint", color: .mint),
            IdentifiableColor(name: "Teal", color: .teal),
            IdentifiableColor(name: "Pink", color: .pink),
            IdentifiableColor(name: "Purple", color: .purple),
            IdentifiableColor(name: "Indigo", color: .indigo),
            IdentifiableColor(name: "Gray", color: .gray),
            IdentifiableColor(name: "White", color: .white),
            IdentifiableColor(name: "Black", color: .black),
            IdentifiableColor(name: "Primary", color: .primary),
            IdentifiableColor(name: "Secondary", color: .secondary)
        ]
    

    var body: some View {
        NavigationStack {
            ZStack {
                
                if tutorial {
                    VStack {
                        Image(systemName: "hand.draw.fill")
                            .resizable()
                            .frame(width: 70,height: 70)
                        Text("Drag to Move")
                            .font(.headline.bold())
                            .shadow(radius: 10)
                        
                    } .shadow(radius: 10) .padding() .background(.ultraThinMaterial) .cornerRadius(12) .zIndex(99999)
                }
                
                VStack { // MARK: CREATE VIEW
                    ForEach(creator) { obj_view in
                        ZStack {
                            obj_view.bgCol
                            VStack {
                                
                            }
                        } .border(Color.yellow, width: creator_viewSelection.num == obj_view.num ? 9 : 0) .cornerRadius(18) .ignoresSafeArea(edges: creator_playing == true ? .all : .top) .padding(creator_playing == true ? 0 : 10) .onTapGesture {
                            withAnimation(.spring) {
                                creator_viewSelection = obj_view
                            }
                        } .statusBarHidden(obj_view.statusBar == false ? true : false)
                    }
                } .frame(width: .infinity, height: .infinity) .offset(x: dragOffset.width, y: dragOffset.height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5)) {
                                    tutorial = false
                                    self.dragOffset = CGSize(width: value.translation.width + self.lastDragPosition.width,
                                                             height: value.translation.height + self.lastDragPosition.height)
                                }
                            }
                            .onEnded { value in
                                withAnimation(.easeOut(duration: 0.5)) {
                                    self.lastDragPosition = self.dragOffset
                                }
                            }
                    )
                    
            }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) { // MARK: TOOLBAR
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) { // MARK: PLAY
                                creator_playing.toggle()
                                dragOffset = CGSize.zero
                                lastDragPosition = CGSize.zero
                            }
                        } label: {
                            if creator_playing {
                                
                                Image(systemName: "pause.fill")
                                    .foregroundColor(.white)
                                    .shadow(radius: 10)
                                    .padding(10)
                            } else {
                                
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .shadow(radius: 10)
                                    .padding(10)
                            }
                        } .shadow(radius: 10) .buttonStyle(.bordered) .padding(.horizontal)
                        
                    }
                    
                    if creator_playing == false {
                        
                        ToolbarItem(placement: .bottomBar) { // MARK: CREATOR SHEET
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    creator_sheet = true
                                }
                            } label: {
                                Image(systemName: "rectangle.grid.2x2.fill")
                                    .foregroundColor(.white)
                                    .shadow(radius: 10)
                                    .padding(10)
                            } .shadow(radius: 10) .buttonStyle(.bordered)
                            
                        }
                        
                        ToolbarItem(placement: .bottomBar) { // MARK: EXIT SHEET
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    
                                }
                            } label: {
                                Image(systemName: "xmark.app.fill")
                                    .foregroundColor(.white)
                                    .shadow(radius: 10)
                                    .padding(10)
                            } .shadow(radius: 10) .buttonStyle(.bordered) .padding(.horizontal)
                            
                        }
                    }
                } .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.109)) .sheet(isPresented: $creator_sheet, content: { // MARK: SHEET
                    ScrollView {
                        VStack {
                            
                            if creator_viewSelection.num == 0 {
                                VStack {
                                    Spacer(minLength: 90)
                                    Text("Select a view.")
                                        .foregroundStyle(.gray)
                                        .font(.title2.bold())
                                }
                            } else {
                                Spacer(minLength: 30)
                                HStack {
                                    Text("Design")
                                        .font(.title2.bold())
                                    Spacer()
                                }
                                
                                VStack {
                                    
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundColor(creator_control[0] == false ? Color(uiColor: .tertiarySystemFill) : Color(uiColor: .gray))
                                        
                                        HStack {
                                            Circle()
                                                .foregroundColor(creator_viewSelection.num != 0 ? creator[creator_viewSelection.num - 1].bgCol : .clear)
                                                .shadow(radius: 10)
                                            
                                            Text("Background Color")
                                                .font(.system(size: 20).bold())
                                                .shadow(radius: 10)
                                        } .padding() .onTapGesture {
                                            withAnimation(.spring) {
                                                creator_control[0].toggle()
                                            }
                                        }
                                    } .frame(height: 60)
                                    
                                    
                                    
                                    if creator_control[0] == true {
                                        ForEach(creator_colors) { colr in
                                            
                                            ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .foregroundColor(Color(uiColor: .tertiarySystemFill))
                                                    .shadow(radius: 10)
                                                    .frame(height: 70)
                                                
                                                HStack {
                                                    Circle()
                                                        .foregroundColor(colr.color)
                                                        .shadow(radius: 10)
                                                        .frame(width: 30,height: 30)
                                                    
                                                    Text(colr.name)
                                                        .font(.system(size: 20).bold())
                                                        .shadow(radius: 10)
                                                } .padding()
                                            } .onTapGesture {
                                                
                                                
                                                withAnimation(.spring) {
                                                    creator[creator_viewSelection.num - 1].bgCol = colr.color
                                                    creator_control[0] = false
                                                }
                                            }
                                        }
                                    }
                                    
                                    
                                }  .shadow(radius: 10)
                            }
                        } .presentationDetents([.medium, .large]) .padding()
                    }
                })
        }
    }
}

#Preview {
    studioTransform()
}
