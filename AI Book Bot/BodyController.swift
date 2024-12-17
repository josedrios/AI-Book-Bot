import SwiftUI

struct BodySection: View {
    @Binding var currentCat: String
    @Binding var currentIndex: Int
    let categories: [String]
    let titleArray: [String]
    let isbnArray: [String]
    let pagesArray: [Int]
    let authorsArray: [String]
    let summaryArray: [String]

    var body: some View {
        TabView(selection: $currentCat){
                ForEach(categories, id:\.self){ category in
                    BookInfo(
                        category: category,
                        currentIndex: $currentIndex,
                        titleArray: titleArray,
                        isbnArray: isbnArray,
                        pagesArray: pagesArray,
                        authorsArray: authorsArray,
                        summaryArray: summaryArray
                    )
                }
                .padding(0)
            }
            .ignoresSafeArea(edges: .bottom)
            .padding()
            .padding(.bottom, 0)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CategoryTab: View {
    @Binding var currentCat: String
    let category: String
    var body: some View {
        ScrollView{
            Text(category)
                .foregroundColor(Color.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tag(category)
    }
}
