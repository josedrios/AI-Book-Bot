import SwiftUI

struct Header: View {
    var body: some View {
        ZStack{
            HStack {
                Button(action: {
                    print("Pressed navbar button")
                }) {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .frame(width: 25, height: 18)
                        .font(.title)
                }
                .buttonStyle(.plain)
                .foregroundColor(Color.white)
                .padding(.leading,20)
                .padding(.top, 3)
                Spacer()
            }
            HStack(alignment:.bottom, spacing: 2){
                Text("READ")
                    .font(.custom("SpaceMono-Regular", size:30))
                    .foregroundColor(Color.white)
                Text("AI")
                    .font(.custom("SpaceMono-Regular", size:20))
                    .foregroundColor(Color.white)
                    .padding(.bottom, 18)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 3)
        .padding(.bottom, 15)
    }
}

struct Search: View {
    @Binding var ISBNentry: String
    @Binding var isLoading: Bool
    var fetchBook: () -> Void

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                if ISBNentry.isEmpty {
                    Text("Enter ISBN")
                        .foregroundColor(Color.white.opacity(0.4))
                        .font(.custom("SpaceMono-Regular", size: 17))
                        .padding(.leading, 5)
                }
                TextField("", text: $ISBNentry)
                    .foregroundColor(Color.white)
                    .font(.system(.title3, design: .monospaced))
                    .tint(Color.white)
                    .frame(height: 50)
                    .cornerRadius(5)
                    .padding(.leading, 5)
            }
            .padding(.leading, 10)
            
            Button(action: {
                isLoading = true
                fetchBook()
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.title)
                    .foregroundColor(isLoading ? Color.gray : Color.white.opacity(0.8))
                    .padding(.leading, 0)
                    .padding(.trailing, 10)
            }
            .disabled(isLoading)
        }
        .background(Color.white.opacity(0.2))
        .cornerRadius(5)
        .padding(.horizontal)
        .padding(.top, 5)
    }
}

struct Navbar: View {
    @Binding var currentCat: String
    @Binding var currentIndex: Int
    let categories: [String]

    var body: some View {
        ScrollViewReader{ proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            currentCat = category
                            updateIndex(category: category)
                            print("'\(category)' category was clicked")
                        }) {
                            Text(category)
                                .font(.custom("SpaceMono-Regular", size: 18))
                                .foregroundColor(currentCat == category ? Color.white : Color.white.opacity(0.4))
                        }
                        .frame(height: 50)
                        .overlay(
                            Rectangle()
                                .fill(currentCat == category ? Color.white : Color.white.opacity(0.4))
                                .frame(height: 3)
                                .padding(.top, 50),
                            alignment: Alignment.bottom
                        )
                        .buttonStyle(PlainButtonStyle())
                        .disabled(currentCat == category)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 0)
            .onChange(of: currentCat) {
                withAnimation {
                    proxy.scrollTo(currentCat, anchor: .center)
                }
            }
        }
    }
    
    func updateIndex(category: String){
        switch category {
        case "SEARCH":
            currentIndex = 0
        case "FICTION":
            currentIndex = 1
        case "NON-FICTION":
            currentIndex = 2
        case "BIOGRAPHY":
            currentIndex = 3
        case "SCIENCE":
            currentIndex = 4
        case "HISTORY":
            currentIndex = 5
        case "FANTASY":
            currentIndex = 6
        case "MYSTERY":
            currentIndex = 7
        case "ROMANCE":
            currentIndex = 8
        case "THRILLER":
            currentIndex = 9
        case "SELF-HELP":
            currentIndex = 10
        default:
            currentIndex = 0
        }
    }
}
