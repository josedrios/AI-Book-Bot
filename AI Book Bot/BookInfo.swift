import SwiftUI

struct BookInfo: View {
    let category: String
    @Binding var currentIndex: Int
    let titleArray: [String]
    let isbnArray: [String]
    let pagesArray: [Int]
    let authorsArray: [String]
    let summaryArray: [String]
    var fetchISBN: (Int) -> Void
    
    var body: some View {
        ScrollView{
            if category != "SEARCH" {
                VStack{
                    Button(action: {
                        print("Generating new \(category) suggestion")
                        fetchISBN(currentIndex)
                    }){
                        Text("Generate Suggestion")
                            .font(.custom("SpaceMono-Regular", size: 20))
                            .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(6)
                }
                .padding(.horizontal, 20)
            }
            VStack(spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    Text("\(titleArray[currentIndex].isEmpty ? "{ TITLE }" : titleArray[currentIndex])")
                        .foregroundColor(Color.white)
                        .font(.custom("SpaceMono-Regular", size: 30))
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                        .padding(.top, 0)
                        .multilineTextAlignment(.center)
                    Text("By: \(authorsArray[currentIndex].isEmpty ? "{ HUMAN }" : authorsArray[currentIndex])")
                        .foregroundColor(Color.gray)
                        .font(.custom("SpaceMono-Regular", size: 18))
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("ISBN: ")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 20))
                                .padding(.leading)
                                .padding(.vertical, 10)
                            Spacer()
                            Text("\(isbnArray[currentIndex].isEmpty ? "{ ID }" : isbnArray[currentIndex])")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 20))
                                .padding(.trailing)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(6)
                        
                        HStack {
                            Text("Pages: ")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 20))
                                .padding(.leading)
                                .padding(.vertical, 10)
                            Spacer()
                            Text("\(pagesArray[currentIndex] == 0 ? "{ NUMBER }" : "\(pagesArray[currentIndex])")")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 20))
                                .padding(.trailing)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(6)
                        
                        VStack {
                            Text("AI Summary")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 20))
                                .padding(.top, 10)
                            Spacer()
                            Text("\(summaryArray[currentIndex] == "" ? "{ AI WISDOM }" : "\(summaryArray[currentIndex])")")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 16))
                                .padding(.bottom, 15)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(6)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.top)
                    .padding(.bottom, 20)
                }
                .ignoresSafeArea(edges: .all)
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 15)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.leading)
            .cornerRadius(5)
        }
        .ignoresSafeArea(edges: .bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tag(category)
        .padding(0)
    }
}
