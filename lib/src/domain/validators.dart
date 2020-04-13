import 'dart:async';

class Validators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if(email.contains('@')){
        sink.add(email);
      } else {
        sink.addError('Enter a valid email');
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if(password.length > 5) {
        sink.add(password);
      } else {
        sink.addError('Password must be at least 6 characters');
      }
    }
  );

  final validateUserName = StreamTransformer<String, String>.fromHandlers(
    handleData: (userName, sink) {
      if(userName.length > 0) {
        sink.add(userName);
      } else {
        sink.addError('Username must have at least 1 character');
      }
    }
  );

  final validateFirstName = StreamTransformer<String, String>.fromHandlers(
    handleData: (firstName, sink) {
      if(firstName.length > 0) {
        sink.add(firstName);
      } else {
        sink.addError('First name must have at least 1 character');
      }
    }
  );

  final validateLastName = StreamTransformer<String, String>.fromHandlers(
    handleData: (lastName, sink) {
      if(lastName.length > 0) {
        sink.add(lastName);
      } else {
        sink.addError('Last name must have at least 1 character');
      }
    }
  );
}