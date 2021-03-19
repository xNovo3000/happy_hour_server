import 'dart:io';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auth.dart';
import 'package:happy_hour_server/persistance/model/user.dart';
import 'package:happy_hour_server/server/runner.dart';
import 'package:happy_hour_server/server/server.dart';

import 'api/v2.dart';
import 'api/v2/auction.dart';
import 'api/v2/auth.dart';
import 'api/v2/bid.dart';
import 'api/v2/image.dart';
import 'api/v2/user.dart';

class MyServer extends ServerV2 {

	@override
	void onInit() {
		super.onInit(); // load env

		DaoFactory.instance.authDao.insert(Auth.exp(1, 'admin', 'admin', 1, null));

		print(DaoFactory.instance.userDao.getAll());
		print(DaoFactory.instance.authDao.getAll());
		print(DaoFactory.instance.auctionDao.getAll());
		print(DaoFactory.instance.bidDao.getAll());

		router.addRoute('/api/v2/auth', ApiV2Auth());
		router.addRoute('/api/v2/auction', ApiV2Auction());
		router.addRoute('/api/v2/bid', ApiV2Bid());
		router.addRoute('/api/v2/image', ApiV2Image());
		router.addRoute('/api/v2/user', ApiV2User());
		router.addRoute('/api/v2', ApiV2());
	}

	@override
	SecurityContext? get securityContext => SecurityContext()
		..useCertificateChain('data/certificates/cert.pem')
		..usePrivateKey('data/certificates/key.pem', password: env['Passphrase']);

}

Future main() => runServerV2(MyServer());