class Discount {
  String brand;
  String text;
  String date;

  Discount({
    required this.brand,
    required this.text,
    required this.date
  });

  @override
  String toString() => 'Brand: $brand\nDiscount: $text\nDate: $date';
}