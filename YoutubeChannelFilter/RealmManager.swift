//
//  RealmManager.swift
//  YoutubeChannelFilter
//
//  Created by james on 4/17/24.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()

    private let db: Realm

    private init() {
        do {
            self.db = try Realm()
        }catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func load<T: Object>(_ object: T.Type) -> Results<T> {
        return db.objects(object)
    }
    
    func load<T: Object>(_ object: T.Type,
                         sortKey: String, ascending: Bool) -> Results<T> {
        return db.objects(object).sorted(byKeyPath: sortKey, ascending: ascending)
    }
    
    func load<T: Object>(_ object: T.Type, 
                         key: String,
                         value: String) -> Results<T> {
        return db.objects(object).filter(NSPredicate(format: "\(key) = %@", value))
    }
    
    func add<T: Object>(_ object: T,
                        _ errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do{
            try db.write {
                db.add(object)
            }
        }catch{
            errorHandler(error)
        }
    }
    
    func write(action: () -> Void,
               _ errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        
        do{
            try db.write {
                action()
            }
        }catch{
            errorHandler(error)
        }
    }

    func delete<T: Object>(_ object: T,
                           _ errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do {
            try db.write {
                db.delete(object)
            }
        } catch let error {
            errorHandler(error)
        }
    }
    
    func deleteAll(_ errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do {
            try db.write {
                db.deleteAll()
            }
        }catch{
            errorHandler(error)
        }
    }
    
//    func getfileURL() {
//        print("file path:", database.configuration.fileURL!)
//    }
    
}
