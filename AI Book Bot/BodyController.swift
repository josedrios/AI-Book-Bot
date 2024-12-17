import SwiftUI

struct BodySection: View {
    @Binding var currentCat: String
    let categories: [String]
    let title: String
    let isbn: String
    let pages: Int
    let authors: [String]
    let summary: String

    var body: some View {
        TabView(selection: $currentCat){
                ForEach(categories, id:\.self){ category in
                    if category == "SEARCH" {
                        BookInfo(
                            category: category,
                            title: title,
                            isbn: isbn,
                            pages: pages,
                            authors: authors,
                            summary: summary
                        )
                    }else{
                        CategoryTab(
                            currentCat: $currentCat,
                            category: category
                        )
                    }
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
