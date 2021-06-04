import Foundation

class ServerProvider {
    
    static let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    static func formURL(method: String) -> String {
        let urlString = "http://5.189.120.21:7143/v1/printlayout/\(method)"
        return urlString
    }
    
    static func fetchNoteData(method: String, requestMethod: String, sendingData: Data?, recievedServerData: @escaping (_ recievedData: Any?, _ error: Error?) -> Void) {
        guard let url = URL(string: formURL(method: method)) else { return }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("42", forHTTPHeaderField: "UJ-Account-Id")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = requestMethod
        urlRequest.httpBody = sendingData
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    recievedServerData(nil, error)
                }
                return
            }
            
            if let recievedData = data {
                let (resultObject, error) = decodeJSON(data: recievedData)
                DispatchQueue.main.async {
                    recievedServerData(resultObject, error)
                    print("Server responce body: \(String(data: data!, encoding: .utf8))")
                }
            }
        }.resume()
    }
    
    static func decodeJSON(data: Data) -> (Any?, Error?) {
        do {
            let serializedData = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
            if let dictionary = serializedData as? [String: Any] {
                if let corruptedResult = dictionary["error"] {
                    print(corruptedResult)
                    return (nil, NSError(domain: "com.note.error", code: 1, userInfo: ["description" : corruptedResult]))
                }
                if let result = dictionary["data"] {
                    return (result, nil)
                }
            }
        } catch let error {
            print(error)
        }
        return (nil, nil)
    }
}
