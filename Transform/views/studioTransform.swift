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
}

struct wrap_view: Identifiable {
    var mainView: Bool
    var title: String
    var num: Int
    
    var bgCol: Color
    var elements: Array<wrap_elements>
    var statusBar: Bool
    var paddingEnabled: Bool
    var paddingInt: Double
    
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


struct IdentifiableViewType: Identifiable {
    let id = UUID()
    var name: String
    var value: wrap_view_type
}

struct studioTransform: View {
    
    @State private var dragOffset = CGSize.zero
    @State private var lastDragPosition = CGSize.zero
    
    @State private var creator_playing = false
    @State private var tutorial = true
    
    @State private var creator_sheet = false
    @State private var element_sheet = false
    
    @State private var creator: Array<wrap_view> = [
        wrap_view(mainView: true, title: "Page 1", num: 1, bgCol: .white, elements: [], statusBar: true, paddingEnabled: false, paddingInt: 0,  view_type: .regular),
        wrap_view(mainView: false, title: "Page 1", num: 2, bgCol: .white, elements: [], statusBar: true, paddingEnabled: false, paddingInt: 0,  view_type: .regular),
    ]
    @State private var creator_viewSelection: wrap_view = wrap_view(mainView: false, title: "debug", num: 0, bgCol: .white, elements: [], statusBar: true, paddingEnabled: false, paddingInt: 0,  view_type: .regular)
    
    @State private var creator_control: Array<Bool> = [false, false]
    // FOR VIEWS: [BACKGROUND COLOR, VIEW TYPE (REGULAR, SCROLLVIEW, ETC.)]
    
    func indexOfMainView() -> Int? {
        return creator.firstIndex(where: { $0.mainView == true })
    }
    
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
    
