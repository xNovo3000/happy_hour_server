import 'dart:io';

import 'package:happy_hour_server/server/logger.dart';
import 'package:happy_hour_server/server/router.dart';

abstract class ServerV2 {

	final RouterV2 router = RouterV2();
	final Map<String, String> env = <String, String>{};

	void onInit() {
		try {
			final List<String> lines = File('.env').readAsLinesSync();
			lines.forEach((line) {
				final List<String> values = line.split('=');
				env[values[0]] = values[1];
			});
		} on FileSystemException catch (e) {
			Logger.e(e);
		}
	}

	SecurityContext? get securityContext => null;

}