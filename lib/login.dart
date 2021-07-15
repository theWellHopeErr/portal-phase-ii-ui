import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:portal_phase_ii_ui/main.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.engineering,
          size: 100.0,
        ),
        Text(
          'Maintenance Portal',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Calistoga',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        LoginForm(),
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String password;
  late String error = '';
  late bool loading = false;

  Future<String> logIn() async {
    late Map<String, String> body = {"name": username, "job": password};
    loading = true;
    var response = await http.post(
      Uri.parse('https://reqres.in/api/users'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      late Map<String, dynamic> responseBody = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logged In!"),
        ),
      );

      setState(() {
        loading = false;
      });
      return '''{
                "token": "Fly, You Fools!", 
                "plant": "${responseBody['id']}", 
                "plantGroup": "${responseBody['createdAt']}"
                }''';
    } else {
      setState(() {
        loading = false;
        error = 'Incorrect Credentials';
      });
      throw Exception('Unauthorized');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Username';
                  }
                  username = value;
                  return null;
                },
                decoration: new InputDecoration(
                  hintText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Password';
                  }
                  password = value;
                  return null;
                },
                decoration: new InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Visibility(
                      visible: error.isNotEmpty,
                      child: Text(error),
                    ),
                    Visibility(
                      visible: loading,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    Visibility(
                      visible: !loading,
                      child: MaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            logIn().then((value) async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('userCreds', value.toString());

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()),
                              );
                            });
                          }
                        },
                        child: Text('Submit'),
                        height: 50,
                        minWidth: double.infinity,
                        color: Colors.white,
                        textColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
