class PersonModal {
  String emailId;
  String name;
  String password;
  List contacts;
  List received;
  List sent;

  PersonModal(
    this.emailId,
    this.name,
    this.password,
    this.contacts,
    this.received,
    this.sent,
  );

  factory PersonModal.fromMap({required Map data}) {
    return PersonModal(
      data['emailId'],
      data['name'],
      data['password'],
      data['contacts'],
      data['received'],
      data['sent'],
    );
  }
}
