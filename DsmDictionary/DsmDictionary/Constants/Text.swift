//
//  Text.swift
//  DsmDictionary
//
//  Created by furkan vural on 9.04.2023.
//

import Foundation

struct Text {
    
    static let onboardingButtonTitle = "Başla"
    static let errorMessage = "Bir hata oluştu. Lütfen tekrar deneyin."
    static let segmentedControllerTitle1 = "Geçmiş"
    static let segmentedControllerTitle2 = "Favoriler"
    static let searchBarTitle = "Ara"
    static let notFound = "Sonuç Bulunamadı"
    static let searchWord = "Kelime Ara"
    
    // MARK: - LastSearchWord Core Data Constant
    static let entityNameLastSearchWord = "LastSearchWord"
    static let entityLastSearchAttributeWordName = "word"
    static let entityLastSearchAttributeIDName = "id"
    static let entityLastSearchAttributeCreatedAtName = "createdAt"
    
    // MARK: - FavoriteWord Core Data Constant
    static let entityNameFavWord = "FavoriteWord"
    static let entityAttributeFavWordName = "favWord"
    static let entityAttributeFavIDName = "id"
    static let entityAttributeFavCreatedAtName = "createdAt"
    
    
    
}

