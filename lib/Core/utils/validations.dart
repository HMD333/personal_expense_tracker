String? requiredValidator(String? val) {
  if (val == null || val.trim().isEmpty) return 'This field is required';
  return null;
}
