import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auction.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/request_filter.dart';
import 'package:happy_hour_server/server/response.dart';

import '../../filters/v2/logged.dart';
import '../../filters/v2/type_admin.dart';

class ApiV2Auction extends RequestDispatcher {

	final RequestFilter logged = FilterLoggedV2();
	final RequestFilter admin = FilterAccountTypeAdmin();

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
		final String key = request.uri.queryParameters.keys.first;
		final String value = request.uri.queryParameters.values.first;
		// dispatch
		switch (key) {
			case 'id': return _doGetByID(request, int.tryParse(value));
			case 'expiresAfter': return _doGetByExpiresAfter(request, int.tryParse(value));
			default: return super.doGet(request);
		}
	}

	Future _doGetByID(HttpRequest request, int? id) {
		// null check
		if (id == null) {
			return Response.badRequest(request);
		}
		// get the user
		final Auction? auction = DaoFactory.instance.auctionDao.get(id);
		// check if exists
		if (auction != null) {
			return Response.ok(request, contentType: Response.jsonContent, body: auction);
		} else {
			return Response.noContent(request);
		}
	}

	Future _doGetByExpiresAfter(HttpRequest request, int? timestamp) {
		// null check
		if (timestamp == null) {
			return Response.badRequest(request);
		}
		final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
		// get the user
		return Response.ok(request, contentType: Response.jsonContent, body: DaoFactory.instance.auctionDao.getAfterDate(date));
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
		// get the auction
		Auction auction;
		Uint8List imageData;
		try {
			final Map<String, dynamic> map = json.decode(await utf8.decodeStream(request));
			auction = Auction.fromJson(map);
			imageData = base64.decode(map['ImageData']);
		} catch (e) {
			return Response.badRequest(request);
		}
		// generate image string
		auction.imageName = '${DateTime.now().toUtc().millisecondsSinceEpoch}';
		// insert auction
		if (!DaoFactory.instance.auctionDao.insert(auction)) {
			return Response.internalServerError(request);
		}
		// insert the image
		try {
			File('data/images/${auction.imageName}.jpg')
				..createSync(recursive: true)
				..writeAsBytesSync(imageData);
			return Response.ok(request);
		} on FileSystemException {
			DaoFactory.instance.auctionDao.delete(auction);
			return Response.internalServerError(request);
		}
	}

}