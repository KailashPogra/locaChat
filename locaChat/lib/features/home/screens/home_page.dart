import 'package:locachat/common/widgets/custom_button.dart';
import 'package:locachat/constants/api_url.dart';
import 'package:locachat/constants/custom_frature.dart';
import 'package:locachat/data/response/status.dart';
import 'package:locachat/features/chat/screen/chat_screen.dart';
import 'package:locachat/provider/home_screen_provider.dart';
import 'package:locachat/repository/user_status_repo.dart';
import 'package:locachat/sarvices/location_sarvices.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  const HomeScreen(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UserStatusRepo statusRepo = UserStatusRepo();
  final HomeScreenProvider _homeScreenProvider = HomeScreenProvider();
  final LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();
    fetchAndSendLocation();
    WidgetsBinding.instance.addObserver(this);
    Map<String, dynamic> data1 = {
      "isOnline": true,
      "latitude": locationService.latitude!,
      "longitude": locationService.longitude!,
    };
    statusRepo.userStatusApi(data1);
  }

  // Fetches the device's current location and sends it to the API
  void fetchAndSendLocation() async {
    try {
      _homeScreenProvider.getNearbyUserApi(widget.latitude, widget.longitude);
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  Future<void> apis() async {
    fetchAndSendLocation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Map<String, dynamic> data = {
      "isOnline": false,
      "latitude": locationService.latitude!,
      "longitude": locationService.longitude!,
    };
    Map<String, dynamic> data1 = {
      "isOnline": true,
      "latitude": locationService.latitude!,
      "longitude": locationService.longitude!,
    };
    if (state == AppLifecycleState.resumed) {
      //user is online
      statusRepo.userStatusApi(data1);
      print("online.............................");
    } else {
      print("offline----------------------------");
      statusRepo.userStatusApi(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(60), // Set the preferred size of the AppBar
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10), // Make the bottom corners circular
              ),
              border: Border.all(
                color: hexToColor("41327E"), // Border color
                width: 2, // Border width
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0, // Remove shadow
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: kHeight(5, context),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    "assets/images/locaChat.png",
                    height: kHeight(2.9, context),
                  ),
                ],
              ),
              centerTitle: true, // Center align title
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: apis,
          child: ChangeNotifierProvider<HomeScreenProvider>(
            create: (BuildContext context) => _homeScreenProvider,
            child: Consumer<HomeScreenProvider>(
              builder: (context, value, _) {
                switch (value.nearByUserList.status) {
                  case Status.LOADING:
                    return const Center(child: CircularProgressIndicator());
                  case Status.ERROR:
                    return Center(
                        child: Text(value.nearByUserList.massage.toString()));

                  case Status.COMPLETED:
                    return ListView.builder(
                        itemCount:
                            value.nearByUserList.data!.nearbyUsers!.length,
                        itemBuilder: (context, int index) {
                          print(value.nearByUserList.data!.nearbyUsers!.length);
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: kHeight(25, context),
                                    width: kWidth(80, context),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              width: 15,
                                              height: 15,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: kHeight(10, context),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.network(
                                              "$baseUrl/${value.nearByUserList.data!.nearbyUsers![index].profileImage}",
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                // If there's an error loading the network image (e.g., 404), display the asset image instead
                                                return Image.asset(
                                                  "assets/images/profile.png",
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          value.nearByUserList.data!
                                                  .nearbyUsers![index].name
                                                  .toString() +
                                              " is online",
                                          style: const TextStyle(
                                            fontSize:
                                                16, // adjust the font size as needed
                                            fontWeight: FontWeight
                                                .bold, // adjust the font weight as needed

                                            decorationStyle: TextDecorationStyle
                                                .double, // adjust the decoration style as needed
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        ElevatedButton.icon(
                                          icon: const Icon(
                                              Icons.chat), // Chat icon
                                          label: const Text('Chat'),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen(
                                                          receiverId: value
                                                              .nearByUserList
                                                              .data!
                                                              .nearbyUsers![
                                                                  index]
                                                              .sId
                                                              .toString(),
                                                          senderId: value
                                                              .nearByUserList
                                                              .data!
                                                              .senderId
                                                              .toString(),
                                                          imageUrl: value
                                                              .nearByUserList
                                                              .data!
                                                              .nearbyUsers![
                                                                  index]
                                                              .profileImage
                                                              .toString(),
                                                          name: value
                                                              .nearByUserList
                                                              .data!
                                                              .nearbyUsers![
                                                                  index]
                                                              .name
                                                              .toString(),
                                                        )));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  default:
                    return Container();
                }
              },
            ),
          ),
        ));
  }
}
