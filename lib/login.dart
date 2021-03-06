import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:portal_phase_ii_ui/helpers.dart';
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
    late Map<String, String> body = {
      "username": username.toUpperCase(),
      "password": password,
      "role": "maintenance"
    };
    loading = true;
    var response = await http.post(
      Uri.parse('http://$hostAddress:3000/login'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      late Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['accessToken'].isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Logged In!"),
          ),
        );

        setState(() {
          loading = false;
        });
        return '''{
                "token": "${responseBody['accessToken']}", 
                "plant": "${responseBody['username']}", 
                "planGroup": "${responseBody['plangrp']}"
                }''';
      } else {
        setState(() {
          loading = false;
          error = responseBody['message'];
        });
        throw Exception('Unauthorized');
      }
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Plant No.';
                  }
                  username = value;
                  return null;
                },
                decoration: new InputDecoration(
                  labelText: "Plant",
                  labelStyle: new TextStyle(
                    color: Colors.grey[300],
                  ),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Password';
                  }
                  password = value;
                  return null;
                },
                decoration: new InputDecoration(
                  labelText: "Password",
                  labelStyle: new TextStyle(
                    color: Colors.grey[300],
                  ),
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
                      visible: error.isNotEmpty || loading,
                      child: SizedBox(
                        height: 10,
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
