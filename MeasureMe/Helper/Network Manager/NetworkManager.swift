//
//  NetworkManager.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 16/02/24.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    private let aiBaseURL = "http://192.168.1.103:8000"
    private let authenticationBaseURL = "https://measureme.mutijayasejahtera.com"
    private let cacheImage = NSCache<NSString, UIImage>()
    
    enum EndPoint {
        case signIn
        case signUp
        case processImage
        case getImage
        case measureResult
        
        var url: String {
            switch self {
            case .signIn:
                "/login_user.php"
            case .signUp:
                "/register_user.php"
            case .processImage:
                "/process_images"
            case .getImage:
                "/get_images/?file_path="
            case .measureResult:
                "/measure_result"
            }
        }
    }
    
    func makeSignInRequest(email: String, password: String, completed: @escaping (User?) -> Void) {
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "email", value: email),
                                            URLQueryItem(name: "password", value: password)]
        
        let urlString = authenticationBaseURL + EndPoint.signIn.url
        guard let url = URL(string: urlString) else { return completed(nil) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error  {
                print(error.localizedDescription)
            }
            
            guard let data else {
                print("No response data, server is unavailable right now. Please try again later")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Unknown response")
                return
            }
            
            print("Status Code: \(httpResponse.statusCode)")
            
            print(data)
            
            do {
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(User.self, from: data)
                print("Login response: \(loginResponse)")

                completed(loginResponse)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                completed(nil)
                return
            }
            
        }
        task.resume()
    }
    
    func makeSignUpRequest(name: String, email: String, password: String, completed: @escaping (RegisterResponse?) -> Void) {
        var requestBodyComponents = URLComponents()
    
        requestBodyComponents.queryItems = [URLQueryItem(name: "name", value: name),
                                            URLQueryItem(name: "email", value: email),
                                            URLQueryItem(name: "password", value: password)
        ]
        
        
        let urlString = authenticationBaseURL + EndPoint.signUp.url
        guard let url = URL(string: urlString) else { return completed(nil) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        guard let stringData = requestBodyComponents.query else { return }
        
        print(stringData)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error  {
                print(error.localizedDescription)
            }
            
            guard let data else {
                print("No response data, server is unavailable right now. Please try again later")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Unknown response")
                return
            }
            
            print("Status Code: \(httpResponse.statusCode)")
            
            do {
                let decoder = JSONDecoder()
#warning("I suggest to receive only the status code of the event, because we don't use any data from this response")
                let registerResponse = try decoder.decode(RegisterResponse.self, from: data)
                completed(registerResponse)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                completed(nil)
                return
            }
            
        }
        task.resume()
    }
    
    func uploadAdjustedBodylandmark(front: Front, side: Side, height: Int, gender: String, clothingType: String, completed: @escaping (MeasurementResultResponse?) -> Void) {
        
        let adjustedBodyLandmark: AdjustedBodyLandmarkResponse = AdjustedBodyLandmarkResponse(actualHeight: height,
                                                                                              gender: gender,
                                                                                              clothingType: clothingType,
                                                                                              adjustedKeypoints: AdjustedBodyLandmarkResponse.AdjustedKeypoints(front: front, side: side))
        
        let data = try? JSONEncoder().encode(adjustedBodyLandmark)

        let measureResultString = aiBaseURL + EndPoint.measureResult.url
        print(String(data: data!, encoding: .utf8)!)
        guard let measureResultURL = URL(string: measureResultString) else { return }
        var request = URLRequest(url: measureResultURL)
        request.httpMethod = "POST"
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error  {
                print(error.localizedDescription)
            }
            
            guard let data else {
                print("No response data, server is unavailable right now. Please try again later")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Unknown response")
                return
            }
            
            print("Status Code of uploadedAdjustedBodyLandmark: \(httpResponse.statusCode)")

            do {
                let decoder = JSONDecoder()
                let measurementResultResponse = try decoder.decode(MeasurementResultResponse.self, from: data)
                completed(measurementResultResponse)
                print(measurementResultResponse)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                completed(nil)
                return
            }
            
        }
        task.resume()
    }


    func upload(_ frontImage: UIImage, and sideImage: UIImage, completed: @escaping (BodyLandmarkResponse?, HTTPURLResponse) -> Void) {
        guard let processImageURLRequest = createUploadImagesURLRequest(for: frontImage, sideImage: sideImage) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: processImageURLRequest) { data, response, _ in
            var bodyLandmarkResponse: BodyLandmarkResponse?
            
            guard let data else {
                print("No response data, server is unavailable right now. Please try again later")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Unknown response")
                return
            }
            
            print("Status Code: \(httpResponse.statusCode)")
            
            do {
                let decoder = JSONDecoder()
                bodyLandmarkResponse = try decoder.decode(BodyLandmarkResponse.self, from: data)
                completed(bodyLandmarkResponse, httpResponse)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                completed(nil, httpResponse)
                return
            }
        }
        task.resume()
    }
    
    
    func loadBlurredImages(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cacheImage.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        let getImageURLString = aiBaseURL + EndPoint.getImage.url + urlString
        guard let getImageURL = URL(string: getImageURLString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: getImageURL)) { data, _, error in
            if let error  {
                print(error.localizedDescription)
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cacheImage.setObject(image, forKey: cacheKey)
            completed(image)
            return
        }
        
        task.resume()
    }
    
    private func createUploadImagesURLRequest(for frontImage: UIImage, sideImage: UIImage) -> URLRequest? {
        var multipart = MultipartRequest()
        
        multipart.addFileData(key: "front_image",
                              fileName: "front_image.jpeg",
                              fileMimeType: "image/jpeg",
                              fileData: frontImage.jpegData(compressionQuality: 0.8)!)
        
        multipart.addFileData(key: "side_image",
                              fileName: "side_image.jpeg",
                              fileMimeType: "image/jpeg",
                              fileData: sideImage.jpegData(compressionQuality: 0.8)!)
        
        let processImageString = aiBaseURL + EndPoint.processImage.url
        guard let processImageURL = URL(string: processImageString) else { return nil }
        var processImageURLRequest = URLRequest(url: processImageURL)
        processImageURLRequest.httpMethod = "POST"
        processImageURLRequest.setValue(multipart.httpContentTypeHeaderValue, forHTTPHeaderField: "Content-Type")
        processImageURLRequest.httpBody = multipart.httpBody
        
        return processImageURLRequest
    }
}
