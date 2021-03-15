import 'package:happy_hour_server/server/router.dart';

abstract class Server {

	Router router = Router();

	void onInit();

}