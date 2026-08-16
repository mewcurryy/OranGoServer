//
//  Machine.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent
import Vapor

final class Machine: Model, Content, @unchecked Sendable {
    static let schema = "machine"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @Field(key: "machine_name")
    var machineName: String

    @OptionalField(key: "lokasi")
    var lokasi: String?

    @Field(key: "status_koneksi")
    var statusKoneksi: String   // "Terhubung" / "Sinyal Rendah" / "Terputus"

    @OptionalField(key: "terakhir_terlihat")
    var terakhirTerlihat: Date?

    @Parent(key: "threshold_aktif_id")
    var thresholdAktif: RetailGrade

    init() {}

    init(id: Int? = nil, machineName: String, lokasi: String? = nil,
         statusKoneksi: String, terakhirTerlihat: Date? = nil,
         thresholdAktifID: RetailGrade.IDValue) {
        self.id = id
        self.machineName = machineName
        self.lokasi = lokasi
        self.statusKoneksi = statusKoneksi
        self.terakhirTerlihat = terakhirTerlihat
        self.$thresholdAktif.id = thresholdAktifID
    }
}