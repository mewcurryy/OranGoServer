import Fluent
import Vapor

final class RetailGrade: Model, Content, @unchecked Sendable {
    static let schema = "retail_grade"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @Field(key: "retail_name")
    var retailName: String

    @Timestamp(key: "dibuat_pada", on: .create)
    var dibuatPada: Date?

    @Field(key: "aktif")
    var aktif: Bool

    @OptionalField(key: "diameter_min")
    var diameterMin: Double?

    @OptionalField(key: "diameter_maks")
    var diameterMaks: Double?

    @OptionalField(key: "berat_min")
    var beratMin: Double?

    @OptionalField(key: "berat_maks")
    var beratMaks: Double?

    @OptionalField(key: "warna_oranye")
    var warnaOranye: Double?

    init() {}

    init(id: Int? = nil, retailName: String, aktif: Bool = false,
         diameterMin: Double? = nil, diameterMaks: Double? = nil,
         beratMin: Double? = nil, beratMaks: Double? = nil, warnaOranye: Double? = nil) {
        self.id = id
        self.retailName = retailName
        self.aktif = aktif
        self.diameterMin = diameterMin
        self.diameterMaks = diameterMaks
        self.beratMin = beratMin
        self.beratMaks = beratMaks
        self.warnaOranye = warnaOranye
    }
}
