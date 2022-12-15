import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selma_sign_up/models/product.dart';
import 'package:selma_sign_up/models/product.dart';


FirebaseProduct(){

  Product theProduct;

  List<Product> _products = [];

  List<Product> getProducts() {
    return _products;
  }

  Map<String, dynamic> proData;

  final _instance = FirebaseFirestore.instance;

/*
  FirebaseFirestore.instance.collection("products").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      proData = result.data();

      Product pro = Product.func(
        proData['productName'],
        proData['price'],
        proData['seller'],
        proData['category'],
        proData['description'],
        proData['discount'],
        proData['isSold'],
        proData['color'],
        proData['size'],
        proData['images'],
        proData['comments'],
      );
      _products.add(pro);
    });
    //print(_products);
    return _products;
  });
  //print(_products);
  //return _products;
*/
}
/*
FirebaseProd(){


  List<Product> _products = [];

  List<Product> getProducts() {
    return _products;
  }

  Map<String, dynamic> prodData;

  final _instance = FirebaseFirestore.instance;

  _instance.collection("products").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      prodData = result.data();

      Product pro = Product.func(
        prodData['productName'],
        prodData['price'],
        prodData['seller'],
        prodData['category'],
        prodData['description'],
        prodData['discount'],
        prodData['isSold'],
        prodData['color'],
        prodData['size'],
        prodData['images'],
        prodData['comments'],
      );
      //print(pro);
    });
    return _products;
  });
  //return _products;
}*/