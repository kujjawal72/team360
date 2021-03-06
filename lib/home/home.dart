import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team360/home/components/body.dart';
import 'package:team360/home/viewmodel/home_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:team360/util/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeViewModel>(context,listen: false);
    provider.getAttendanceFunc();
    provider.getSalesmanDashboard();
    provider.getSalesmanTaskByDate(todayDate());
    return const Scaffold(
        appBar: null,
        backgroundColor: Colors.transparent, //MyColor.appBackgroundColor,
        body: Body());
  }
}
