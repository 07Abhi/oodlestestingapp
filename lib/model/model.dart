class Address {
  String street;
  String suite;
  String city;
  String zipcode;
  Address({this.street, this.suite, this.city, this.zipcode});
}

class UserData {
  String name;
  String email;
  Address address;
  String phone;
  UserData({this.name, this.email, this.address, this.phone});
  factory UserData.getUserData(data) {
    return UserData(
        name: data['name'],
        email: data['email'],
        address: Address(
          street: data['address']['street'],
          suite: data['address']['suite'],
          city: data['address']['city'],
          zipcode: data['address']['zipcode'],
        ),
        phone: data['phone']
        );
  }
}
