import 'package:cashflow/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController name = TextEditingController();
  late TextEditingController number = TextEditingController();

  final User? _user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 100,
            horizontal: 200,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      label: Text("Full Name"),
                      prefixIcon: Icon(Icons.person_outline_rounded)),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                TextFormField(
                  controller: number,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      label: Text("Phone No"), prefixIcon: Icon(Icons.numbers)),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Pro")),
                            );

                            await _user?.updateDisplayName(name.text);
                            await users
                                .doc(_user!.uid)
                                .set({
                                  'full_name': name.text, // John Doe
                                  'phone': number.text, // Stokes and Sons
                                  'email': _user!.email
                                })
                                .then((value) {})
                                .catchError((error) {});

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          }
                        },
                        child: Text("Signup".toUpperCase()),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
