import 'dart:convert';
import 'dart:io';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/user.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/response.dart';

import '../../filters/admin.dart';

class ApiV1User extends RequestDispatcher {

	final FilterAdmin _admin = FilterAdmin();

	@override
	Future doGet(HttpRequest request) {
		// check if the id exists
		int initial;
		try {
			initial = int.parse(request.uri.pathSegments[3]);
		} catch (e) {
			return Response.badRequest(request);
		}
		// get the user
		User? user = DaoFactory.instance.userDao.getFromInitial(initial);
		// check
		if (user != null) {
			return Response.ok(request, contentType: Response.jsonContent, body: user);
		} else {
			return Response.noContent(request);
		}
	}

	@override
	Future doDelete(HttpRequest request) {
		// check if the id exists
		int initial;
		try {
			initial = int.parse(request.uri.pathSegments[3]);
		} catch (e) {
			return Response.badRequest(request);
		}
		// get the user
		User? user = DaoFactory.instance.userDao.getFromInitial(initial);
		if (user == null) {
			return Response.noContent(request);
		}
		// delete and respond
		if (DaoFactory.instance.userDao.delete(user)) {
			return Response.ok(request);
		} else {
			return Response.internalServerError(request);
		}
	}

	@override
	Future doPost(HttpRequest request) async {
		// check if admin
		if (!_admin.doFilter(request)) {
			return _admin.onError(request);
		}
		// get the user
		User user;
		try {
			user = User.fromJson(json.decode(await utf8.decodeStream(request)));
		} catch (e) {
			return Response.badRequest(request);
		}
		// insert and respond
		if (DaoFactory.instance.userDao.insert(user)) {
			return Response.ok(request);
		} else {
			return Response.internalServerError(request);
		}
	}

	@override
	Future doPatch(HttpRequest request) async {
		// check if admin
		if (!_admin.doFilter(request)) {
			return _admin.onError(request);
		}
		// get the user
		User user;
		try {
			user = User.fromJson(json.decode(await utf8.decodeStream(request)));
		} catch (e) {
			return Response.badRequest(request);
		}
		// update and respond
		if (DaoFactory.instance.userDao.update(user)) {
			return Response.ok(request);
		} else {
			return Response.internalServerError(request);
		}
	}

}