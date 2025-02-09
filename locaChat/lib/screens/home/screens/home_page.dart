import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:swipe_cards/swipe_cards.dart';
import 'package:locachat/constants/api_url.dart';
import 'package:locachat/constants/custom_feature.dart';
import 'package:locachat/data/response/status.dart';
import 'package:locachat/screens/chat/screen/chat_screen.dart';
import 'package:locachat/provider/home_screen_provider.dart';
import 'package:locachat/repository/user_status_repo.dart';
import 'package:locachat/sarvices/location_sarvices.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  UserStatusRepo statusRepo = UserStatusRepo();
  final HomeScreenProvider _homeScreenProvider = HomeScreenProvider();
  final LocationService locationService = LocationService();
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _homeScreenProvider.setLocationName();
    _homeScreenProvider.fetchAndSendLocation(context);
    WidgetsBinding.instance.addObserver(this);

    statusRepo.userStatusApi(_homeScreenProvider.data(true));
  }

  // Fetches the device's current location and sends it to the API

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _homeScreenProvider.data(true);
      //   print("online.............................");
    } else {
      //  print("offline----------------------------");
      statusRepo.userStatusApi(_homeScreenProvider.data(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                // Border color
                width: 2, // Border width
              ),
            ),
            child: AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              automaticallyImplyLeading: false,

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
        body: ChangeNotifierProvider<HomeScreenProvider>(
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
                  return RefreshIndicator(
                    onRefresh: () =>
                        _homeScreenProvider.fetchAndSendLocation(context),
                    child: Stack(
                      children: [
                        ListWheelScrollView(
                          itemExtent: kHeight(45, context),
                          children: List.generate(
                              value.nearByUserList.data!.nearbyUsers!.length,
                              (index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    height: kHeight(43, context),
                                    width: kWidth(80, context),
                                    decoration: BoxDecoration(
                                      color: Colors.amberAccent,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          spreadRadius: 5,
                                          offset: Offset(0, 3),
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
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: kHeight(25, context),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "$baseUrl/${value.nearByUserList.data!.nearbyUsers![index].profileImage}",
                                            errorWidget:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                "assets/images/profile.png",
                                                fit: BoxFit.fill,
                                              );
                                            },
                                            placeholder: (context, url) =>
                                                const SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${value.nearByUserList.data!.nearbyUsers![index].name}",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                decorationStyle:
                                                    TextDecorationStyle.double,
                                              ),
                                            ),
                                            SizedBox(
                                              width: kWidth(2, context),
                                            ),
                                            const Text(
                                              "is online",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                decorationStyle:
                                                    TextDecorationStyle.double,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: kHeight(1, context),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: kWidth(2, context)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  icon: const Icon(
                                                      Icons.chat), // Chat icon
                                                  label: const Text('Chat'),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
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
                                              ),
                                              SizedBox(
                                                width: kWidth(5, context),
                                              ),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  icon: const Icon(Icons
                                                      .heart_broken), // Chat icon
                                                  label: const Text('Like'),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
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
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        Consumer<HomeScreenProvider>(
                            builder: (context, value, _) {
                          return Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    value.setLocationName();
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(" location"),
                                      Icon(Icons.location_history),
                                    ],
                                  )),
                              value.location == null
                                  ? const Text("")
                                  : Text(
                                      value.location.toString(),
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: kHeight(1.2, context)),
                                    ),
                            ],
                          );
                        })
                      ],
                    ),
                  );
                default:
                  return Container();
              }
            },
          ),
        ));
  }
}
