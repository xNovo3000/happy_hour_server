import 'dart:io';
import 'dart:typed_data';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auction.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/request_filter.dart';
import 'package:happy_hour_server/server/response.dart';

import '../../filters/v2/logged.dart';
import '../../filters/v2/type_admin.dart';

class ApiV2Image extends RequestDispatcher {

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
			case 'auctionID': return _doGetByAuctionID(request, int.tryParse(value));
			default: return super.doGet(request);
		}
	}

	Future _doGetByAuctionID(HttpRequest request, int? auctionID) {
		// null check
		if (auctionID == null) {
			return Response.badRequest(request);
		}
		// get the user
		final Auction? auction = DaoFactory.instance.auctionDao.get(auctionID);
		// check if the auction exists
		if (auction != null) {
			try {
				Uint8List imageBytes = File('data/images/${auction.imageName}.jpg').readAsBytesSync();
				return Response.ok(request, contentType: Response.jpegContent, body: imageBytes);
			} on FileSystemException {
				return Response.internalServerError(request);
			}
		} else {
			return Response.noContent(request);
		}
	}
	
}