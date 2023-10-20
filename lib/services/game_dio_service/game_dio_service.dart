import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:team_hurricane_hockey/models/server/base.dart';

part 'game_dio_service.g.dart';

@RestApi(baseUrl: "https://game-socket-a6hv.onrender.com/")
abstract class GameDioService {
  factory GameDioService(Dio dio, {String baseUrl}) = _GameDioService;

  @GET("game-create")
  Future<BaseResponse> createGame();
}
