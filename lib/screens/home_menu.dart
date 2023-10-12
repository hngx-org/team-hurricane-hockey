import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_hurricane_hockey/enums.dart';
import 'package:team_hurricane_hockey/models/user.dart';
import 'package:team_hurricane_hockey/models/waitlist_req.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/game_screen.dart';
import 'package:team_hurricane_hockey/services/firebase/game_service.dart';
import 'package:team_hurricane_hockey/services/firebase/user_query.dart';
import 'package:team_hurricane_hockey/services/firebase/waitlist_query.dart';
import 'package:team_hurricane_hockey/services/google_service.dart';
import 'package:team_hurricane_hockey/services/local_storage.dart';
import 'package:uuid/uuid.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});
  static const routeName = 'home';

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  final user = AppStorage.instance.getUserData();
  loadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(height: 30),
                Text(
                  'LOOKING FOR PLAYERS ONLINE',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> wailistDialog() async {
    final s = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ONLINE PLAYERS',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 500.h,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("waitlist").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return Container(
                          height: 30,
                          color: Colors.red,
                        );
                      }

                      if (snapshot.hasData) {
                        Waitlist? userWaitlist;
                        for (var element in snapshot.data?.docs ?? []) {
                          final data = Waitlist.fromJson(element.data());

                          if (data.id == user?.id) {
                            userWaitlist = data;
                          }
                        }
                        return ListView.builder(
                          itemCount: snapshot.data?.size,
                          itemBuilder: (context, index) {
                            final snapData = snapshot.data?.docs[index].data();
                            final data = Waitlist.fromJson(snapData!);

                            if (data.id == user?.id) {
                              userWaitlist = data;
                            }

                            if (data.id == user?.id) {
                              userWaitlist = data;
                              return const SizedBox.shrink();
                            }

                            if (userWaitlist != null) {
                              if (userWaitlist!.gameId != null) {
                                if (userWaitlist?.gameId == data.gameId) {
                                  BaseNavigator.pop({
                                    "status": true,
                                    "gameId": data.gameId,
                                    "opponentId": data.id,
                                    "opponentName": data.name,
                                  });
                                }
                              }
                            }

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () async {
                                final id = const Uuid().v1();
                                await WaitlistQuery.instance.sendRequest(user!.id!, data.id!, id);
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Image.network(
                                  data.image ?? "",
                                  height: 36,
                                  width: 36,
                                ),
                              ),
                              title: Text(
                                data.name ?? "",
                                style: GoogleFonts.tektur(
                                  fontSize: 20.0.sp,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Builder(builder: (context) {
                                if (data.accepterId == user?.id) {
                                  return Text(
                                    "You have a game request from this user",
                                    style: GoogleFonts.tektur(
                                      fontSize: 14.0.sp,
                                      color: Colors.black,
                                    ),
                                  );
                                }

                                return Text(
                                  data.isReady == true ? "Ready" : "Not ready",
                                  style: GoogleFonts.tektur(
                                    fontSize: 14.0.sp,
                                    color: Colors.black,
                                  ),
                                );
                              }),
                              trailing: Builder(builder: (context) {
                                if (data.accepterId == user?.id) {
                                  return IconButton(
                                    onPressed: () async {
                                      await WaitlistQuery.instance.sendRequest(
                                        user!.id!,
                                        data.id!,
                                        data.gameId!,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  );
                                }

                                return const SizedBox.shrink();
                              }),
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );

    if (s != null) {
      return s;
    }

    return null;
  }

  ValueNotifier searchingOnline = ValueNotifier(false);

  Future<UserData?> googleLogin() async {
    try {
      await AuthRepository.instance.logOut();

      final result = await AuthRepository.instance.googleAuth();
      if (result.item1 != null) {
        final data = result.item1;
        assert(data!.email != null);
        assert(data!.displayName != null);
        assert(data!.uid.isNotEmpty);

        UserData userData = UserData(
          email: data?.email,
          name: data?.displayName,
          image: data?.photoURL,
          id: data?.uid,
        );

        final s = await UserQuery.instance.saveUser(userData);

        if (s) {
          AppStorage.instance.saveUser(userData.toJson());
          return userData;
        }

        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.black,
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/retro_BG.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.fromLTRB(24.0.w, 24.0.h, 24.0.w, 0.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  FittedBox(
                    child: Text(
                      'HOCKEY\n\nCHALLENGE',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInRightBig(
                          duration: const Duration(milliseconds: 200),
                          child: TextButton(
                            onPressed: () {
                              BaseNavigator.pushNamed(
                                GameScreen.routeName,
                                args: {
                                  "mode": GameMode.ai,
                                },
                              );
                            },
                            child: Text(
                              'VS AI',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0.h),
                        FadeInRightBig(
                          duration: const Duration(milliseconds: 400),
                          child: TextButton(
                            onPressed: () async {
                              // AppStorage.instance.clearUser();

                              if (user == null) {
                                final data = await googleLogin();
                                if (data != null) {}
                              } else {
                                Waitlist waitlist = Waitlist(
                                  name: user?.name,
                                  id: user?.id,
                                  image: user?.image,
                                  email: user?.email,
                                  isReady: true,
                                );
                                final s = await WaitlistQuery.instance.checkIntoWaitlist(
                                  waitlist,
                                  user!.id!,
                                );
                                if (s) {
                                  final s = await wailistDialog();
                                  if (s != null) {
                                    await WaitlistQuery.instance.deleteUserOnWaitlist(user!.id!);
                                    final gameCreation = await GameService.instance.createGame(
                                      s["gameId"],
                                      s["opponentId"],
                                      s["opponentName"],
                                      user!.id!,
                                      user!.name!,
                                    );

                                    if (gameCreation) {
                                      BaseNavigator.pushNamed(
                                        GameScreen.routeName,
                                        args: {
                                          "gameId": s["gameId"],
                                          "mode": GameMode.multiplayer,
                                          "opponentId": s["opponentId"],
                                          "playerId": user!.id!,
                                        },
                                      );
                                    }
                                  }
                                }
                              }
                            },
                            child: Text(
                              'MULTIPLAYER',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0.h),
                        FadeInRightBig(
                          duration: const Duration(milliseconds: 400),
                          child: TextButton(
                            onPressed: () {
                              BaseNavigator.pushNamed(
                                GameScreen.routeName,
                                args: {
                                  "mode": GameMode.player2,
                                },
                              );
                            },
                            child: Text(
                              'VS PLAYER 2',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0.h),
                        FadeInRightBig(
                          duration: const Duration(milliseconds: 800),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Settings',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: 100.0.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
