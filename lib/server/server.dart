import 'package:happy_hour_server/server/router.dart';

abstract class Server {

	Router router = Router();

	void onInit();

}

abstract class ServerV2 {

	final RouterV2 router = RouterV2();

	void onInit();

}