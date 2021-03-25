class AddProduct {
  String productName,
      productCategory,
      productStock,
      smithName,
      smithNumber,
      melting,
      grams,
      stones,
      seal,
      description,
      image;

  AddProduct(
      {this.productName,
      this.productCategory,
      this.productStock,
      this.smithName,
      this.smithNumber,
      this.melting,
      this.grams,
      this.stones,
      this.seal,
      this.description,
      this.image,
      });

  // factory AddProduct.fromDocument(DocumentSnapshot doc){
  //   return AddProduct(
  //     productName: doc['productName'],
  //     productCategory: doc['productCategory'],
  //     smithName: doc['smithName'],
  //     smithNumber: doc['smithNumber'],
  //     melting: doc['melting'],
  //     grams: doc['grams'],
  //     stones: doc['stones'],
  //     seal: doc['seal'],
  //     description: doc['description'],
  //     image: doc['image']
  //   );
  // }
}
