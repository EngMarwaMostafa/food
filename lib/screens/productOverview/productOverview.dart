import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/config/colors.dart';
import 'package:food_app/providers/wishlist_provider.dart';
import 'package:food_app/review_cart/review_cart.dart';
import 'package:food_app/widgets/count.dart';
import 'package:provider/provider.dart';

//enum SinginCharacter{fill,outline}

class ProductOverview extends StatefulWidget {
  final String productName;
  final String productImage;
  final int productPrice;
  final String productId;
  final String productQuantity;

   ProductOverview({
     required this.productName,
     required this.productImage,
     required this.productPrice,
     required this.productId,
     required this.productQuantity}) ;

  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {

  bool _value = false;
  int val = -1;

 // SinginCharacter _character = SinginCharacter.fill;

  Widget bonntonNavigatorBar({
  Color? iconColor,
  Color? backgroundColor,
  Color? color,
  String? title,
  IconData? iconData,
   void Function()? onTap,
     })  {
    return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(20),
            color: backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    iconData,
                   size: 17,
                  color: iconColor,
                ),
                SizedBox(
                 width: 5,
                ),
                Text(
                  title!,
                  style: TextStyle(
                  color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
  bool wishListBool = false;

  getWishtListBool() {
    FirebaseFirestore.instance
        .collection("WishList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("YourWishList")
        .doc(widget.productId)
        .get()
        .then((value) => {
      if (this.mounted)
        {
          if (value.exists)
            {
              setState(
                    () {
                  wishListBool = value.get("wishList");
                },
              ),
            }
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    WishListProvider wishListProvider = Provider.of(context);
    getWishtListBool();
    return Scaffold(
      bottomNavigationBar:Row(
        children: [
         bonntonNavigatorBar(
           backgroundColor: textColor,
           color: Colors.white70,
           iconColor: Colors.grey,
           title: 'Add To WishList',
           iconData: wishListBool==false?Icons.favorite_outline
               : Icons.favorite,
           onTap: (){
             setState(() {
               wishListBool = !wishListBool;
             });
             if(wishListBool == true){
               wishListProvider.addWishListData(
                 wishListId: widget.productId,
                 wishListImage: widget.productImage,
                 wishListName: widget.productName,
                 wishListPrice: widget.productPrice,
                 wishListQuantity: 2
               );
             }else{
               wishListProvider.deleteWishtList(widget.productId);
             }
           }
         ) ,
          bonntonNavigatorBar(
            backgroundColor: textColor,
            color: textColor,
            iconColor: Colors.white70,
            title: 'Go To Cart',
            iconData: Icons.shop_outlined,
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ReviewCart(),
              ),
              );
            },
          ) ,
        ],
      ),
    appBar: AppBar(
      iconTheme: IconThemeData(color:textColor ),
      title: Text('Product Overview',
      style: TextStyle(color: textColor),),
    ),
      body: Column(
        children: [
          Expanded(
              flex: 2,
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  ListTile(
                    title:Text(widget.productName) ,
                    subtitle: Text('\$50'),
                  ),
                  Container(
                    height: 250,
                    padding: EdgeInsets.all(40),
                    child: Image.network(
                  widget.productImage,
                    ),),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Text('Available Options',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                      padding:EdgeInsets.symmetric(horizontal: 10,
                      ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 3,
                          backgroundColor: Colors.green[700],
                        ),
                    Radio(
                      value: 1,
                      groupValue: val,
                      onChanged: (value) {
                        setState(() {
                          val = value as int;
                        });
                      },
                    ),],
                    ),
                   ),
                  Text('\$${widget.productPrice}'),
            Count(
          productId: widget.productId,
          productImage: widget.productImage,
          productName: widget.productName,
          productPrice: widget.productPrice,
               productUnit: '500 Gram',
               /*   Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey),
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(
                        Icons.add,
                      size: 17,
                      color: primaryColor,),
                        Text(
                          'Add',
                          style: TextStyle(
                            color: primaryColor),
                        ),
                      ],
                    ),
                  ),*/
            ), ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text('About This Product',
                 style: TextStyle(
                   fontSize: 18,
                   fontWeight: FontWeight.w600,
                 ),) ,
                  SizedBox(
                    height: 10,
                  ),
                  Text('In marketing, a product is an object or system made available for consumer use; it is anything that can be offered to a market to satisfy the desire or need of a customer',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),) ,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
