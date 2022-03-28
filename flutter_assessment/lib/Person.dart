class Person{

  String image;
  String firstName;
  String lastName;
  String email;


  Person(this.image, this.firstName, this.lastName, this.email);

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      json['avatar'],
    json['first_name'],
    json['last_name'],
    json['email'],
  );
  }


}