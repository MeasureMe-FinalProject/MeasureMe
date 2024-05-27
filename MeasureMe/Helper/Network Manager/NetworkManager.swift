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
    
    private let aiBaseURL = "http://103.186.31.38:55678"
    private let authenticationBaseURL = "https://measureme.mutijayasejahtera.com"
    private let cacheImage = NSCache<NSString, UIImage>()
    
    enum EndPoint {
        case signIn
        case signUp
        case processImage
        case getImage
        case measureResult
        case recentMeasurementResults
        case saveMeasurementResult
        case deleteMeasurementResult
        case editProfile
        case changePassword
        case forgotPassword
        
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
            case .recentMeasurementResults:
                "/get_all_measurement.php"
            case .saveMeasurementResult:
                "/save_measure.php"
            case .deleteMeasurementResult:
                "/delete_measure.php"
            case .editProfile:
                "/edit_profile.php"
            case .changePassword:
                "/change_password.php"
            case .forgotPassword:
                "/forgot_password.php"
            }
        }
    }
}

// MARK: - NetworkManager to Backend

extension NetworkManager {
    func editProfile(of user: User, completed: @escaping(String?) -> Void) {
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "email", value: user.email),
                                            URLQueryItem(name: "user_name", value: user.name),
                                            URLQueryItem(name: "birthday", value: " "),
                                            URLQueryItem(name: "gender", value: " "),
                                            URLQueryItem(name: "height", value: " ")]
        
        let urlString = authenticationBaseURL + EndPoint.editProfile.url
        guard let url = URL(string: urlString) else { return }
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
                        
            do {
                let decoder = JSONDecoder()
                let forgotPasswordResponse = try decoder.decode(StatusResponse.self, from: data)
                completed(forgotPasswordResponse.message)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                completed(nil)
                return
            }
        }
        task.resume()
        
    }
    
    func getPassword(for email: String, completed: @escaping(String?) -> Void) {
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "email", value: email)]
        
        let urlString = authenticationBaseURL + EndPoint.forgotPassword.url
        guard let url = URL(string: urlString) else { return }
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
                        
            do {
                let decoder = JSONDecoder()
                let forgotPasswordResponse = try decoder.decode(ForgotPasswordResponse.self, from: data)
                completed(forgotPasswordResponse.password)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                completed(nil)
                return
            }
        }
        task.resume()
    }
    
    func changePassword(for email: String, oldPassword: String, newPassword: String, completed: @escaping(HTTPURLResponse) -> Void) {
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "email", value: email),
                                            URLQueryItem(name: "old_password", value: oldPassword),
                                            URLQueryItem(name: "new_password", value: newPassword)]
        
        let urlString = authenticationBaseURL + EndPoint.changePassword.url
        guard let url = URL(string: urlString) else { return }
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
                        
            do {
                let decoder = JSONDecoder()
                let statusResponse = try decoder.decode(StatusResponse.self, from: data)
                completed(httpResponse)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                completed(httpResponse)
                return
            }
        }
        task.resume()
    }
    
    func deleteMeasurementResult(of user: User, with id: Int, completed: @escaping (HTTPURLResponse) -> Void) {
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "id_user", value: String(user.id)),
                                            URLQueryItem(name: "id_measurement", value: String(id))]
        
        let urlString = authenticationBaseURL + EndPoint.deleteMeasurementResult.url
        guard let url = URL(string: urlString) else { return }
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
                        
            do {
                let decoder = JSONDecoder()
                let _ = try decoder.decode(StatusResponse.self, from: data)
                completed(httpResponse)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                completed(httpResponse)
                return
            }
        }
        task.resume()
    }
    
    func saveMeasurementResult(_ measurementResult: MeasurementResult) {
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "id_user", value: String(measurementResult.idUser)),
                                            URLQueryItem(name: "height", value: String(measurementResult.height)),
                                            URLQueryItem(name: "date", value: measurementResult.date),
                                            URLQueryItem(name: "type_clothes", value: measurementResult.clothingType),
                                            URLQueryItem(name: "gender", value: measurementResult.gender),
                                            URLQueryItem(name: "size_recommendation", value: measurementResult.sizeRecommendation),
                                            URLQueryItem(name: "bust_circumference", value: String(measurementResult.bustCircumference)),
                                            URLQueryItem(name: "waist_circumference", value: String(measurementResult.waistCircumference)),
                                            URLQueryItem(name: "hip_circumference", value: String(measurementResult.hipCircumference)),
                                            URLQueryItem(name: "shoulder_width", value: String(measurementResult.shoulderWidth)),
                                            URLQueryItem(name: "sleeve_length", value: String(measurementResult.sleeveLength)),
                                            URLQueryItem(name: "pants_length", value: String(measurementResult.pantsLength))]
        
        let urlString = authenticationBaseURL + EndPoint.saveMeasurementResult.url
        guard let url = URL(string: urlString) else { return }
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
                        
            do {
                let decoder = JSONDecoder()
                let statusResponse = try decoder.decode(StatusResponse.self, from: data)
                print(statusResponse.message)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                return
            }
        }
        task.resume()
    }
    
    func getRecentMeasurementResults(of user: User, completed: @escaping ([MeasurementResult]?, HTTPURLResponse) -> Void) {
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "id_user", value: String(user.id))]
        
        let urlString = authenticationBaseURL + EndPoint.recentMeasurementResults.url
        guard let url = URL(string: urlString) else { return }
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
                        
            do {
                let decoder = JSONDecoder()
                let recentMeasurementResultResponse = try decoder.decode(MeasurementResultResponse.self, from: data)
                let measurementResults = recentMeasurementResultResponse.measurementResults
                completed(measurementResults, httpResponse)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                completed(nil, httpResponse)
                return
            }
        }
        task.resume()
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
        
        print(String(describing: String(data: request.httpBody!, encoding: .utf8)))
        
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
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                print("Login response: \(loginResponse)")
                
                let user = User(id: loginResponse.user.id,
                                name: loginResponse.user.name,
                                email: loginResponse.user.email,
                                password: loginResponse.user.password)

                completed(user)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                completed(nil)
                return
            }
            
        }
        task.resume()
    }
    
    func makeSignUpRequest(name: String, email: String, password: String, completed: @escaping (StatusResponse?, HTTPURLResponse?) -> Void) {
        var requestBodyComponents = URLComponents()
    
        requestBodyComponents.queryItems = [URLQueryItem(name: "name", value: name),
                                            URLQueryItem(name: "email", value: email),
                                            URLQueryItem(name: "password", value: password)
        ]
        
        
        let urlString = authenticationBaseURL + EndPoint.signUp.url
        guard let url = URL(string: urlString) else { return completed(nil, nil) }
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
                let registerResponse = try decoder.decode(StatusResponse.self, from: data)
                completed(registerResponse, httpResponse)
                return
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                completed(nil, httpResponse)
                return
            }
            
        }
        task.resume()
    }
}


