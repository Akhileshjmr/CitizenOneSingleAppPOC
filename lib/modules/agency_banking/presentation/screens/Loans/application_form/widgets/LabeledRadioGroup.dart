import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';

class LabeledRadioGroup<T> extends FormField<T> {
  LabeledRadioGroup({
    Key? key,
    required String label,
    required List<T> options,
    T? value,
    ValueChanged<T?>? onChanged,
    String Function(T)? labelBuilder,
    FormFieldValidator<T>? validator,
    bool isMandatory = false,
    bool enabled = true,
  }) : super(
    key: key,
    initialValue: value,
    validator: validator,
    builder: (FormFieldState<T> state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                children: isMandatory
                    ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  )
                ]
                    : [],
              ),
            ),
            const SizedBox(height: 6),
            Column(
              children: options.map((option) {
                return RadioListTile<T>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    labelBuilder != null
                        ? labelBuilder(option)
                        : option.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                  value: option,
                  groupValue: state.value,
                  activeColor: AppColors.btnBackground,
                  // onChanged: (val) {
                  //   state.didChange(val);
                  //   if (onChanged != null) onChanged(val);
                  // },
                    onChanged: enabled
                        ? (val) {
                      state.didChange(val);
                      if (onChanged != null) onChanged(val);
                    }
                        : null,
                );
              }).toList(),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}
