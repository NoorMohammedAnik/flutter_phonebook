class Contact {
  String? contactId;
  String? contactName;
  String? contactPhone;
  String? contactEmail;
  String? userId;

  Contact(
      {
        this.contactId,
        this.contactName,
        this.contactPhone,
        this.contactEmail,
        this.userId
      });

  Contact.fromJson(Map<String, dynamic> json) {
    contactId = json['contact_id'];
    contactName = json['contact_name'];
    contactPhone = json['contact_phone'];
    contactEmail = json['contact_email'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contact_id'] = contactId;
    data['contact_name'] = contactName;
    data['contact_phone'] = contactPhone;
    data['contact_email'] = contactEmail;
    data['user_id'] = userId;
    return data;
  }
}