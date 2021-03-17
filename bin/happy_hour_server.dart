import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auth.dart';
import 'package:happy_hour_server/persistance/model/user.dart';
import 'package:happy_hour_server/server/runner.dart';
import 'package:happy_hour_server/server/server.dart';

import 'api/v2.dart';
import 'api/v2/auction.dart';
import 'api/v2/auth.dart';
import 'api/v2/bid.dart';
import 'api/v2/user.dart';

class MyServer extends Server {

	@override
	void onInit() {
		DaoFactory.instance.authDao.insert(Auth.exp(1, 'admin', 'admin', true, null));
		DaoFactory.instance.userDao.insert(User(139, 'Ciro', 'Fontana'));

		print(DaoFactory.instance.userDao.getAll());
		print(DaoFactory.instance.authDao.getAll());
		print(DaoFactory.instance.auctionDao.getAll());
		print(DaoFactory.instance.bidDao.getAll());

		router.addRoute('/api/v2/auth', dispatcher: ApiV2Auth());
		router.addRoute('/api/v2/auction', dispatcher: ApiV2Auction());
		router.addRoute('/api/v2/bid', dispatcher: ApiV2Bid());
		router.addRoute('/api/v2/user', dispatcher: ApiV2User());
		router.addRoute('/api/v2', dispatcher: ApiV2());
	}

}

Future main() => runServer(MyServer());