import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:team360/home/viewmodel/home_viewmodel.dart';
import 'package:team360/touchbase/details_components/check_out_dialog.dart';
import 'package:team360/touchbase/details_components/details_info_card.dart';
import 'package:team360/touchbase/details_components/edit_box_top_hint.dart';
import 'package:team360/touchbase/details_components/model.dart';
import 'package:team360/touchbase/details_components/timer_widget.dart';
import 'package:team360/touchbase/model/checkout_request_model.dart';
import 'package:team360/touchbase/model/touchbase_response.dart';
import 'package:team360/touchbase/touchbase_order/order_history_screen.dart';
import 'package:team360/touchbase/viewmodel/touchbase_viewmodel.dart';
import 'package:team360/util/my_colors.dart';
import 'package:team360/base/response.dart';
import 'package:team360/util/progress_dialog.dart';
import 'package:team360/util/utils.dart';
import 'package:intl/intl.dart';

class TouchbaseDetailsBoody extends StatefulWidget {
  const TouchbaseDetailsBoody({Key? key, required this.retailerId, required this.touchbaseId}) : super(key: key);
  final int retailerId;
  final int touchbaseId;
  @override
  State<TouchbaseDetailsBoody> createState() => _TouchbaseDetailsBoodyState();
}

class _TouchbaseDetailsBoodyState extends State<TouchbaseDetailsBoody> {
  final _retNameCont = TextEditingController();
  final _addressCont = TextEditingController();
  final _ownerNameCont = TextEditingController();
  final _mobileNumCont = TextEditingController();
  final _emailCont = TextEditingController();
  final _noteController = TextEditingController();

  final salesmanRetailerTaskType = List<SalesmanRetailerTaskType>.empty(
      growable: true);

