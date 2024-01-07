import 'package:file_manager/utility/theme/color_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utility/dialogs_and_snackbars/dialogs_snackBar.dart';
import '../../../../utility/global_widgets/custom_text_field.dart';
import '../../../../utility/global_widgets/elevated_button_widget.dart';
import '../../../../utility/router/app_routes.dart';
import '../../../../utility/theme/text_styles.dart';
import '../bloc/user/user_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double getWidth = MediaQuery.of(context).size.width;
    double getHeight = MediaQuery.of(context).size.height;
    final double heightBetweenFields = getHeight * 0.015;

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoggedState) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.bottomNavBarScreen, (Route<dynamic> route) => false);
        }
        if (state is UserErrorState) {
          DialogsWidgetsSnackBar.showSnackBarFromStatus(
              context: context,
              helperResponse: state.helperResponse,
              showServerError: true);
        }
      },
      child: ColoredBox(
        color: AppColors.kBackGroundColor,
        child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.kBackGroundColor,
              appBar: AppBar(),
              body: Form(
                key: _key,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(getWidth * 0.04, getWidth * 0.06,
                      getWidth * 0.04, getWidth * 0.03),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Sign Up",
                          style: AppFontStyles.boldH1,
                        ),
                        const Text(
                          "Signup to Continue",
                          style: AppFontStyles.mediumH3,
                        ),
                        SizedBox(
                          height: getHeight * 0.05,
                        ),

                        // text fields
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // phone number text field
                            SizedBox(
                              height: getHeight * 0.15,
                            ),
                            CustomTextField(
                              label: "Name",
                              controller: nameController,
                              hintText: "johny",
                              validator: (value){
                                if (value == null || value.isEmpty) {
                                  return "Name is required";
                                }
                              },
                            ),
                            SizedBox(
                              height: heightBetweenFields,
                            ),
                            CustomTextField(
                              label: "Email",
                              controller: emailController,
                              hintText: "ee@ee.com",
                              validator: (value){
                                if (value == null || value.isEmpty) {
                                  return "Email is required";
                                }
                              },
                            ),

                            // password text field
                            SizedBox(
                              height: heightBetweenFields,
                            ),

                            CustomTextField(
                              action: TextInputAction.done,
                              controller: passwordController,
                              label: "Password",
                              onlyNumber: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password is required";
                                }
                                RegExp regex = RegExp(r'^(?=.*?[a-z]).{8,}$');
                                if (!regex.hasMatch(value)) {
                                  return 'Please Enter valid password';
                                }
                                return null;
                              },
                              hintText: '12345678a',
                              textInputType: TextInputType.visiblePassword,
                              passwordBool: true,
                            ),

                            SizedBox(
                              height: heightBetweenFields,
                            ),
                            CustomTextField(
                              action: TextInputAction.done,
                              controller: confirmPasswordController,
                              label: "Confirm Password",
                              onlyNumber: false,
                              validator: (value) {
                                if (value != passwordController.text) {
                                  return "Must be identical with the password";
                                }

                                return null;
                              },
                              hintText: '12345678a',
                              textInputType: TextInputType.visiblePassword,
                              passwordBool: true,
                            ),
                            SizedBox(
                              height: heightBetweenFields,
                            ),

                          ],
                        ),

                        SizedBox(height: getHeight * 0.06),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            return ElevatedButtonWidget(
                              title: 'Signup',
                              isLoading: state is UserLoading,
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  context.read<UserBloc>().add(SignUpEvent(
                                    fullName: nameController.text,
                                    password: passwordController.text,
                                    email: emailController.text,
                                    rePassword: confirmPasswordController.text,
                                  ));
                                }
                              },
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.login);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account ? ",
                                  style:  AppFontStyles.mediumH4,
                                ),
                                Text(
                                  'Login',
                                  style: AppFontStyles.boldH4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

//
