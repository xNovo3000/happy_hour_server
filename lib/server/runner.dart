import 'dart:io';

import 'package:happy_hour_server/server/logger.dart';
import 'package:happy_hour_server/server/server.dart';

Future runServer(Server srv) => HttpServer.bind(InternetAddress.anyIPv4, 8080)
	.then(
		(HttpServer server) {
			srv.onInit();
			server.listen(srv.router.handle);
		}
	)
	.catchError((e) => Logger.e(e));

Future runServerV2(ServerV2 srv) => HttpServer.bind(InternetAddress.anyIPv4, 8080)
	.then(
		(HttpServer server) {
			srv.onInit();
			server.listen(srv.router.handle);
		}
	)
	.catchError((e) => Logger.e(e));