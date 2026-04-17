import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_test/core/themes/app_color.dart';
import 'package:login_test/core/themes/app_theme.dart';

class TextFieldCustom extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final String hintText;
  final String? labelText;
  final String errorText;
  final FocusNode? focusNode;
  final bool alwaysShowSuffix;
  final Widget? suffix;
  final bool isPasswordField;
  final Function(String) onChanged;
  final ValueChanged<String>? onSubmitted;
  final Function()? onClickSuffix;
  final Iterable<String>? autofillHints;
  final AnimationController animation;
  final Animation<double> offset;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldCustom({
    super.key,
    this.controller,
    required this.hintText,
    this.labelText,
    required this.errorText,
    this.focusNode,
    this.suffix,
    required this.onChanged,
    this.onSubmitted,
    this.onClickSuffix,
    this.inputType,
    this.textInputAction,
    this.alwaysShowSuffix = false,
    this.isPasswordField = false,
    this.autofillHints = const <String>[],
    required this.animation,
    required this.offset,
    this.inputFormatters,
  });

  @override
  State<StatefulWidget> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> with SingleTickerProviderStateMixin {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(widget.labelText!, style: context.textTheme.labelMedium),
        ],
        SizedBox(height: 8),
        AnimatedBuilder(
          animation: widget.offset,
          builder: (context, child) {
            return Transform.translate(offset: Offset(widget.offset.value, 0), child: child);
          },
          child: TextField(
            controller: _textEditingController,
            focusNode: _focusNode,
            keyboardType: widget.inputType ?? TextInputType.text,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            inputFormatters: widget.inputFormatters,
            autofillHints: widget.autofillHints,
            style: context.textTheme.titleSmall,
            obscureText: widget.inputType == TextInputType.visiblePassword ? true : false,
            obscuringCharacter: '✶',
            cursorColor: AppColors.darkOrange,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: context.textTheme.displayMedium,
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
              fillColor: context.theme.scaffoldBackgroundColor,
              filled: true,
            ),
          ),
        ),
        SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(widget.errorText, style: context.textTheme.displaySmall),
        ),
      ],
    );
  }
}
