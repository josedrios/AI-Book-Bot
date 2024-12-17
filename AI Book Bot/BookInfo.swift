import SwiftUI

struct BookInfo: View {
    let category: String
    let title: String
    let isbn: String
    let pages: Int
    let authors: [String]
    let summary: String
    
    var body: some View {
        ScrollView{
            VStack(spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    Text("\(title.isEmpty ? "{ TITLE }" : title)")
                        .foregroundColor(Color.white)
                        .font(.custom("SpaceMono-Regular", size: 30))
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                        .padding(.top, 0)
                        .multilineTextAlignment(.center)
                    Text("By: \(authors.isEmpty ? "{ HUMAN }" : authors.joined(separator: ", "))")
                        .foregroundColor(Color.gray)
                        .font(.custom("SpaceMono-Regular", size: 18))
                        .multilineTextAlignment(.center)
                    if !isbn.isEmpty {
                        AsyncImage(url: URL(string: "https://covers.openlibrary.org/b/isbn/\(isbn)-M.jpg")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Text("Image not available")
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(height: 205)
                        .padding(.vertical, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("ISBN: ")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 20))
                                .padding(.leading)
                                .padding(.vertical, 10)
                            Spacer()
                            Text("\(isbn.isEmpty ? "{ ID }" : isbn)")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 20))
                                .padding(.trailing)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                        
                        HStack {
                            Text("Pages: ")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 20))
                                .padding(.leading)
                                .padding(.vertical, 10)
                            Spacer()
                            Text("\(pages == 0 ? "{ NUMBER }" : "\(pages)")")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 20))
                                .padding(.trailing)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                        
                        VStack {
                            Text("AI Summary")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 20))
                                .padding(.top, 10)
                            Spacer()
                            Text("\(summary == "" ? "{ AI WISDOM }" : "\(summary)")")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size: 16))
                                .padding(.bottom, 15)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
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
