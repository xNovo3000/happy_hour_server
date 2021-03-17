import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auth.dart';
import 'package:happy_hour_server/persistance/model/user.dart';
import 'package:happy_hour_server/server/logger.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/request_filter.dart';
import 'package:happy_hour_server/server/response.dart';

import '../../filters/admin.dart';
import '../../filters/v2/logged.dart';

class ApiV2Auth extends RequestDispatcher {

	final RequestFilter logged = FilterLoggedV2();
	final RequestFilter _admin = FilterAdmin();
	final Random random = Random.secure();

	@override
	Future doGet(HttpRequest request) {
		// logged required
		if (!logged.doFilter(request)) {
			return logged.onError(request);
		}
		// check if has query
		if (!request.uri.hasQuery) {
			return Response.badRequest(request);
		}
		// get the first query
		String key = request.uri.queryParameters.keys.first;
		String value = request.uri.queryParameters.values.first;
		// dispatch
		switch (key) {
			case 'username': return _doGetByUsername(request, value);
			default: return super.doGet(request);
		}
	}

	Future _doGetByUsername(HttpRequest request, String username) {
		// get the auth
		Auth auth = request.session['Auth'];
		// ok, dispatch
		if (auth.admin || auth.username == username) {
			Auth? dbAuth = DaoFactory.instance.authDao.getFromUsername(username);
			if (dbAuth != null) {
				return Response.ok(request, contentType: Response.jsonContent, body: dbAuth);
			} else {
				return Response.noContent(request);
			}
		} else {
			return Response.forbidden(request);
		}
	}

	@override
	Future doPost(HttpRequest request) async {
		// not logged required
		if (logged.doFilter(request)) {
			return logged.onError(request);
		}
		// get the user
		Auth auth;
		try {
			auth = Auth.fromJson(json.decode(await utf8.decodeStream(request)), random);
		} catch (e) {
			return Response.badRequest(request);
		}
		// set admin false for safety reasons
		auth.admin = false;
		// the user exists, try to update
		if (DaoFactory.instance.authDao.insert(auth)) {
			return Response.ok(request);
		} else {
			return Response.internalServerError(request);
		}
	}

}