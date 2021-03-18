import 'dart:io';

import 'package:happy_hour_server/server/logger.dart';
import 'package:happy_hour_server/server/server.dart';

Future runServerV2(ServerV2 srv) {
	srv.onInit();
	if (srv.securityContext != null) {
		return HttpServer.bindSecure(InternetAddress.anyIPv4, 443, srv.securityContext!)
			.then((server) => server.listen(srv.router.handle))
			..catchError((e) => Logger.e(e));
	} else {
		return HttpServer.bind(InternetAddress.anyIPv4, 8080)
			.then((server) => server.listen(srv.router.handle))
			..catchError((e) => Logger.e(e));
	}
}