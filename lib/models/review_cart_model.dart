class ReviewCartModel{
  String cartId;
  String cartImage;
  String cartName;
  int cartPrice;
  int cartQuantity;
  var cartUnit;



  ReviewCartModel({
    required this.cartName,
    required this.cartImage,
    required this.cartId,
    required this.cartPrice,
    required this.cartQuantity,
    required this.cartUnit,
  });
}