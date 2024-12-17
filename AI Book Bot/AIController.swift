import SwiftUI
import OpenAI

class AIController: ObservableObject {
    @Published var message: String = ""
    @Published var botReply: String = ""
    let openAI: OpenAI
    
    init(apiToken: String){
        self.openAI = OpenAI(apiToken: apiToken)
    }
    
    func sendNewMessage(content: String, completion: @escaping (String?) -> Void) {
        message = content
        getBotReply { reply in
            DispatchQueue.main.async {
                self.botReply = reply ?? "No reply"
                completion(reply)
            }
        }
    }

    private func getBotReply(completion: @escaping (String?) -> Void) {
        guard let userMessage = ChatQuery.ChatCompletionMessageParam(role: .user, content: message) else {
            print("Failed to create user message")
            return
        }

        let query = ChatQuery(
            messages: [userMessage],
            model: .gpt3_5Turbo
        )

        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                                completion(nil)
                                return
                            }
                            if let content = choice.message.content {
                                switch content {
                                case .string(let reply):
                                    completion(reply)
                                default:
                                    print("Unsupported content type")
                                    completion(nil)
                                }
                            } else {
                                print("Content is nil")
                                completion(nil)
                            }
            case .failure(let failure):
                print(failure)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
