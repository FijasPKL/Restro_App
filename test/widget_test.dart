// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:newstructure/pages/running_tab.dart';
// import 'package:newstructure/pages/tables_tab.dart';
// import 'package:provider/provider.dart';
// import '../models/modelclasses/dinning.dart';
// import '../models/modelclasses/kot.dart';
// import '../models/modelclasses/reorder.dart';
// import '../models/modelclasses/settings_save.dart';
// import '../models/provider/reorder_provider.dart';
// import '../models/provider/sending_kot_provider.dart';
// import '../utils/global_fn.dart';
// import '../utils/show_dialog.dart';
// import 'Dashboard.dart';
// import 'category_tab.dart';
// import 'items_tab.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => SelectedItemsProvider(),
//       child: const MaterialApp(
//         home: Homepage(),
//       ),
//     );
//   }
// }
//
// class Homepage extends StatefulWidget {
//   final String? employeeName;
//   final int? employeeId;
//
//   const Homepage({
//     Key? key,
//     this.employeeName,
//     this.employeeId,
//   }) : super(key: key);
//
//   @override
//   State<Homepage> createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage>
//     with SingleTickerProviderStateMixin {
//   late TabController tabController;
//   String? DeviceId = "";
//   int selectedQuantity = 1;
//   SQLMessage? sqlMessage;
//   List<ExtraAddOn>? extraddon;
//   List<Category>? category;
//   List<Items>? items;
//   List<Voucher>? voucher;
//   Future<Dinning>? dinningData;
//   int? selectedCategoryId;
//   Map<String, List<String>> selectedAddonsMap = {};
//   final List<SelectedItems> selectedItemsList = [];
//   List<SelectExtra> selectedExtraAddons = [];
//   KOT? kot;
//   List<KOT> kotList = [];
//   late List<DeviceInfo> deviceinfo;
//   Map<String, Set<String>> selectedSeats = {};
//   Map<String, Set<String>> selectedSeatsWithTableIdMap = {};
//   TextEditingController noteController = TextEditingController();
//   int _sinoCounter = 1;
//   List<OrderList>? orderlist = [];
//   String? selectedTableName;
//   String? selectedChairIdList;
//   List<Voucher>? voucherss;
//   List<KotItem> displayedKotItemss = [];
//   List<KotData>kotDatasrunning=[];
//   List<KOT>FromDbKOTlist=[];
//
//
//   void _handleKOTDataReceived(List<KotData> kotDataList) {
//     setState(() {
//       kotDatasrunning = kotDataList;
//       print("hhhhhhFFF$kotDatasrunning");
//     });
//   }
//   void _handleSavePressed(Map<String, Set<String>> selectedSeatsMap) {
//     setState(() {
//       selectedSeats = selectedSeatsMap;
//       selectedSeatsWithTableIdMap = selectedSeatsMap;
//     });
//   }
//
//   // Future<void> fetchKotData() async {
//   //   try {
//   //     String? baseUrl = await fnGetBaseUrl();
//   //     String apiUrl = '$baseUrl/api/Dinein/getbyid?DeviceId=$DeviceId&IssueCode=$issueCode&Vno=$vno&LedCode=$ledCode&VType=KOT';
//   //
//   //     final response = await http.get(
//   //       Uri.parse(apiUrl),
//   //       headers: {'Content-Type': 'application/json'},
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       final jsonResponse = json.decode(response.body);
//   //       final kotDatas = KotData.fromJson(jsonResponse['Data']['KotData']);
//   //       _handleKOTDataReceived([kotDatas]);
//   //     } else {
//   //       print('Failed to fetch order list from API. Status code: ${response.statusCode}');
//   //     }
//   //   } catch (e) {
//   //     print('Error: $e');
//   //   }
//   // }
//
//   void _handleClosePressed(
//       String tableName, Set<String> seats, String tableId) {
//     setState(() {
//       selectedSeats.remove(tableName);
//       selectedSeats.remove(tableId);
//       selectedSeatsWithTableIdMap.remove(tableId);
//       selectedSeatsWithTableIdMap.remove(tableName);
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//     dinningData = fetchData2();
//     tabController = TabController(length: 4, vsync: this, initialIndex: 0);
//   }
//
//   Future<Dinning> fetchData2() async {
//     DeviceId = await fnGetDeviceId();
//     final String? baseUrl = await fnGetBaseUrl();
//     String apiUrl = '${baseUrl}api/Dinein/alldata';
//
//     try {
//       apiUrl = '$apiUrl?DeviceId=$DeviceId';
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//       );
//       if (response.statusCode == 200) {
//         Dinning dinning = Dinning.fromJson(json.decode(response.body));
//         sqlMessage = dinning.data?.sQLMessage;
//
//         if (sqlMessage?.code == "200") {
//           extraddon = dinning.data?.extraAddOn;
//           category = dinning.data?.category;
//           items = dinning.data?.items;
//           voucher = dinning.data?.voucher;
//           orderlist = dinning.data?.orderlist;
//         }
//         return dinning;
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//       rethrow;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blueGrey,
//           hintColor: Colors.black87,
//         ),
//         darkTheme: ThemeData(
//           brightness: Brightness.dark,
//         ),
//         home: Scaffold(
//           body: LayoutBuilder(
//               builder: (BuildContext context, BoxConstraints constraints) {
//                 bool isPortrait =
//                     MediaQuery.of(context).orientation == Orientation.portrait;
//                 return isPortrait ? buildPortraitLayout() : buildLandscapeLayout();
//               }),
//         ));
//   }
//
//   Widget buildPortraitLayout() {
//     KotProvider kotProviders = Provider.of<KotProvider>(
//       context,
//     );
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blueGrey,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               int currentIndex = tabController.index;
//               if (currentIndex == 0) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const Dashboardpage(),
//                   ),
//                 );
//               }
//             },
//           ),
//           title: Text(widget.employeeName ?? 'Homepage'),
//           centerTitle: true,
//           bottom: TabBar(
//             controller: tabController,
//             indicatorColor: Colors.white,
//             unselectedLabelColor: Colors.black87,
//             labelColor: Colors.white,
//             tabs: const [
//               Tab(text: "Tables"),
//               Tab(text: "CATEGORY"),
//               Tab(text: "ITEMS"),
//               Tab(text: "RUNNING"),
//             ],
//           ),
//         ),
//         body: FutureBuilder<Dinning>(
//           future: dinningData,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.data == null || snapshot.data!.data == null) {
//               return const Center(child: Text('No data available'));
//             } else {
//               Dinning dinning = snapshot.data!;
//               List<OrderList>? orderlist = dinning.data?.orderlist;
//               List<Tables>? tables = dinning.data?.tables;
//               List<Voucher>? voucher = dinning.data?.voucher;
//               return TabBarView(
//                 controller: tabController,
//                 children: [
//                   Center(
//                     child: TablesTab(
//                       tabIndex: 0,
//                       tables: tables,
//                       tabController: tabController,
//                       onSavePressed: _handleSavePressed,
//                       onClosePressed: _handleClosePressed,
//                       orderList: orderlist,
//                     ),
//                   ),
//                   Center(
//                     child: CategoryTab(
//                       category: category,
//                       tabIndex: 1,
//                       tabController: tabController,
//                       onCategorySelected: (categoryId) {
//                         setState(() {
//                           selectedCategoryId = categoryId;
//                         });
//                       },
//                     ),
//                   ),
//                   Center(
//                     child: ItemsTab(
//                       tabIndex: 2,
//                       items: items,
//                       selectedCategoryId: selectedCategoryId,
//                       onItemAdded: (SelectedItems newItem) {
//                         setState(() {
//                           // Assign SINO based on the current length of selectedItemsListee
//                           newItem.SINO =
//                               (selectedItemsList.length + 1).toString();
//                           selectedItemsList.add(newItem);
//                           // Increment SINO counter
//                           _sinoCounter++;
//                           // Update SINO for all items in selectedItemsListee
//                           //updateSinoNumbers();
//                         });
//                       },
//                       removeItemCallback: (double itemId) {
//                         setState(() {
//                           // Remove the item from selectedItemsListee
//                           selectedItemsList
//                               .removeWhere((item) => item.itemId == itemId);
//                           // Decrement SINO counter
//                           _sinoCounter--;
//                           // Update SINO for all items in selectedItemsListee
//                           // updateSinoNumbers();
//                         });
//                       },
//                     ),
//                   ),
//                   Center(
//                     child: RunningTab(
//                       orderList: orderlist,
//                       tabIndex: 3,
//                       voucher: voucher,
//                       tabController: tabController,
//                       onKOTDataReceived: _handleKOTDataReceived,
//                     ),
//                   )
//                 ],
//               );
//             }
//           },
//         ),
//         bottomNavigationBar: SingleChildScrollView(
//           child: Container(
//             child: Card(
//               color: Colors.white70,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         const Text(
//                           "KOT:",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         const Spacer(),
//                         SizedBox(
//                           width: 400,
//                           child: Center(
//                             child: Consumer<SelectedItemsProvider>(
//                               builder: (context, provider, _) {
//                                 return Text(
//                                   provider.DisplayTbSc,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(thickness: 2, color: Colors.black87),
//                     SizedBox(
//                       width: double.infinity,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 20,
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Text(
//                                         "Item",
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     Spacer(),
//                                     Padding(
//                                       padding: EdgeInsets.all(5.0),
//                                       child: Text(
//                                         "Quadity",
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Text(
//                                         "Rate",
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 20,
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Text(
//                                         "Total",
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 50),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 280,
//                                   child: ListView.builder(
//                                     itemCount:
//                                     kotProviders.selectedItemsListee.length,
//                                     itemBuilder: (context, index) {
//                                       SelectedItems selectedItem = kotProviders
//                                           .selectedItemsListee[index];
//                                       return ListTile(
//                                         title: Row(
//                                           children: [
//                                             InkWell(
//                                               onTap: () {
//                                                 showExtraAddonDialog(
//                                                   context,
//                                                   extraddon!,
//                                                   selectedItem,
//                                                 );
//                                               },
//                                               child: SizedBox(
//                                                 width: 200,
//                                                 child: Text(
//                                                   selectedItem.name,
//                                                   overflow:
//                                                   TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                             const Spacer(),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   right: 50),
//                                               child: SizedBox(
//                                                 width: 50,
//                                                 child: Center(
//                                                   child: DropdownButton<int>(
//                                                     value:
//                                                     selectedItem.quantity,
//                                                     // Use the selected quantity from the item
//                                                     onChanged:
//                                                         (int? newQuantity) {
//                                                       // Update the selected quantity if it is not null
//                                                       if (newQuantity != null) {
//                                                         setState(() {
//                                                           selectedItem
//                                                               .quantity =
//                                                               newQuantity;
//                                                           // Update the itemtotal based on the new quantity
//                                                           selectedItem
//                                                               .NetAmount =
//                                                               selectedItem
//                                                                   .sRate *
//                                                                   newQuantity;
//                                                         });
//                                                       }
//                                                     },
//                                                     items: List.generate(10,
//                                                             (index) {
//                                                           // Generate dropdown menu items for quantities 1 to 10
//                                                           return DropdownMenuItem<
//                                                               int>(
//                                                             value: index + 1,
//                                                             child: Text((index + 1)
//                                                                 .toString()),
//                                                           );
//                                                         }),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   right: 60),
//                                               child: Text(selectedItem.sRate
//                                                   .toString()),
//                                             ),
//                                             Text(
//                                                 selectedItem.NetAmount
//                                                     .toString(),
//                                                 style: const TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w700)),
//                                             const SizedBox(width: 10),
//                                             IconButton(
//                                               icon: const Icon(Icons.delete),
//                                               onPressed: () {
//                                                 final selectedItemsProvider =
//                                                 Provider.of<
//                                                     KotProvider>(
//                                                     context,
//                                                     listen: false);
//                                                 selectedItemsProvider
//                                                     .removeSelectedItemone(
//                                                     selectedItem.name);
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                         subtitle: buildSelectExtras(
//                                             selectedItem.selectextra),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 40,
//                                   child: Row(
//                                     children: [
//                                       const Spacer(),
//                                       const Text("Total : ",
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                           )),
//                                       const SizedBox(width: 5),
//                                       Text("${kotProviders.OverallTotal(kotProviders.selectedItemsListee)}",
//                                           style: const TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                           )),
//                                       const SizedBox(
//                                         width: 80,
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       child: Row(
//                         children: [
//                           Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(17.0),
//                             ),
//                             elevation: 5,
//                             child: IconButton(
//                               iconSize: 30,
//                               icon: const Icon(
//                                 Icons.add,
//                               ),
//                               onPressed: () {},
//                             ),
//                           ),
//                           Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(17.0),
//                             ),
//                             elevation: 5,
//                             child: IconButton(
//                               iconSize: 30,
//                               icon: const Icon(
//                                 Icons.remove,
//                               ),
//                               onPressed: () {},
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 100,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     title: const Text("Enter Note"),
//                                     content: TextField(
//                                       controller: noteController,
//                                       decoration: const InputDecoration(
//                                           hintText: "Type your note here"),
//                                     ),
//                                     actions: <Widget>[
//                                       TextButton(
//                                         child: const Text("OK"),
//                                         onPressed: () {
//                                           Navigator.of(context)
//                                               .pop(); // Dismiss the dialog
//                                         },
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               );
//                             },
//                             child: const Card(
//                               color: Colors.black87,
//                               child: Padding(
//                                 padding: EdgeInsets.all(15.0),
//                                 child: Text(
//                                   "NOTE",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 final selectedItemsProvider =
//                                 //      Provider.of<KotProvider>(context,
//                                 //          listen: false);
//                                 //  selectedItemsProvider.clearSelectedItemsclear();
//                                 //  final selectedKOTProvider =
//                                 //      Provider.of<KotProvider>(context,
//                                 //          listen: false);
//                                 // selectedKOTProvider.clearSelectedItemsListee();
//                                 noteController.clear();
//                                 selectedSeats.clear();
//                                 selectedItemsList
//                                     .clear(); // Pass the index as a parameter
//                               });
//                             },
//                             child: const Card(
//                               color: Colors.black87,
//                               child: Padding(
//                                 padding: EdgeInsets.all(15.0),
//                                 child: Text(
//                                   "CLEAR",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 30,
//                           ),
//                           const Icon(Icons.print, size: 35),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               KotProvider kotProvider = Provider.of<KotProvider>(context, listen: false);
//                               KOT kotDataToSend = kotProvider.SendingKotToDb(selectedSeats);
//                               kotProvider.UpdateselectedItemsRtoS();
//                               kotDataToSend.TableId = selectedSeats.keys.firstWhere((key) => key.startsWith(RegExp(r'[0-9]')), orElse: () => '');
//                               kotDataToSend.TableSeat = selectedSeats.values.where((seats) => seats.isNotEmpty).map((seats) => seats.join(",")).join(', ');
//                               kotDataToSend.EmployeeId = widget.employeeId.toString();
//
//                               String? baseUrl = await fnGetBaseUrl();
//                               String apiUrl = '$baseUrl/api/Dinein/saveKOT?DeviceId=${kotProvider.deviceId}';
//
//                               try {
//                                 final response = await http.post(
//                                   Uri.parse(apiUrl),
//                                   headers: {'Content-Type': 'application/json'},
//                                   //body: jsonEncode(kotDataToSend.toJson()), // Assuming kotDataToSend is serializable
//                                 );
//
//                                 if (response.statusCode == 200) {
//                                   var jsonResponse = json.decode(response.body);
//                                   print(jsonResponse);
//                                 } else {
//                                   print('Failed to save KOT. Status code: ${response.statusCode}');
//                                 }
//                               } catch (e) {
//                                 print('Error: $e');
//                               }
//                             },
//                             child: const Card(
//                               color: Colors.black87,
//                               child: Padding(
//                                 padding: EdgeInsets.all(10.0),
//                                 child: Text(
//                                   "   KOT  ",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
//
//   Widget buildLandscapeLayout() {
//     SelectedItemsProvider selectedItemsProvider =
//     Provider.of<SelectedItemsProvider>(
//       context,
//     );
//     KotProvider kotProviders = Provider.of<KotProvider>(
//       context,
//     );
//     return Row(
//       children: [
//         Expanded(
//           child: Card(
//             color: Colors.white70,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "KOT:",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Spacer(),
//                       SizedBox(
//                         width: 300,
//                         child: Center(
//                           child: Consumer<SelectedItemsProvider>(
//                             builder: (context, provider, _) {
//                               return Text(
//                                 provider.DisplayTbSc,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   Divider(thickness: 2, color: Colors.black87),
//                   SizedBox(
//                     width: double.infinity,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Row(
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 20, right: 10, bottom: 0, top: 0),
//                                     child: Text(
//                                       "Item",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   Spacer(),
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 20, right: 20, bottom: 0, top: 0),
//                                     child: Text(
//                                       "Qty",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                     EdgeInsets.only(left: 5, right: 10),
//                                     child: Text(
//                                       "Rate",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 0, right: 0),
//                                     child: Text(
//                                       "Total",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 60),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 300,
//                                 child: ListView.builder(
//                                   itemCount: selectedItemsProvider
//                                       .selectedItemsList.length,
//                                   itemBuilder: (context, index) {
//                                     SelectedItems selectedItem =
//                                     selectedItemsProvider
//                                         .selectedItemsList[index];
//
//                                     return ListTile(
//                                       title: Row(
//                                         children: [
//                                           // Display item name
//                                           InkWell(
//                                             onTap: () {
//                                               showExtraAddonDialog(
//                                                 context,
//                                                 extraddon!,
//                                                 selectedItem,
//                                               );
//                                             },
//                                             child: SizedBox(
//                                               width: 150,
//                                               child: Text(
//                                                 selectedItem.name,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 10,
//                                           ),
//                                           // Dropdown button for selecting quantity
//                                           SizedBox(
//                                             width: 50,
//                                             child: Center(
//                                               child: DropdownButton<int>(
//                                                 value: selectedItem.quantity,
//                                                 // Use the selected quantity from the item
//                                                 onChanged: (int? newQuantity) {
//                                                   // Update the selected quantity if it is not null
//                                                   if (newQuantity != null) {
//                                                     setState(() {
//                                                       selectedItem.quantity =
//                                                           newQuantity;
//                                                       // Update the itemtotal based on the new quantity
//                                                       selectedItem.NetAmount =
//                                                           selectedItem.sRate *
//                                                               newQuantity;
//                                                     });
//                                                   }
//                                                 },
//                                                 items:
//                                                 List.generate(10, (index) {
//                                                   // Generate dropdown menu items for quantities 1 to 10
//                                                   return DropdownMenuItem<int>(
//                                                     value: index + 1,
//                                                     child: Text(
//                                                         (index + 1).toString()),
//                                                   );
//                                                 }),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 10),
//                                           // Display sRate
//                                           Text(selectedItem.sRate.toString()),
//                                           const SizedBox(width: 5),
//                                           // Display NetAmount
//                                           Text(
//                                             selectedItem.NetAmount.toString(),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.w700),
//                                           ),
//                                           // Button for deleting item
//                                           IconButton(
//                                             icon: const Icon(Icons.delete),
//                                             iconSize: 23,
//                                             onPressed: () {
//                                               final selectedItemsProvider =
//                                               Provider.of<
//                                                   SelectedItemsProvider>(
//                                                   context,
//                                                   listen: false);
//                                               // Remove the selected item by its name
//                                               selectedItemsProvider
//                                                   .removeSelectedItem(
//                                                   selectedItem.name);
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                       subtitle: buildSelectExtras(
//                                           selectedItem.selectextra),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               const Divider(),
//                               SizedBox(
//                                 height: 30,
//                                 child: Row(
//                                   children: [
//                                     const Spacer(),
//                                     const Text(
//                                       "Total : ",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       " ",
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 70,
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               height: 50,
//                               width: 50,
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(17.0),
//                                 ),
//                                 elevation: 5,
//                                 child: IconButton(
//                                   iconSize: 25,
//                                   icon: const Center(
//                                     child: Icon(
//                                       Icons.add,
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     // Implement your logic
//                                   },
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 50,
//                               width: 50,
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(17.0),
//                                 ),
//                                 elevation: 5,
//                                 child: IconButton(
//                                   iconSize: 25,
//                                   icon: const Center(
//                                     child: Icon(
//                                       Icons.remove,
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     // Implement your logic
//                                   },
//                                 ),
//                               ),
//                             ),
//                             const Spacer(),
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   final selectedItemsProvider =
//                                   Provider.of<SelectedItemsProvider>(
//                                       context,
//                                       listen: false);
//                                   selectedItemsProvider
//                                       .clearSelectedItemsclear();
//                                   noteController.clear();
//                                   selectedSeats.clear();
//                                   selectedItemsList
//                                       .clear(); // Pass the index as a parameter
//                                 });
//                               },
//                               child: const Card(
//                                 color: Colors.black87,
//                                 child: Padding(
//                                   padding: EdgeInsets.all(12.0),
//                                   child: Text(
//                                     "CLEAR",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       title: const Text("Enter Note"),
//                                       content: TextField(
//                                         controller: noteController,
//                                         decoration: const InputDecoration(
//                                             hintText: "Type your note here"),
//                                       ),
//                                       actions: <Widget>[
//                                         TextButton(
//                                           child: const Text("OK"),
//                                           onPressed: () {
//                                             Navigator.of(context)
//                                                 .pop(); // Dismiss the dialog
//                                           },
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                               child: const Card(
//                                 color: Colors.black87,
//                                 child: Padding(
//                                   padding: EdgeInsets.all(10.0),
//                                   child: Text("NOTE",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white)),
//                                 ),
//                               ),
//                             ),
//                             const Icon(Icons.print, size: 35),
//                             const SizedBox(
//                               width: 20,
//                             ),
//                             // GestureDetector(
//                             //   onTap: () async {
//                             //     // Get the current KotProvider instance
//                             //     KotProvider kotProvider = Provider.of<KotProvider>(context, listen: false);
//                             //
//                             //     // Call the method to send KOT data to the database
//                             //     kotProvider.SendingKotToDb();
//                             //
//                             //     // Get the base URL
//                             //     String? baseUrl = await fnGetBaseUrl();
//                             //
//                             //     // Construct the API URL
//                             //     String apiUrl = '$baseUrl/api/Dinein/saveKOT?DeviceId=${kotProvider.DeviceId}';
//                             //
//                             //     // Convert kotData to JSON format
//                             //     String kotJson = jsonEncode(kotProvider.kotData.toJson());
//                             //
//                             //     try {
//                             //       // Make the POST request to the API
//                             //       final response = await http.post(
//                             //         Uri.parse(apiUrl),
//                             //         headers: {'Content-Type': 'application/json'},
//                             //         body: kotJson,
//                             //       );
//                             //
//                             //       if (response.statusCode == 200) {
//                             //         var jsonResponse = json.decode(response.body);
//                             //         print(jsonResponse);
//                             //       } else {
//                             //         print('Failed to save KOT. Status code: ${response.statusCode}');
//                             //       }
//                             //     } catch (e) {
//                             //       print('Error: $e');
//                             //     }
//                             //   },
//                             //   child: const Card(
//                             //     color: Colors.black87,
//                             //     child: Padding(
//                             //       padding: EdgeInsets.all(10.0),
//                             //       child: Text(
//                             //         "   KOT  ",
//                             //         style: TextStyle(
//                             //           color: Colors.white,
//                             //           fontWeight: FontWeight.bold,
//                             //         ),
//                             //       ),
//                             //     ),
//                             //   ),
//                             // ),
//                             const SizedBox(
//                               width: 20,
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: double.infinity,
//           width: 600,
//           child: Scaffold(
//             appBar: AppBar(
//               backgroundColor: Colors.blueGrey,
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () {
//                   int currentIndex = tabController.index;
//                   if (currentIndex == 0) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const Dashboardpage(),
//                       ),
//                     );
//                   }
//                 },
//               ),
//               title: Text(widget.employeeName ?? 'Homepage'),
//               centerTitle: true,
//               bottom: TabBar(
//                 controller: tabController,
//                 indicatorColor: Colors.white,
//                 unselectedLabelColor: Colors.black87,
//                 labelColor: Colors.white,
//                 tabs: const [
//                   Tab(text: "Tables"),
//                   Tab(text: "CATEGORY"),
//                   Tab(text: "ITEMS"),
//                   Tab(text: "RUNNING"),
//                 ],
//               ),
//             ),
//             body: Expanded(
//               child: FutureBuilder<Dinning>(
//                 future: dinningData,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (snapshot.data == null ||
//                       snapshot.data!.data == null) {
//                     return const Center(child: Text('No data available'));
//                   } else {
//                     Dinning dinning = snapshot.data!;
//                     List<OrderList>? orderlist = dinning.data?.orderlist;
//                     List<Tables>? tables = dinning.data?.tables;
//                     List<Voucher>? voucher = dinning.data?.voucher;
//
//                     return TabBarView(
//                       controller: tabController,
//                       children: [
//                         Center(
//                           child: TablesTab(
//                             tabIndex: 0,
//                             tables: tables,
//                             tabController: tabController,
//                             onSavePressed: _handleSavePressed,
//                             onClosePressed: _handleClosePressed,
//                             orderList: orderlist,
//                           ),
//                         ),
//                         Center(
//                           child: CategoryTab(
//                             category: category,
//                             tabIndex: 1,
//                             tabController: tabController,
//                             onCategorySelected: (categoryId) {
//                               setState(() {
//                                 selectedCategoryId = categoryId;
//                               });
//                             },
//                           ),
//                         ),
//                         Center(
//                           child: ItemsTab(
//                             tabIndex: 2,
//                             items: items,
//                             selectedCategoryId: selectedCategoryId,
//                             onItemAdded: (SelectedItems newItem) {
//                               setState(() {
//                                 // Assign SINO based on the current length of selectedItemsListee
//                                 newItem.SINO =
//                                     (selectedItemsList.length + 1).toString();
//                                 selectedItemsList.add(newItem);
//                                 // Increment SINO counter
//                                 _sinoCounter++;
//                                 // Update SINO for all items in selectedItemsListee
//                                 //updateSinoNumbers();
//                               });
//                             },
//                             removeItemCallback: (double itemId) {
//                               setState(() {
//                                 // Remove the item from selectedItemsListee
//                                 selectedItemsList.removeWhere(
//                                         (item) => item.itemId == itemId);
//                                 // Decrement SINO counter
//                                 _sinoCounter--;
//                                 // Update SINO for all items in selectedItemsListee
//                                 // updateSinoNumbers();
//                               });
//                             },
//                           ),
//                         ),
//                         Center(
//                           child: RunningTab(
//                             orderList: orderlist,
//                             tabIndex: 3,
//                             voucher: voucher,
//                             tabController: tabController,
//                             onKOTDataReceived: _handleKOTDataReceived,
//                           ),
//                         )
//                       ],
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
//
