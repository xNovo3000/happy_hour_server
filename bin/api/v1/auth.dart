import 'dart:io';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auth.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/response.dart';

import '../../filters/admin.dart';

class ApiV1Auth extends RequestDispatcher {

	final FilterAdmin _admin = FilterAdmin();

	@override
	Future doGet(HttpRequest request) {
		// check if there is the username
		String username;
		try {
			username = request.uri.pathSegments[3];
		} catch (e) {
			return Response.badRequest(request);
		}
		// try to get
		if (_admin.doFilter(request)) {
			return _doGetAdmin(request, username);
		} else {
			return _doGetNotAdmin(request, username);
		}
	}

	Future _doGetNotAdmin(HttpRequest request, String username) {
		if (username != (request.session['Auth'] as Auth).username) {
			return Response.forbidden(request);
		}
		return _doGetAdmin(request, username);
	}

	Future _doGetAdmin(HttpRequest request, String username) {
		Auth? auth = DaoFactory.instance.authDao.getFromUsername(username);
		if (auth != null) {
			return Response.ok(request, contentType: Response.jsonContent, body: auth);
		} else {
			return Response.noContent(request);
		}
	}

}