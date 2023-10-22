import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_hurricane_hockey/models/user.dart';
import 'package:team_hurricane_hockey/models/waitlist_req.dart';
import 'package:team_hurricane_hockey/repository/game_dio_repository.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/services/firebase/game_service.dart';
import 'package:team_hurricane_hockey/services/firebase/waitlist_query.dart';

class HomeOverlays {
  final _gameDioRepo = GameDioRepo.instance;

  static loadingDialog() {
    showDialog(
      context: BaseNavigator.currentContext,
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

  Future<dynamic> wailistDialog(UserData user) async {
    ValueNotifier loading = ValueNotifier(false);

    final s = await showDialog(
      context: BaseNavigator.currentContext,
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
                      bool acceptedConstraint = false;
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

                          if (data.id == user.id) {
                            userWaitlist = data;
                          }

                          if (data.accepted == user.id) {
                            acceptedConstraint = true;
                          }
                        }
                        return ListView.builder(
                          itemCount: snapshot.data?.size,
                          itemBuilder: (context, index) {
                            final snapData = snapshot.data?.docs[index].data();
                            final data = Waitlist.fromJson(snapData!);

                            if (data.id == user.id) {
                              userWaitlist = data;
                              return const SizedBox.shrink();
                            }

                            if (userWaitlist != null) {
                              if (userWaitlist!.gameId != null && data.accepted == user.id) {
                                BaseNavigator.pop({
                                  "status": true,
                                  "gameId": userWaitlist!.gameId,
                                  "opponentId": data.id,
                                  "opponentName": data.name,
                                  "player2": true,
                                });
                              }
                            }

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () async {
                                if (data.request == user.id || acceptedConstraint) {
                                  return;
                                }

                                await WaitlistQuery.instance.sendRequest(
                                  user.id!,
                                  data.id!,
                                );
                              },
                              leading: SizedBox(
                                height: 36,
                                width: 36,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: Image.network(
                                    data.image ?? "",
                                    height: 36,
                                    width: 36,
                                  ),
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
                                if (data.request == user.id) {
                                  return Text(
                                    "You have a game request from this user",
                                    style: GoogleFonts.tektur(
                                      fontSize: 14.0.sp,
                                      color: Colors.black,
                                    ),
                                  );
                                }

                                if (data.accepted == user.id) {
                                  return Text(
                                    "This user has accepted your game request. \nThe game will begin shortly",
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
                                if (data.request == user.id || acceptedConstraint) {
                                  return ValueListenableBuilder(
                                    valueListenable: loading,
                                    builder: (context, sending, _) {
                                      if (sending) {
                                        return const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return IconButton(
                                        onPressed: () async {
                                          try {
                                            loading.value = true;

                                            await WaitlistQuery.instance.acceptRequest(
                                              user.id!,
                                              data.id!,
                                            );

                                            final s = await _gameDioRepo.createGame();
                                            if (s != null) {
                                              final gameCreation = await GameService.instance.createGame(
                                                s.toString(),
                                                data.id!,
                                                data.name!,
                                                user.id!,
                                                user.name!,
                                              );

                                              if (gameCreation) {
                                                final sendCode = await WaitlistQuery.instance.sendGameId(data.id!, s.toString());
                                                if (sendCode) {
                                                  BaseNavigator.pop({
                                                    "status": false,
                                                    "gameId": s,
                                                    "opponentId": data.id,
                                                    "opponentName": data.name,
                                                  });
                                                }
                                              }
                                            }
                                            loading.value = false;
                                          } catch (e) {
                                            loading.value = false;
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                      );
                                    },
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
}