  @override
  void dispose() {
    _retNameCont.dispose();
    _addressCont.dispose();
    _ownerNameCont.dispose();
    _mobileNumCont.dispose();
    _emailCont.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    Response tr = Provider
        .of<HomeViewModel>(context)
        .getTouchbaseDetails;
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
      height: size.height,
      decoration: const BoxDecoration(
        color: MyColor.touchbaseDetailsPageColor,
        borderRadius: BorderRadius.zero,
      ),
      child: getTouchBaseOrProgress(tr, size),
    );
  }

  Widget getTouchBaseOrProgress(Response<dynamic> tr, Size size) {
    switch (tr.status) {
      case Status.INITIAL:
      case Status.LOADING:
        return const Center(child: CircularProgressIndicator(),);
      case Status.COMPLETED:
        final data = (tr.data as TouchBaseResponse).responseList;
        _retNameCont.text = data.name;
        _addressCont.text = data.location;
        _ownerNameCont.text = data.ownerName;
        _mobileNumCont.text = data.whatsappNo;
        _emailCont.text = data.email;
        Fimber.i("salesmanTouchbaseId = ${data.salesmanTouchbaseId} retailerId = ${data.retailerId}");
        return ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: EditBoxTopHintWhiteRounded(
                      hint: "Retailer full name",
                      controller: _retNameCont,
                    )),
                Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey,
                        blurRadius: 3.0,
                        spreadRadius: 0.0,
                        offset:
                        Offset(3.0, 3.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data.logo), radius: 30,
                  ),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.all(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: EditBoxTopHintWhiteRounded(
                      hint: "Retailer address",
                      controller: _addressCont,
                    )),
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey,
                        blurRadius: 3.0,
                        spreadRadius: 0.0,
                        offset:
                        Offset(3.0, 3.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: const Icon(Icons.location_on),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.all(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: EditBoxTopHintWhiteRounded(
                      hint: "Owner's name",
                      controller: _ownerNameCont,
                    )),
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: const Icon(null),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.all(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: EditBoxTopHintWhiteRounded(
                      hint: "Mobile No",
                      controller: _mobileNumCont,
                    )),
                Expanded(
                    child: EditBoxTopHintWhiteRounded(
                      hint: "Email",
                      controller: _emailCont,
                    )),
              ],
            ),
            Container(
                padding: const EdgeInsets.all(5),
                margin:
                const EdgeInsets.only(top: 15, bottom: 10, left: 5, right: 5),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3.0,
                        offset:
                        Offset(3.0, 3.0), // shadow direction: bottom right
                      ),
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.0,
                        offset:
                        Offset(-3.0, -3.0), // shadow direction: bottom right
                      )
                    ]),
                alignment: Alignment.center,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        value: data.taskList[index].isComplete == 1,
                        title: Text(
                          data.taskList[index].retailerTaskType,
                          style: const TextStyle(
                            fontSize: 16,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(0),
                        dense: true,
                        onChanged: (newVal) {
                          setState(() {
                            data.taskList[index].isComplete =
                            newVal ?? false ? 1 : 0;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading);
                  },
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: data.taskList.length,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DetailsInfoCard(
                  header: "\$LMTD",
                  footer: "${data.lmtd}",
                  icon: Image.asset(
                    "assets/icons/rupee.png",
                    width: 25,
                    height: 25,
                  ),
                ),
                DetailsInfoCard(
                  header: "\$MTD",
                  footer: "${data.mtd}",
                  icon: Image.asset(
                    "assets/icons/rupee.png",
                    width: 25,
                    height: 25,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DetailsInfoCard(
                  header: "Lifetime value",
                  footer: "${data.lifetimeValue}",
                  icon: Image.asset(
                    "assets/icons/rupee.png",
                    width: 25,
                    height: 25,
                  ),
                ),
                DetailsInfoCard(
                  header: "Payment Pending",
                  footer: "${data.paymentPending}",
                  icon: Image.asset(
                    "assets/icons/rupee.png",
                    width: 25,
                    height: 25,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DetailsInfoCard(
                  header: "Credit",
                  footer: "${data.credit}",
                  icon: Image.asset(
                    "assets/icons/rupee.png",
                    width: 25,
                    height: 25,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider<TouchBaseViewModel>(
                                  create: (_) => TouchBaseViewModel(),
                                  child: OrderHistoryScreen(retailerId: widget.retailerId),
                                )));
                    Provider.of<HomeViewModel>(context, listen: false)
                        .getTouchbaseDetailsFunc(widget.retailerId, widget.touchbaseId);
                    setState(() {

                    });
                  },
                  child: DetailsInfoCard(
                    header: "Order History",
                    footer: "${data.sales_order_count}",
                    icon: null,
                  ),
                )
              ],
            ),
            InkWell(
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                margin: EdgeInsets.only(
                    left: size.width * 0.15,
                    right: size.width * 0.15,
                    top: 10,
                    bottom: 15),
                decoration: const BoxDecoration(
                    color: Color(0xFFff0000),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1.0,
                        offset: Offset(
                            3.0, 3.0), // shadow direction: bottom right
                      ),
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1.0,
                        offset:
                        Offset(-1.0, -1.0), // shadow direction: bottom right
                      )
                    ]),
                child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Checkout",
                      style: TextStyle(fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              onTap: () {
                bool isAllComplete = true;
                salesmanRetailerTaskType.clear();
                for (var x in data.taskList) {
                  if (x.isComplete == 0) {
                    isAllComplete = false;
                    salesmanRetailerTaskType.add(
                      SalesmanRetailerTaskType(taskId: x.retailerTaskTypeId, status: 0)
                    );
                  }else{
                    salesmanRetailerTaskType.add(
                        SalesmanRetailerTaskType(taskId: x.retailerTaskTypeId, status: 1)
                    );
                  }
                }
                if (!isAllComplete) {
                  //CheckoutFeedbackDialog.show(context);
                  manageCheckoutWithNote(data);
                } else {
                  checkoutTouchbase(data);
                  //checkOutFalse(context);
                }
              },
            )
          ],
          shrinkWrap: true,
        );
      case Status.ERROR:
        Fluttertoast.showToast(msg: "Failed to fetch touchbase id");
        return Container();
    }
  }
  Future<void> checkOutFalse(BuildContext context)async {
    ProgressDialog.show(context);
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context)
      ..pop()..pop()..pop();
  }

  Future<void> checkoutTouchbase(ResponseList data, {String note = ""}) async {
    try {
      final now = DateTime.now();
      final temp = data.startTime.split(":");
      Fimber.i("startTime = ${data.startTime} temp = $temp");
      final diff = now.difference(DateTime(now.year,now.month,now.day,int.parse(temp[0]),int.parse(temp[1]),int.parse(temp[2])));
      int minute = diff.inMinutes % 60;
      int hour = (diff.inMinutes / 60).truncate();
      final body = CheckoutRequest(
          salesmanRetailerTaskType: salesmanRetailerTaskType,
          note: note,
          touchbaseEndTime: DateFormat('hh:mm:ss').format(now),
          totalTimeSpent: "${hour.toString().padLeft(2,"0")}:${minute.toString().padLeft(2,"0")}:00");
      Fimber.i("body = ${body.toJson()}");
      final touchbaseRes = await returnResponse(await http.put(Uri.parse(
          baseUrl + "bakes_and_cakes/BakesAndCakes/retailerCheckOut/${data.retailerId}/${data.salesmanId}/${data.salesmanTouchbaseId}"),
          headers: headers, body: jsonEncode(body)));
      Fimber.i("$touchbaseRes");
      Fluttertoast.showToast(msg: "Touchbase checkout successful");
     // Navigator.pop(context);
    } catch (e) {
      Fimber.i("$e");
    }
  }

  Future<dynamic> openDialog() async {
    return showDialog(context: context, builder: (context)=>AlertDialog(
      title: const Text("All tasks are not completed, Give Reason:"),backgroundColor: Colors.white,
      content: TextField(
        minLines: 10,
        maxLines: 15,
        controller: _noteController,keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,autofocus: true,onSubmitted: (newVal){
        Navigator.pop(context,newVal);
      },
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text("CANCEL",style: TextStyle(color: Colors.grey),)),
        TextButton(onPressed: (){
          Navigator.pop(context,_noteController.text);
        }, child: const Text("SUBMIT",style: TextStyle(color: Colors.blue),)),
      ],
    ));
  }

  Future<void> manageCheckoutWithNote(ResponseList data)async {
    final res = await openDialog();
    if(res != null && (res as String).isNotEmpty){
      checkoutTouchbase(data,note: res);
    }
  }
}
