import 'dart:math';

class StringHelper {

  /* Gerar uma string aleatória */
  static String randomString(int tamanho) {
    final String chars =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = new Random();
    String result = '';
    for (int i = tamanho; i > 0; i--) {
      result += chars[random.nextInt(chars.length)];
    }
    return result;
  }

  /* remove enredeço url padrão de uma string
  entrada -> https://multiplierstorage.s3-sa-east-1.amazonaws.com/wadvice/temporadas/9ee56e46-f3e6
  saida -> /wadvice/temporadas/9ee56e46-f3e6 */
  static String stripUrl(String string) {
    return string.replaceAll(new RegExp(r'http.*(\.com|\.br)\/'), '');
  }
  
}
