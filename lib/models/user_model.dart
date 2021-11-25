import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  User({
    this.id = 0,
    required this.name,
    required this.password,
    required this.email,
    required this.imagePath,
  });

  int id;

  String name;
  String password;
  String email;
  String imagePath;
}
