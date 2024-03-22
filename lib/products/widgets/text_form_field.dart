import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/core/constants/app_colors.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/login_register_page/viewModel/login_view_model.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.changeObscureCallBack,
    this.isObsecure = false,
    required this.validator,
    required Null Function(dynamic value) onSaved,
  });

  final TextEditingController controller;
  final String hintText;

  final bool isObsecure;
  final VoidCallback changeObscureCallBack;
  final String? Function(String?)? validator;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((context, value, child) {
        var shouldObscureText = widget.isObsecure &&
            (context.watch<LoginViewModel>().isObsecures ?? true);
        return TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.silverlined,
                  fontWeight: FontWeight.w600,
                ),
            suffixIcon: widget.isObsecure
                ? context.watch<LoginViewModel>().isObsecures ?? false
                    ? IconButton(
                        onPressed: () =>
                            context.read<LoginViewModel>().changeObsecure(),
                        icon: const Icon(Icons.visibility_off_rounded),
                      )
                    : IconButton(
                        onPressed: () =>
                            context.read<LoginViewModel>().changeObsecure(),
                        icon: const Icon(Icons.visibility),
                      )
                : const SizedBox(),
          ),
          obscureText: shouldObscureText,
        );
      }),
    );
  }
}
