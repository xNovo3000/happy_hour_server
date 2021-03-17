import 'dart:convert';
import 'dart:io';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/user.dart';
import 'package:happy_hour_server/server/logger.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/request_filter.dart';
import 'package:happy_hour_server/server/response.dart';

import '../../filters/admin.dart';
import '../../filters/v2/logged.dart';

class ApiV2User extends RequestDispatcher {

	final RequestFilter logged = FilterLoggedV2();
	final RequestFilter admin = FilterAdmin();

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
			case 'id': return _doGetByID(request, int.tryParse(value));
			default: return super.doGet(request);
		}
	}

	Future _doGetByID(HttpRequest request, int? id) {
		// null check
		if (id == null) {
			return Response.badRequest(request);
		}
		// get the user
		User? user = DaoFactory.instance.userDao.get(id);
		// check if exists
		if (user != null) {
			return Response.ok(request, contentType: Response.jsonContent, body: user);
		} else {
			return Response.noContent(request);
		}
	}

	@override
	Future doPost(HttpRequest request) async {
		// logged required
		if (!logged.doFilter(request)) {
			return logged.onError(request);
		}
		// admin required
		if (!admin.doFilter(request)) {
			return admin.onError(request);
		}
		// get the user
		User user;
		try {
			user = User.fromJson(json.decode(await utf8.decodeStream(request)));
		} catch (e) {
			return Response.badRequest(request);
		}
		// the user exists, try to update
		if (DaoFactory.instance.userDao.insert(user)) {
			return Response.ok(request);
		} else {
			return Response.internalServerError(request);
		}
	}

	@override
	Future doPatch(HttpRequest request) async {
		// logged required
		if (!logged.doFilter(request)) {
			return logged.onError(request);
		}
		// admin required
		if (!admin.doFilter(request)) {
			return admin.onError(request);
		}
		// get the user
		User user;
		try {
			user = User.fromJson(json.decode(await utf8.decodeStream(request)));
		} catch (e) {
			return Response.badRequest(request);
		}
		// the user exists, try to update
		if (DaoFactory.instance.userDao.update(user)) {
			return Response.ok(request);
		} else {
			return Response.internalServerError(request);
		}
	}

	@override
	Future doDelete(HttpRequest request) {
		// logged required
		if (!logged.doFilter(request)) {
			return logged.onError(request);
		}
		// admin required
		if (!admin.doFilter(request)) {
			return admin.onError(request);
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
			case 'id': return _doDeleteByID(request, int.tryParse(value));
			default: return super.doGet(request);
		}
	}

	Future _doDeleteByID(HttpRequest request, int? id) {
		// null check
		if (id == null) {
			return Response.badRequest(request);
		}
		// get the user
		User? user = DaoFactory.instance.userDao.get(id);
		// check if exists
		if (user != null) {
			// exists, try to delete
			if (DaoFactory.instance.userDao.delete(user)) {
				return Response.ok(request);
			} else {
				return Response.internalServerError(request);
			}
		} else {
			return Response.noContent(request);
		}
	}

}