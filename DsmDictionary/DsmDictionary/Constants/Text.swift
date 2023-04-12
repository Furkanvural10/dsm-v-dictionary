import Foundation

struct Text {
    static let errorTitle                = "Hata"
    static let onboardingButtonTitle     = "Başla"
    static let okeyButtonTitle           = "Tamam"
    static let errorMessage              = "Bir hata oluştu. Lütfen tekrar deneyin."
    static let segmentedControllerTitle1 = "Geçmiş"
    static let segmentedControllerTitle2 = "Favoriler"
    static let searchBarTitle            = "Ara"
    static let notFound                  = "Sonuç Bulunamadı"
    static let searchWord                = "Kelime Ara"
    static let wordLabel                 = "WORD"
    static let turkishSegmentedTitle     = "Türkçe"
    static let englishSegmentedTitle     = "English"
    static let definitionTitle           = "Açıklama"
    static let dsmDefinition             = "DSM-V"
    static let comorbid                  = "Comorbid - "

    static let invalidRedComponent       = "Invalid red component"
    static let invalidGreenComponent     = "Invalid green component"
    static let invalidBlueComponent      = "Invalid blue component"
    
    // MARK: - LastSearchWord Core Data Constant
    static let entityNameLastSearchWord               = "LastSearchWord"
    static let entityLastSearchAttributeWordName      = "word"
    static let entityLastSearchAttributeIDName        = "id"
    static let entityLastSearchAttributeCreatedAtName = "createdAt"
    
    // MARK: - FavoriteWord Core Data Constant
    static let entityNameFavWord               = "FavoriteWord"
    static let entityAttributeFavWordName      = "favWord"
    static let entityAttributeFavIDName        = "id"
    static let entityAttributeFavCreatedAtName = "createdAt"
    
    // MARK: - Segue ID
    static let toDetailWordVC   = "toDetailWordVC"
    static let toSearchPageVC   = "toSearchPageVC"
    static let toDetailSearchVC = "toDetailSearchVC"
    
    // MARK: - UserDefaultForKey
    static let finishedOnboarding = "finishedOnboarding"
    
    
    
}

