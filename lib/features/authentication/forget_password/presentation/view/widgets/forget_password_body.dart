import 'package:ekhtarly_app/core/utils/app_router.dart';
import 'package:ekhtarly_app/core/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../../../constants.dart';
import '../../../../../../core/functions/show_snack_bar.dart';
import '../../../../../../core/utils/widgets/custom_all_content_text_form_field.dart';
import '../../../../../../core/utils/widgets/input_validation_mixin.dart';
import '../../../../manger/forgot_password_send_code_cubit/forgot_password_send_code_cubit.dart';
import 'custom_text_forget_password.dart';
import '../../../../../../core/utils/widgets/custom_widget_row_text.dart';

class ForgetPasswordBody extends StatefulWidget with InputValidationMixin {
  const ForgetPasswordBody({super.key});

  @override
  State<ForgetPasswordBody> createState() => _ForgetPasswordBodyState();
}

class _ForgetPasswordBodyState extends State<ForgetPasswordBody> {
  GlobalKey<FormState> forgetPasswordForm = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool validate = false;
  String? email;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordSendCodeCubit,
        ForgotPasswordSendCodeState>(
      listener: (context, state) {
        if (state is ForgotPasswordSendCodeSuccess) {
          GoRouter.of(context)
              .push(AppRouter.kOtpForgetPasswordView, extra: email);
        } else if (state is ForgotPasswordSendCodeFailure) {
          showSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: state is ForgotPasswordSendCodeLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Form(
            key: forgetPasswordForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(
                  flex: 2,
                ),
                const CustomTextForgetPassword(
                  text: 'Forget Password',
                  textDetails: 'Enter your registered email below',
                ),
                const SizedBox(
                  height: 54,
                ),
                CustomAllContentTextFormField(
                  validator: (email) {
                    if (email?.isEmpty ?? true) {
                      return 'Email is Required';
                    } else if (!widget.isEmailValid(email.toString())) {
                      return 'Email address is invalid, Please enter a valid email';
                    } else {
                      return null;
                    }
                  },
                  textFormField: 'Eg namaemail@emailkamu.com ',
                  topTextFeild: 'Email address',
                  colorTopTextFeild: validate ? kSecondaryColor : kBlackColor,
                  onChanged: (value) {
                    {
                      email = value;
                      setState(() {
                        validate = forgetPasswordForm.currentState!.validate();
                      });
                    }
                  },
                  icon: Icons.email_outlined,
                  prefixIconColor: validate ? kSecondaryColor : kBlackColor,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomWidgetRowText(
                  featureText: 'Sign in',
                  text: 'Remember the password? ',
                  textColor: kSecondaryColor,
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kLoginView);
                  },
                ),
                const Spacer(flex: 4),
                Center(
                  child: CustomButton(
                      onPressed: () {
                        if (forgetPasswordForm.currentState!.validate()) {
                          BlocProvider.of<ForgotPasswordSendCodeCubit>(context)
                              .forgotPasswordSendCode(email: email!);
                          //BlocProvider.of<OtpForgetPasswordCubit>(context).
                          // GoRouter.of(context).push(AppRouter.kOtpForgetPasswordView,extra: email);

                          // GoRouter.of(context).push(AppRouter.kCheckEmailView);
                        } else {
                          setState(() {
                            validate = false;
                            autovalidateMode = AutovalidateMode.always;
                          });
                        }
                      },
                      text: 'Submit',
                      colorButton:
                          validate ? kPrimaryColor : kAlternateButtonColor,
                      colorText: validate ? Colors.white : kButtonColor),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