    @State var creator_view_type: [IdentifiableViewType] = [
        IdentifiableViewType(name: "Regular", value: .regular),
        IdentifiableViewType(name: "Scroll View", value: .scroll),
        ]
    @State private var creator_pd = "0"
    

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
                
                
                GeometryReader { geom in // MARK: CREATE VIEW
                    VStack {
                        ForEach(creator) { obj_view in
                            if creator_playing == false || creator[obj_view.num - 1].mainView == true {
                                ZStack {
                                    obj_view.bgCol
                                    Group {
                                        if creator[obj_view.num - 1].view_type == .regular {
                                            VStack {
                                                
                                            }
                                        } else if creator[obj_view.num - 1].view_type == .scroll {
                                            ScrollView {
                                                
                                            }
                                        }
                                    } .padding(creator[obj_view.num - 1].paddingEnabled == true ?  creator[obj_view.num - 1].paddingInt : 0)
                                } .frame(width: creator_playing == true ? .nan : 360, height: creator_playing == false ? 700 : .nan, alignment: .top) .border(Color.yellow, width: creator_viewSelection.num == obj_view.num ? 9 : 0) .cornerRadius(18) .ignoresSafeArea(edges: creator_playing == true ? .all : .top) .onTapGesture {
                                    withAnimation(.spring) {
                                        creator_viewSelection = obj_view
                                    }
                                } .statusBarHidden(obj_view.statusBar == false ? true : false)
                                
                                
                            }
                        }
                        Spacer()
                    }
                } .offset(x: dragOffset.width, y: dragOffset.height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if creator_playing == false {
                                    withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5)) {
                                        tutorial = false
                                        self.dragOffset = CGSize(width: value.translation.width + self.lastDragPosition.width,
                                                                 height: value.translation.height + self.lastDragPosition.height)
                                    }
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
                                lastDragPosition = CGSize.zero
                                creator_viewSelection = wrap_view(mainView: true, title: "debug", num: 0, bgCol: .accent, elements: [], statusBar: true, paddingEnabled: true, paddingInt: 0,  view_type: .regular)
                                dragOffset = CGSize.zero
                                /*
                                 
                                 if let index = indexOfMainView() {
                                     dragOffset = CGSize(width: -CGFloat(index) * UIScreen.main.bounds.width, height: 0)
                                 }
                                 */
                            }
                        } label: {
                            if creator_playing {
                                
                                Image(systemName: "pause.fill")
                                    .foregroundColor(.white)
                                    .shadow(radius: 10)
                                    .padding(5)
                            } else {
                                
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .shadow(radius: 10)
                                    .padding(5)
                            }
                        } .shadow(radius: 5) .buttonStyle(.bordered) .padding(.horizontal)
                        
                    }
                    
                    if creator_playing == false {
                        
                        ToolbarItem(placement: .bottomBar) { // MARK: VIEW SHEET
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    creator_sheet = true
                                }
                            } label: {
                                Image(systemName: "rectangle.grid.2x2.fill")
                                    .foregroundColor(.white)
                                    .shadow(radius: 10)
                                    .padding(5)
                            } .shadow(radius: 10) .buttonStyle(.bordered)
                            
                        }
                        
                        ToolbarItem(placement: .bottomBar) { // MARK: ELEMENT SHEET
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    element_sheet = true
                                }
                            } label: {
                                Image(systemName: "batteryblock.fill")
                                    .foregroundColor(.white)
                                    .shadow(radius: 10)
                                    .padding(5)
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
                                    
                                    ZStack(alignment: .leading) { // MARK: BG COL
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
                                    
                                    ZStack(alignment: .leading) { // MARK: VIEW TYPE
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundColor(creator_control[1] == false ? Color(uiColor: .tertiarySystemFill) : Color(uiColor: .gray))
                                        
                                        HStack {
                                            
                                            Text("View Type")
                                                .font(.system(size: 20).bold())
                                                .shadow(radius: 10)
                                        } .padding() .onTapGesture {
                                            withAnimation(.spring) {
                                                creator_control[1].toggle()
                                            }
                                        }
                                    } .frame(height: 60)
                                    
                                    if creator_control[1] == true {
                                        ForEach(creator_view_type) { colr in
                                            
                                            ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .foregroundColor(Color(uiColor: .tertiarySystemFill))
                                                    .shadow(radius: 10)
                                                    .frame(height: 70)
                                                
                                                HStack {
                                                    
                                                    Text(colr.name)
                                                        .font(.system(size: 20).bold())
                                                        .shadow(radius: 10)
                                                } .padding()
                                            } .onTapGesture {
                                                
                                                
                                                withAnimation(.spring) {
                                                    creator[creator_viewSelection.num - 1].view_type = colr.value
                                                    creator_control[1] = false
                                                }
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    ZStack(alignment: .leading) { // MARK: VIEW NAME
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundColor(creator_control[0] == false ? Color(uiColor: .tertiarySystemFill) : Color(uiColor: .gray))
                                        
                                        HStack {
                                            
                                            
                                            TextField("Page Title", text: $creator[creator_viewSelection.num - 1].title)
                                                .font(.system(size: 20).bold())
                                                .shadow(radius: 10)
                                                .foregroundColor(.white)
                                            /*
                                            Text("Page Title")
                                                .font(.system(size: 20).bold())
                                                .shadow(radius: 10)
                                                .foregroundColor(.secondary)
                                             */
                                            
                                            Spacer()
                                            
                                            Text("Page Title")
                                                .font(.system(size: 20).bold())
                                                .shadow(radius: 10)
                                            
                                        } .padding()
                                    } .frame(height: 60)
                                    Text("Click to modify page title.")
                                        .font(.headline.bold())
                                        .foregroundStyle(.secondary)
                                    
                                    ZStack(alignment: .leading) { // MARK: PADDING
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundColor(creator_control[0] == false ? Color(uiColor: .tertiarySystemFill) : Color(uiColor: .gray))
                                        
                                        HStack {
                                            
                                            if creator[creator_viewSelection.num - 1].paddingEnabled == true {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .resizable()
                                                    .shadow(radius: 10)
                                                    .frame(width: 22,height: 22)
                                                    .foregroundColor(.green)
                                            } else {
                                                Image(systemName: "xmark.circle.fill")
                                                    .resizable()
                                                    .shadow(radius: 10)
                                                    .frame(width: 22,height: 22)
                                                    .foregroundColor(.red)
                                            }
                                            
                                            Text("Enable Padding")
                                                .font(.system(size: 20).bold())
                                                .shadow(radius: 10)
                                        } .padding() .onTapGesture {
                                            withAnimation(.spring) {
                                                creator[creator_viewSelection.num - 1].paddingEnabled.toggle()
                                            }
                                        }
                                    } .frame(height: 60)
                                    
                                    if creator[creator_viewSelection.num - 1].paddingEnabled == true {
                                        ZStack(alignment: .leading) { // MARK: PADDING AMOUNT
                                            RoundedRectangle(cornerRadius: 12)
                                                .foregroundColor(creator_control[0] == false ? Color(uiColor: .tertiarySystemFill) : Color(uiColor: .gray))
                                            
                                            HStack {
                                                
                                                
                                                TextField("Amount", text: $creator_pd)
                                                    .font(.system(size: 20).bold())
                                                    .shadow(radius: 10)
                                                    .foregroundColor(.white)
                                                    .keyboardType(.numberPad)
                                                    .onSubmit {
                                                        creator[creator_viewSelection.num - 1].paddingInt = Double(creator_pd)!
                                                    }
                                                
                                                /*
                                                Text("Page Title")
                                                    .font(.system(size: 20).bold())
                                                    .shadow(radius: 10)
                                                    .foregroundColor(.secondary)
                                                 */
                                                
                                                Spacer()
                                                
                                                Text("Padding Amount")
                                                    .font(.system(size: 20).bold())
                                                    .shadow(radius: 10)
                                                
                                            } .padding()
                                        } .frame(height: 60)
                                        Text("Click to modify padding amount.")
                                            .font(.headline.bold())
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    
                                    Spacer(minLength: 30)
                                    HStack {
                                        Text("Device")
                                            .font(.title2.bold())
                                        Spacer()
                                    }
                                    
                                    ZStack(alignment: .leading) { // MARK: STATUS BAR
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundColor(creator_control[0] == false ? Color(uiColor: .tertiarySystemFill) : Color(uiColor: .gray))
                                        
                                        HStack {
                                            
                                            if creator[creator_viewSelection.num - 1].statusBar == true {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .resizable()
                                                    .shadow(radius: 10)
                                                    .frame(width: 22,height: 22)
                                                    .foregroundColor(.green)
                                            } else {
                                                Image(systemName: "xmark.circle.fill")
                                                    .resizable()
                                                    .shadow(radius: 10)
                                                    .frame(width: 22,height: 22)
                                                    .foregroundColor(.red)
                                            }
                                            
                                            Text("Show Status Bar")
                                                .font(.system(size: 20).bold())
                                                .shadow(radius: 10)
                                        } .padding() .onTapGesture {
                                            withAnimation(.spring) {
                                                creator[creator_viewSelection.num - 1].statusBar.toggle()
                                            }
                                        }
                                    } .frame(height: 60)
                                    
                                    
                                }  .shadow(radius: 10)
                            }
                        } .presentationDetents([.medium, .large]) .padding()
                    }
                    
                })
                .sheet(isPresented: $element_sheet, content: { // MARK: ELEMENT SHEET
                    NavigationStack {
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
                                    NavigationLink(destination: {
                                        
                                    }) {
                                        HStack {
                                            Image(systemName: "abc")
                                                .resizable()
                                                .frame(width: 70,height: 28)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Text("Text")
                                                .font(.largeTitle)
                                        }
                                    }
                                }
                            }
                        }
                    } .presentationDetents([.medium, .large]) .padding(20)
                })
        }
    }
}

#Preview {
    studioTransform()
}
