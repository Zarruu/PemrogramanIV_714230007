//DIGUNAKAN UNTUK GET ALL DATA
class ContactsModel {
  final String id;
  final String namaKontak;
  final String nomorHp;

  ContactsModel({
    required this.id,
    required this.namaKontak,
    required this.nomorHp,
  });

  factory ContactsModel.fromJson(Map<String, dynamic> json) => ContactsModel(
        id: json["_id"],
        namaKontak: json["nama_kontak"],
        nomorHp: json["nomor_hp"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nama_kontak": namaKontak,
        "nomor_hp": nomorHp,
      };
}

//DIGUNAKAN UNTUK FORM INPUT
class ContactInput {
  final String namaKontak;
  final String nomorHp;

  ContactInput({
    required this.namaKontak,
    required this.nomorHp,
  });

  Map<String, dynamic> toJson() => {
        "nama_kontak": namaKontak,
        "nomor_hp": nomorHp,
      };
}

//DIGUNAKAN UNTUK RESPONSE
class ContactResponse {
  final String? insertedId;
  final String message;
  final int status;

  ContactResponse({
    this.insertedId,
    required this.message,
    required this.status,
  });

  factory ContactResponse.fromJson(Map<String, dynamic> json) =>
      ContactResponse(
        insertedId: json["inserted_id"],
        message: json["message"],
        status: json["status"],
      );
}
