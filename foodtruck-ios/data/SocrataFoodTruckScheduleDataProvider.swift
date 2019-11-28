//
//  SocrataFoodTruckScheduleDataProvider.swift
//  foodtruck-ios
//
//  Created by Chris Kwok on 11/28/19.
//  Copyright © 2019 Chris Kwok. All rights reserved.
//

import Foundation
import MapKit

struct SocrataAPIResponse: Codable {
    let dayorder: String
    let location: String
    let locationdesc: String?
    let optionaltext: String?
    let applicant: String
    let latitude: String
    let longitude: String
    let starttime: String
    let endtime: String
}

enum APIError: Error {
    case invalidRequest
    case nonHTTPResponse
    case noData
    case statusCode(Int)
    case unknown(Error)
}



class SocrataFoodTruckScheduleDataProvider: FoodTruckScheduleDataProvider {
    
    private let calendar = Calendar(identifier: .gregorian)
    private let baseURLStr = "https://data.sfgov.org"
    private let path = "/resource/jjew-r69b.json"
    
    func fetch(by date: Date, completion: @escaping ((Result<[FoodTruckSchedule], Error>) -> Void)) {
        let dayorder = calendar.component(.weekdayOrdinal, from: date)
        let fmtDateStr =
            String(format: "%02d:%02d",
                   calendar.component(.hour, from: date),
                   calendar.component(.minute, from: date))
        
        let urlStr = baseURLStr + path
        let _url: URL? = {
            var urlComponents: URLComponents? = URLComponents(string: urlStr)
            urlComponents?.queryItems = [
                URLQueryItem(name: "dayorder", value: "\(dayorder)"),
                URLQueryItem(name: "$where", value: "start24 <= \"\(fmtDateStr)\" and end24 >= \"\(fmtDateStr)\"")
            ]
            return urlComponents?.url
        }()
        
        guard let url = _url else {
            completion(.failure(APIError.invalidRequest))
            return
        }
        
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                completion(.failure(APIError.unknown(err)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.nonHTTPResponse))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(APIError.statusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
             }
            
             do {
                let responses: [SocrataAPIResponse] =
                    try JSONDecoder().decode([SocrataAPIResponse].self, from: data)
                
                let schedules: [FoodTruckSchedule] =
                    responses.map { r in
                        FoodTruckSchedule(name: r.applicant,
                                          address: r.locationdesc ?? "",
                                          location: CLLocation(
                                            latitude: CLLocationDegrees(r.latitude) ?? 0.0,
                                            longitude: CLLocationDegrees(r.longitude) ?? 0.0),
                                          starttime: r.starttime,
                                          endtime: r.endtime,
                                          description: r.optionaltext ?? "")
                }
                
                completion(.success(schedules))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    
    private func toHourAndMinute(from: String) -> (hour: Int, minute: Int)? {
        let arr = from.split(separator: ":")
        guard arr.count == 2,
            let hr = Int(arr[0]), let minute = Int(arr[1]) else {
            return nil
        }
        return (hr, minute)
    }
}

