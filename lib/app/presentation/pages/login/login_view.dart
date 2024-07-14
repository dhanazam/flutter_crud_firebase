import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_firebase/app/presentation/pages/login/bloc/login_bloc.dart';
import 'package:flutter_crud_firebase/app/presentation/styles/styles.dart';
import 'package:flutter_crud_firebase/app/presentation/styles/theme.dart';
import 'package:flutter_crud_firebase/app/router/app_route_config.dart';
import 'package:formz/formz.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const LoginFormView(),
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
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = context.select((LoginBloc bloc) => bloc.state.isValid);
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          kSnackBarError(context, state.toastMessage.toString());
        } else if (state.status.isSuccess) {
          Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
        }
      },
      builder: (context, state) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
          ),
        );
      },
    );
  }
}
