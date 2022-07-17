import 'dart:convert';

String desencriptar(String plainText) {
  Codec<String, String> stringtoBase64 = utf8.fuse(base64);
  String decoded = stringtoBase64.decode(plainText);
  return decoded;
}
