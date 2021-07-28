import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class JwtGenerator {
  // Create a json web token

  String getClientJwt(ClassModel classroom, UserDetail user) {
    final clientJwt = JWT({
      "context": {
        "user": {"avatar": "${user.imageUrl}", "name": "${user.name}", "email": "${user.email}"},
        
      },
      "moderator": false,
      "aud": "client",
      "iss": "sortit",
      "sub": "meet.getsortit.com",
      "room": "${classroom.id}"
    });
    return clientJwt.sign(SecretKey('ZRlZwh2aLTFFZXkWUO'));
  }

// Sign it (default with HS256 algorithm)

}
