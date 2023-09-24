class StudentModal {
  int id;
  String name;
  int age;
  String course;

  StudentModal(
    this.id,
    this.name,
    this.age,
    this.course,
  );

  factory StudentModal.fromMap({required Map data}) {
    return StudentModal(
      data['id'],
      data['name'],
      data['age'],
      data['course'],
    );
  }
}
