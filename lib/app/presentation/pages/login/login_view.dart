import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/presentation/styles/theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoginFormView(),
      ),
    );
  }
}

class LoginFormView extends StatefulWidget {
  const LoginFormView({super.key});

  @override
  State<LoginFormView> createState() => _LoginFormViewState();
}

class _LoginFormViewState extends State<LoginFormView> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: AbsorbPointer(
          absorbing: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: '',
                    focusNode: _emailFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: 'Email is required',
                      labelStyle: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelMedium?.fontSize,
                        fontFamily: 'medium',
                      ),
                      errorStyle: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelMedium?.fontSize,
                        fontFamily: 'medium',
                      ),
                    ),
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelLarge?.fontSize,
                      fontFamily: 'medium',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {});
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: '',
                    focusNode: _passwordFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: 'Password is required',
                      labelStyle: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelMedium?.fontSize,
                        fontFamily: 'medium',
                      ),
                      errorStyle: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelMedium?.fontSize,
                        fontFamily: 'medium',
                      ),
                    ),
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelLarge?.fontSize,
                      fontFamily: 'medium',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (value) {
                      setState(() {});
                    },
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
