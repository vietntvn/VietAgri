List<String> extractUniqueChars(String str) {
  str = str.toLowerCase();
  Map temp = {};
  for (int index = 0; index < str.length; index++) {
    temp[str[index]] = 0;
  }
  String uniqChars = temp.keys.join('').replaceAll(' ', '');
  List<String> keys = [];
  for (int i = 0; i < uniqChars.length; i++) {
    if (RegExp(r'[a-z0-9]').hasMatch(uniqChars[i])) keys.add(uniqChars[i]);
  }
  return keys;
}
