import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    this.hintText,
    this.obscureText,
    this.suffixWidget,
    this.keyboardType,
    this.labelText,
    this.labelColor,
    this.requiredLabelText,
    this.maxLines,
    this.maxLength,
    this.validation,
    this.onTap,
    this.onSumbit,
    this.onChanged,
    this.textController,
    this.readOnly,
    this.fillColor,
    this.prefixWidget,
    this.hintStyle,
    this.borderRadius,
    this.borderColor,
    this.bottomPadding,
    this.insideLableText,
    this.labelFontWeight,
    this.labelFontSize,
    this.textColor,
    this.inputFormatters,
  });

  final String? hintText;
  final String? labelText;
  final Color? labelColor;
  final bool? requiredLabelText;
  final String? insideLableText;
  final bool? obscureText;
  final bool? readOnly;
  final Widget? suffixWidget;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validation;
  final TextEditingController? textController;
  final void Function()? onTap;
  final void Function(String)? onSumbit;
  final void Function(String)? onChanged;
  final Color? fillColor;
  final Widget? prefixWidget;
  final TextStyle? hintStyle;
  final double? borderRadius;
  final Color? borderColor;
  final double? bottomPadding;
  final FontWeight? labelFontWeight;
  final double? labelFontSize;
  final Color? textColor;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    if (widget.textController != null) {
      _hasText = widget.textController!.text.isNotEmpty;
      widget.textController!.addListener(() {
        final hasTextNow = widget.textController!.text.trim().isNotEmpty;
        if (hasTextNow != _hasText) {
          if (mounted) {
            setState(() {
              _hasText = hasTextNow;
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
      borderSide: BorderSide(
        color: widget.borderColor ?? AppColors.transparent,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          RichText(
            text: TextSpan(
              text: widget.labelText,
              style: CommonStyle.getRalewayFont(
                fontSize: widget.labelFontSize ?? 16,
                fontWeight: widget.labelFontWeight ?? FontWeight.w400,
                color: widget.labelColor ?? Colors.black,
              ),
              children: [
                if (widget.requiredLabelText == true)
                  const TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: widget.bottomPadding ?? 15),
              child: TextFormField(
                readOnly: widget.readOnly ?? false,
                controller: widget.textController,
                validator: widget.validation,
                maxLines: widget.maxLines ?? 1,
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required isFocused,
                      required maxLength,
                    }) => null,
                maxLength: widget.maxLength,
                obscureText: widget.obscureText ?? false,
                obscuringCharacter: "*",
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters ?? [],
                decoration: InputDecoration(
                  prefixIcon: widget.prefixWidget,
                  fillColor: widget.fillColor ?? Colors.white,
                  filled: true,
                  suffixIcon: widget.suffixWidget,
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                  errorBorder: border,
                  focusedErrorBorder: border,
                  errorMaxLines: 3,
                  hintText: widget.hintText ?? "",
                  errorStyle: CommonStyle.getRalewayFont(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                  hintStyle:
                      widget.hintStyle ??
                      CommonStyle.getRalewayFont(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey1,
                      ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                ),
                style: CommonStyle.getRalewayFont(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: widget.textColor ?? Colors.black,
                ),
                onTap: widget.onTap,
                onFieldSubmitted: widget.onSumbit,
                onChanged: widget.onChanged,
              ),
            ),
            if (_hasText && widget.insideLableText != null)
              Positioned(
                left: widget.prefixWidget != null ? 60 : 16,
                top: 4,
                child: Text(
                  widget.insideLableText!,
                  style: CommonStyle.getRalewayFont(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
        // if (_hasText &&
        //     widget.infoText != null) // 👈 show info only when typing
        //   Padding(
        //     padding: const EdgeInsets.only(bottom: 6),
        //     child: Row(
        //       children: [
        //         Image.asset(LocalImages.icWaiting, scale: 3),
        //         SizedBox(width: 6),
        //         Expanded(
        //           child: Text(
        //             widget.infoText!,
        //             style: CommonStyle.getPtSansFont(
        //               fontSize: 14,
        //               fontWeight: FontWeight.w400,
        //               color: Colors.black,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
      ],
    );
  }
}
