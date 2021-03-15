import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auth.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/response.dart';

class ApiRegister extends RequestDispatcher {

	final Random random = Random.secure();

	@override
	Future doPost(HttpRequest request) async {
		Auth auth;
		try {
			Map<String, dynamic> map = json.decode(await utf8.decodeStream(request));
			map['Admin'] = false;
			auth = Auth.fromJson(map, random);
		} catch (e) {
			return Response.badRequest(request);
		}
		if (DaoFactory.instance.authDao.insert(auth)) {
			return Response.ok(request);
		} else {
			return Response.internalServerError(request);
		}
	}

}