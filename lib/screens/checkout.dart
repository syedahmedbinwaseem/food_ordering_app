import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_ordering_app/screens/bottomNavigator.dart';
import 'package:food_ordering_app/screens/cart.dart';
import 'package:food_ordering_app/user/localUser.dart';
import 'package:food_ordering_app/utils/colors.dart';
import 'package:food_ordering_app/utils/success.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class Checkout extends StatefulWidget {
  bool delivery;
  List products;
  int totalPrice;
  int totalQuantity;
  Checkout({this.delivery, this.products, this.totalPrice, this.totalQuantity});
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  Box cart;
  Future openBox() async {
    await Hive.openBox('cart').then((value) {
      setState(() {
        cart = value;
      });
    });
  }

  String dropdownValue;

  List items = ['D Block', 'H Block', 'C Block', 'K Block', 'SSC'];

  @override
  void initState() {
    super.initState();
    openBox();
  }

  final location = TextEditingController();
  GlobalKey<FormState> fKey = GlobalKey<FormState>();

  bool payViaWallet = false;
  bool reserve = false;
  bool isLoading = false;

  void getProducts() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('orders').get();

    QuerySnapshot abc = await FirebaseFirestore.instance
        .collection('orders')
        .doc(snap.docs.first.id)
        .collection('products')
        .get();

    abc.docs.forEach((element) async {
      await FirebaseFirestore.instance
          .collection('products')
          .doc('category')
          .collection(element['category'])
          .doc(element['id'])
          .get()
          .then((value) {
        print(value['name']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: blue,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'Checkout',
              style: TextStyle(fontFamily: 'Sofia', fontSize: 22),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      // height: 200,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryGreen.withOpacity(0.3),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Total Items',
                                style: TextStyle(
                                    fontFamily: 'Sofia',
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                              Spacer(),
                              Text(
                                widget.totalQuantity.toString(),
                                style: TextStyle(
                                    fontFamily: 'Sofia',
                                    color: Colors.black.withOpacity(0.6),
                                    // fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.038),
                          Row(
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                    fontFamily: 'Sofia',
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                              Spacer(),
                              Text(
                                'Rs. ${widget.totalPrice}',
                                style: TextStyle(
                                    fontFamily: 'Sofia',
                                    color: Colors.black.withOpacity(0.6),
                                    // fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.038),
                          Row(
                            children: [
                              Text(
                                'Delivery',
                                style: TextStyle(
                                    fontFamily: 'Sofia',
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                              Spacer(),
                              Text(
                                widget.delivery == true ? 'Rs. 50' : 'Rs. 0',
                                style: TextStyle(
                                    fontFamily: 'Sofia',
                                    color: Colors.black.withOpacity(0.6),
                                    // fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.038),
                          Divider(
                            color: darkGreen,
                          ),
                          SizedBox(height: width * 0.038),
                          Row(
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontFamily: 'Sofia',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                              Spacer(),
                              Text(
                                widget.delivery == true
                                    ? 'Rs. ${widget.totalPrice + 50}'
                                    : 'Rs.  ${widget.totalPrice}',
                                style: TextStyle(
                                    fontFamily: 'Sofia',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: width * 0.038),
                    widget.delivery == true
                        ? Container(
                            width: width,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: primaryGreen.withOpacity(0.3)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Delivery Location',
                                  style: TextStyle(
                                      fontFamily: 'Sofia',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                ),
                                SizedBox(height: width * 0.03),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Sofia'),
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: blue,
                                        ),
                                        value: dropdownValue,
                                        hint: Text(
                                          'Select an option',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontFamily: 'Sofia'),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownValue = value;
                                          });
                                        },
                                        items: List.from(items)
                                            .map<DropdownMenuItem<String>>(
                                                (e) => DropdownMenuItem<String>(
                                                    value: e, child: Text(e)))
                                            .toList()),
                                  ),
                                ),
                                Form(
                                  key: fKey,
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(fontFamily: 'Sofia'),
                                    controller: location,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                          fontFamily: 'Sofia',
                                          color: Colors.red,
                                          fontSize: 14),
                                      labelText: 'Add Comments',
                                      labelStyle: TextStyle(
                                          fontFamily: 'Sofia',
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: width,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: primaryGreen.withOpacity(0.3)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.done),
                                  SizedBox(width: 10),
                                  Text(
                                    'Self pickup',
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    SizedBox(height: width * 0.038),
                    Container(
                      width: width,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryGreen.withOpacity(0.3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment',
                            style: TextStyle(
                                fontFamily: 'Sofia',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                          SizedBox(height: width * 0.03),
                          FlatButton(
                            splashColor: primaryGreen.withOpacity(0.3),
                            focusColor: primaryGreen.withOpacity(0.3),
                            highlightColor: primaryGreen.withOpacity(0.3),
                            onPressed: () {
                              setState(() {
                                reserve = false;
                                payViaWallet = !payViaWallet;
                              });
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.payment_outlined,
                                    color: blue,
                                  ),
                                  SizedBox(width: width * 0.02777),
                                  Text(
                                    'Pay via wallet',
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        fontSize: width * 0.04722),
                                  ),
                                  Spacer(),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Checkbox(
                                          value: payViaWallet,
                                          onChanged: (_) {
                                            setState(() {
                                              reserve = false;
                                              payViaWallet = !payViaWallet;
                                            });
                                          }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          FlatButton(
                            splashColor: primaryGreen.withOpacity(0.3),
                            focusColor: primaryGreen.withOpacity(0.3),
                            highlightColor: primaryGreen.withOpacity(0.3),
                            onPressed: () {
                              setState(() {
                                payViaWallet = false;
                                reserve = !reserve;
                              });
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bookmark_border_outlined,
                                    color: blue,
                                  ),
                                  SizedBox(width: width * 0.02777),
                                  Text(
                                    'Reserve order',
                                    style: TextStyle(
                                        fontFamily: 'Sofia',
                                        fontSize: width * 0.04722),
                                  ),
                                  Spacer(),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Checkbox(
                                          value: reserve,
                                          onChanged: (_) {
                                            setState(() {
                                              payViaWallet = false;
                                              reserve = !reserve;
                                            });
                                          }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: width * 0.05),
                    FlatButton(
                      onPressed: () {
                        if (widget.delivery == true) {
                          if (fKey.currentState.validate()) {
                            if (payViaWallet == false && reserve == false) {
                              EasyLoading.showToast(
                                'Select payment method',
                                duration: Duration(seconds: 2),
                                toastPosition: EasyLoadingToastPosition.bottom,
                                dismissOnTap: true,
                              );
                            } else {
                              if (payViaWallet == true) {
                                checkout(true, 1);
                              } else {
                                checkout(true, 2);
                              }
                            }
                          }
                        } else {
                          if (payViaWallet == false && reserve == false) {
                            EasyLoading.showToast(
                              'Select payment method',
                              duration: Duration(seconds: 2),
                              toastPosition: EasyLoadingToastPosition.bottom,
                              dismissOnTap: true,
                            );
                          } else {
                            if (payViaWallet == true) {
                              checkout(false, 1);
                            } else {
                              checkout(false, 2);
                            }
                          }
                        }
                      },
                      height: 40,
                      color: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'CONFIRM ORDER',
                          style: TextStyle(
                              fontFamily: 'Sofia',
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkout(bool delivery, int payment) async {
    print('self pay via wallet');
    setState(() {
      isLoading = true;
    });
    int orderNumber;
    await FirebaseFirestore.instance
        .collection('products')
        .doc('category')
        .get()
        .then((value) {
      orderNumber = value['ordernumber'];
    });
    if (delivery == false && payment == 1) {
      DocumentSnapshot checkFunds = await FirebaseFirestore.instance
          .collection('user')
          .doc(LocalUser.userData.email)
          .get();
      if (checkFunds['walletAmount'] < widget.totalPrice) {
        setState(() {
          isLoading = false;
        });
        EasyLoading.showToast(
          'Not enough funds in wallet. Please recharge.',
          duration: Duration(seconds: 2),
          toastPosition: EasyLoadingToastPosition.bottom,
          dismissOnTap: true,
        );
      } else {
        DocumentReference ref =
            FirebaseFirestore.instance.collection('orders').doc();
        await ref.set({
          'time': DateTime.now(),
          'totalPrice': widget.totalPrice,
          'totalItems': widget.totalQuantity,
          'orderNumber': orderNumber + 1,
          'orderBy': LocalUser.userData.email,
          'status': 'received',
          'delivery': false
        }).then((value) async {
          widget.products.forEach((element) async {
            ref.collection('products').doc().set({
              'id': element['id'],
              'category': element['category'],
              'quantity': element['quantity'],
              'size': element['size'],
              'price': element['price']
            });
          });
          await FirebaseFirestore.instance
              .collection('user')
              .doc(LocalUser.userData.email)
              .update(
                  {'walletAmount': FieldValue.increment(-widget.totalPrice)});
          await FirebaseFirestore.instance
              .collection('products')
              .doc('category')
              .update({'ordernumber': orderNumber + 1});
        }).then((value) {
          setState(() {
            isLoading = false;
          });

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return SuccessDialog();
              }).then((value) {
            print('here');
            cart.clear();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomNavigator()),
                (route) => false);
          });
        });
      }
    } else if (delivery == false && payment == 2) {
      print('self reserve');
    } else if (delivery == true && payment == 1) {
      print('delivery pay via wallet');
      if (dropdownValue == '' || dropdownValue == null) {
        EasyLoading.showToast(
          'Select delivery location',
          duration: Duration(seconds: 2),
          toastPosition: EasyLoadingToastPosition.bottom,
          dismissOnTap: true,
        );
        setState(() {
          isLoading = false;
        });
      } else {
        DocumentSnapshot checkFunds = await FirebaseFirestore.instance
            .collection('user')
            .doc(LocalUser.userData.email)
            .get();
        if (checkFunds['walletAmount'] < widget.totalPrice) {
          setState(() {
            isLoading = false;
          });
          EasyLoading.showToast(
            'Not enough funds in wallet. Please recharge.',
            duration: Duration(seconds: 2),
            toastPosition: EasyLoadingToastPosition.bottom,
            dismissOnTap: true,
          );
        } else {
          DocumentReference ref =
              FirebaseFirestore.instance.collection('orders').doc();
          await ref.set({
            'time': DateTime.now(),
            'totalPrice': widget.totalPrice,
            'totalItems': widget.totalQuantity,
            'orderNumber': orderNumber + 1,
            'orderBy': LocalUser.userData.email,
            'status': 'received',
            'delivery': true,
            'location': dropdownValue,
            'comments': location.text
          }).then((value) async {
            widget.products.forEach((element) async {
              ref.collection('products').doc().set({
                'id': element['id'],
                'category': element['category'],
                'quantity': element['quantity'],
                'size': element['size'],
                'price': element['price']
              });
            });
            await FirebaseFirestore.instance
                .collection('user')
                .doc(LocalUser.userData.email)
                .update(
                    {'walletAmount': FieldValue.increment(-widget.totalPrice)});
            await FirebaseFirestore.instance
                .collection('products')
                .doc('category')
                .update({'ordernumber': orderNumber + 1});
          }).then((value) {
            setState(() {
              isLoading = false;
            });

            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return SuccessDialog();
                }).then((value) {
              print('here');
              cart.clear();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavigator()),
                  (route) => false);
            });
          });
        }
      }
    } else if (delivery == true && payment == 2) {
      print('delivery reserve');
    }
  }
}
