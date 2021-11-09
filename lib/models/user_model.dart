
import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  User({
    required this.name,
    required this.password,
    required this.email,
    required this.imagePath,
  });

  String name;
  String password;
  String email;
  String imagePath;
}
