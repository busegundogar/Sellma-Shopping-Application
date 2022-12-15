import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  String? productName;
  String? brand;
  int? price;
  String? seller;
  String? category;
  String? description;
  int? discount;
  bool? isSold;
  String? color;
  String? size;
  DocumentReference? sellerRef;
  String? productRef;
  double? rateSum;
  double? raterCount;
  List<dynamic>? images;
  List<dynamic>? comments;


  Product( {
    this.productName: "",
    this.brand: "",
    this.price: 0,
    this.seller: "",
    this.category: "",
    this.description: "",
    this.discount: 0,
    this.isSold: false,
    this.color: "",
    this.size: "",
    this.sellerRef = null,
    this.productRef = null,
    this.images: const [],
    this.rateSum: 0.0,
    this.raterCount: 0.0,
    this.comments: const [],
  });

  Product.func(proName,bra, pri,sel,cat,desc,disc,sold,clr,siz,ref,pref,sum,count,imag, comm){
    this.productName = proName;
    this.brand = bra;
    this.price = pri;
    this.seller = sel;
    this.category = cat;
    this.description = desc;
    this.discount = disc;
    this.isSold = sold;
    this.color = clr;
    this.size = siz;
    this.sellerRef = ref;
    this.productRef = pref;
    this.rateSum = sum;
    this.raterCount = count;
    this.images = imag;
    this.comments = comm;
  }

  @override
  String toString() => "Product: $productName\nPrice: $price\nCategory: $category";

}