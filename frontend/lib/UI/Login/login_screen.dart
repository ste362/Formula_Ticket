import 'package:email_validator/email_validator.dart';
import 'package:formula_ticket_flutter/UI/Login/register_screen.dart';
import '../../../../../../Downloads/venezia_marea/lib/screens/components/errorDialog.dart';
import 'package:formula_ticket_flutter/model/Model.dart';
import 'package:flutter/material.dart';

import '../../model/support/LogInResult.dart';
import '../../model/support/utils.dart';
import '../pages/dashboard/dashboard_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key,  this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sign in',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) => EmailValidator.validate(value)
                        ? null
                        : "Please enter a valid email",


                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon  : const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //print(_emailController.text+" "+_passwordController.text);
                        Model.sharedInstance.logIn(_emailController.text, _passwordController.text).then((result) {
                          //print(result);
                          switch (result){
                            case LogInResult.logged:
                              Utils.IS_LOGGED=true;
                              Model.sharedInstance.getUser().then((user){
                                //print(user);
                                Utils.user=user;
                              });
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DashboardScreen(index: 0)),
                                    (route) => false,
                              );

                              break;

                            case LogInResult.error_wrong_credentials:
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorDialog(error: "Wrong credentials");
                                  });
                              break;

                            default:
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorDialog(error: "Unknown error");
                                  });
                              break;

                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not registered yet?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterPage(title: 'Register UI'),
                            ),
                          );
                        },
                        child: const Text('Create an account'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
