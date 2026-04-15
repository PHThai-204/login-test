import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_test/core/themes/app_color.dart';
import 'package:login_test/core/themes/app_text_style.dart';
import 'package:login_test/core/themes/app_theme.dart';

class TextFieldCustom extends StatefulWidget {
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final String hintText;
  final String? labelText;
  final String errorText;
  final TextStyle? errorStyle;
  final FocusNode? focusNode;
  final bool alwaysShowSuffix;
  final Widget? suffix;
  final bool isPasswordField;
  final Function(String) onChanged;
  final ValueChanged<String>? onSubmitted;
  final Function()? onClickSuffix;

  const TextFieldCustom({
    super.key,
    this.controller,
    this.textStyle,
    required this.hintText,
    this.labelText,
    required this.errorText,
    this.errorStyle,
    this.focusNode,
    this.suffix,
    required this.onChanged,
    this.onSubmitted,
    this.onClickSuffix,
    this.inputType,
    this.textInputAction,
    this.alwaysShowSuffix = false,
    this.isPasswordField = false,
  });

  @override
  State<StatefulWidget> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  late TextEditingController _textEditingController;
  late final FocusNode _focusNode;
  late final bool _ownsController;
  late final bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;
    _textEditingController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    if (_ownsController) {
      _textEditingController.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(widget.labelText!, style: AppTextStyles.style.s16.w700.darkGrayColor),
        ],
        SizedBox(height: 8),
        TextField(
          controller: _textEditingController,
          focusNode: _focusNode,
          keyboardType: widget.inputType ?? TextInputType.text,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: AppTextStyles.style.s16.w600.darianColor,
          obscureText: widget.inputType == TextInputType.visiblePassword ? true : false,
          obscuringCharacter: '✶',
          cursorColor: AppColors.darkOrange,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.style.s16.w600.orchalColor,
            border: AppThemes.inputDefault,
            enabledBorder: AppThemes.inputDefault,
            errorBorder: AppThemes.inputDefault,
            focusedErrorBorder: AppThemes.inputFocused,
            focusedBorder: AppThemes.inputFocused,
            suffixIcon: widget.suffix != null
                ? CupertinoButton(
                    onPressed: () {
                      widget.onClickSuffix?.call();
                      if (!widget.isPasswordField) {
                        _textEditingController.clear();
                      }
                    },
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _textEditingController,
                      builder: (context, value, child) {
                        if (widget.alwaysShowSuffix) {
                          return widget.suffix!;
                        }
                        if (value.text.isNotEmpty) {
                          return widget.suffix!;
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  )
                : null,
            fillColor: AppColors.white.withValues(alpha: 0.1),
            filled: true,
          ),
        ),
        SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            widget.errorText,
            style: AppTextStyles.style.s12.w400.copyWith(color: Color(0xFFFF0000)),
          ),
        ),
      ],
    );
  }
}
