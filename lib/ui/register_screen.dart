import 'package:flutter/material.dart';
import 'package:flutter_pertemuan7/services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();

final _formKey = GlobalKey<FormState>();

String? _nameError;
String? _emailError;
String? _passwordError;

AuthServices _authServices = AuthServices();

void _register(context) async {
  if (_formKey.currentState!.validate()){
    if (_passwordController.text == _retypePasswordController.text) {
      try {
        final response = await _authServices.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text
        );

        if (response["status"]) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response["message"]))
        );
        //coding navigasi ke home
        Navigator.pushReplacementNamed(context, '/home');
        } else {
          print(response["error"]);
          //code untuk pesan kesalahan
          setState(() {
          _nameError = response["error"]["name"]?[0];
          _emailError = response["error"]["email"]?[0];
          _passwordError = response["error"]["password"]?[0];
          });
        }

      } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password do not match"))
      );
        
        print(e);
        
      }

      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password do not match"))
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register"),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  errorText: _nameError,
                ),
                validator: (value) {
                  if (value==null||value.isEmpty){
                    return 'please enter your name';
                  }
                  return null;
                },
              ),
          
              //email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: _emailError,
                ),
                validator: (value) {
                  if (value==null||value.isEmpty){
                    return 'please enter your email';
                  }
                  return null;
                },
              ),
          
              //Password
                TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _passwordError,
                ),
                validator: (value) {
                  if (value==null||value.isEmpty){
                    return 'please enter your password';
                  }
                  return null;
                },
              ),
          
              //RetypePassword
                TextFormField(
                controller: _retypePasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "RetypePassword",
                  errorText: _passwordError,
                ),
                validator: (value) {
                  if (value==null||value.isEmpty){
                    return 'please enter your password';
                  }
                  return null;
                },
              ),
              ElevatedButton(onPressed: (){
                _register(context);
              }, child: Text("Register"))
            ],),
        ),
      ),
    );
  }
}