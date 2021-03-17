import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auth.dart';
import 'package:happy_hour_server/persistance/model/user.dart';
import 'package:happy_hour_server/server/runner.dart';
import 'package:happy_hour_server/server/server.dart';

import 'api/register.dart';
import 'api/v1.dart';
import 'api/v1/auction.dart';
import 'api/v1/auctions.dart';
import 'api/v1/auth.dart';
import 'api/v1/user.dart';
import 'filters/logged.dart';

class MyServer extends Server {

	@override
	void onInit() {
		router.addRoute('/api/v1/auctions', filters: [FilterLogged()], dispatcher: ApiV1Auctions());
		router.addRoute('/api/v1/auction', filters: [FilterLogged()], dispatcher: ApiV1Auction());
		router.addRoute('/api/v1/user', filters: [FilterLogged()], dispatcher: ApiV1User());
		router.addRoute('/api/v1/auth', filters: [FilterLogged()], dispatcher: ApiV1Auth());
		router.addRoute('/api/register', dispatcher: ApiRegister());
		router.addRoute('/api/v1', filters: [FilterLogged()], dispatcher: ApiV1());
	}

}

Future main() => runServer(MyServer());