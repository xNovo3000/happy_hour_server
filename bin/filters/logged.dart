import 'dart:convert';
import 'dart:io';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auth.dart';
import 'package:happy_hour_server/server/request_filter.dart';
import 'package:happy_hour_server/server/response.dart';

class FilterLogged extends RequestFilter {

	// TODO: LOG IF OK OR NOT
	@override
	bool doFilter(HttpRequest request) {
		String? basic = request.headers.value('Authorization');
		if (basic == null || basic.length < 6) {
			return false;
		}
		basic = basic.substring(6);
		try {
			basic = utf8.decode(base64.decode(basic));
		} catch (e) {
			return false;
		}
		List<String> up = basic.split(':');
		if (up.length != 2) {
			return false;
		}
		Auth? auth = DaoFactory.instance.authDao.login(up[0], up[1]);
		if (auth != null) {
			request.session['Auth'] = auth;
			return true;
		} else {
			return false;
		}
	}

	@override
	Future onError(HttpRequest request) => Response.unauthorized(request);

}