import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  // إنشاء صور placeholder للسلايدر
  createPlaceholderImage('assets/images/slider1.jpg', 0, 123, 255); // أزرق
  createPlaceholderImage('assets/images/slider2.jpg', 40, 167, 69); // أخضر
  createPlaceholderImage('assets/images/slider3.jpg', 220, 53, 69); // أحمر

  // إنشاء صور المتاجر
  createPlaceholderImage('assets/images/store1.jpg', 253, 126, 20); // برتقالي
  createPlaceholderImage('assets/images/store2.jpg', 111, 66, 193); // بنفسجي
  createPlaceholderImage('assets/images/store3.jpg', 23, 162, 184); // أزرق فاتح

  // إنشاء صور المنتجات
  createPlaceholderImage('assets/images/product1.jpg', 139, 69, 19); // بني
  createPlaceholderImage('assets/images/product2.jpg', 0, 255, 255); // سماوي

  // إنشاء أيقونات التواصل الاجتماعي
  createIconImage('assets/icons/facebook.png', 0, 123, 255); // أزرق
  createIconImage('assets/icons/instagram.png', 111, 66, 193); // بنفسجي
  createIconImage('assets/icons/twitter.png', 173, 216, 230); // أزرق فاتح
  createIconImage('assets/icons/whatsapp.png', 40, 167, 69); // أخضر

  print('تم إنشاء جميع الصور بنجاح!');
}

void createPlaceholderImage(String path, int r, int g, int b) {
  final image = img.Image(width: 400, height: 300);
  // ملء الصورة بلون محدد
  img.fillRect(image,
      x1: 0, y1: 0, x2: 400, y2: 300, color: img.ColorUint8.rgb(r, g, b));

  // حفظ الصورة
  File(path).writeAsBytesSync(img.encodeJpg(image));
}

void createIconImage(String path, int r, int g, int b) {
  final image = img.Image(width: 100, height: 100);
  // ملء الأيقونة بلون محدد
  img.fillRect(image,
      x1: 0, y1: 0, x2: 100, y2: 100, color: img.ColorUint8.rgb(r, g, b));

  // حفظ الأيقونة
  File(path).writeAsBytesSync(img.encodePng(image));
}