// MARK: - Network Manager to AI

extension NetworkManager {
    func uploadAdjustedBodylandmark(of user: User, front: Front, side: Side, height: Int, gender: GenderType, clothingType: ClothingType, completed: @escaping (MeasurementResult?) -> Void) {
        
        let adjustedBodyLandmark: AdjustedBodyLandmarkResponse = AdjustedBodyLandmarkResponse(actualHeight: height,
                                                                                              gender: gender.codeName,
                                                                                              clothingType: clothingType.codeName,
                                                                                              adjustedKeypoints: AdjustedBodyLandmarkResponse.AdjustedKeypoints(
                                                                                                front: front,
                                                                                                side: side))
        
        print("\n\n\nADJUSTED KEYPOINTS:\n")
        print("\(adjustedBodyLandmark.adjustedKeypoints.front)")
        
        let data = try? JSONEncoder().encode(adjustedBodyLandmark)

        let measureResultString = aiBaseURL + EndPoint.measureResult.url
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
            
            print(String(data: data, encoding: .utf8)!)

            do {
                let decoder = JSONDecoder()
                let measurementResultResponse = try decoder.decode(RecentMeasurementResultResponse.self, from: data)
                
                let idUser = user.id
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy, HH:mm"
                let currentDate = dateFormatter.string(from: Date())
                let clothingName = clothingType.name
                let sizeRecommendation = measurementResultResponse.sizeRecommendation
                let height = measurementResultResponse.measurementResult.height
                let waist = measurementResultResponse.measurementResult.waistCircumference
                let bust = measurementResultResponse.measurementResult.bustCircumference
                let arm = measurementResultResponse.measurementResult.sleeveLength
                let shoulder = measurementResultResponse.measurementResult.shoulderWidth
                let hip = measurementResultResponse.measurementResult.hipCircumference
                let inseam = measurementResultResponse.measurementResult.pantsLength
                
                let measurementResult = MeasurementResult(id: nil,
                                                          idUser: idUser,
                                                          date: currentDate,
                                                          clothingType: clothingName,
                                                          gender: gender.name,
                                                          sizeRecommendation: sizeRecommendation,
                                                          height: height,
                                                          bustCircumference: bust,
                                                          waistCircumference: waist,
                                                          hipCircumference: hip,
                                                          shoulderWidth: shoulder,
                                                          sleeveLength: arm,
                                                          pantsLength: inseam)
                
                completed(measurementResult)
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
//                print("\n\n\nORIGINAL KEYPOINTS:\n")
//                print(String(describing:bodyLandmarkResponse?.front))
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
                              fileData: frontImage.jpegData(compressionQuality: 1)!)
        
        multipart.addFileData(key: "side_image",
                              fileName: "side_image.jpeg",
                              fileMimeType: "image/jpeg",
                              fileData: sideImage.jpegData(compressionQuality: 1)!)
        
        let processImageString = aiBaseURL + EndPoint.processImage.url
        guard let processImageURL = URL(string: processImageString) else { return nil }
        var processImageURLRequest = URLRequest(url: processImageURL)
        processImageURLRequest.httpMethod = "POST"
        processImageURLRequest.setValue(multipart.httpContentTypeHeaderValue, forHTTPHeaderField: "Content-Type")
        processImageURLRequest.httpBody = multipart.httpBody
        
        return processImageURLRequest
    }
}

