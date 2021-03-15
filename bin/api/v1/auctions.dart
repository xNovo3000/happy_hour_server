import 'dart:io';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/response.dart';

class ApiV1Auctions extends RequestDispatcher {

	@override
	Future doGet(HttpRequest request) {
		// check if the query is present
		if (!request.uri.hasQuery) {
			return Response.badRequest(request);
		}
		// take the first query
		String key = request.uri.queryParameters.keys.first;
		String value = request.uri.queryParameters.values.first;
		// check key
		switch (key) {
			case 'expiresAfter': return _doGetExpiresAfter(request, int.tryParse(value));
			case 'query': // TODO: IMPLEMENT SEARCH BY QUERY
			default: return super.doGet(request);
		}
	}

	Future _doGetExpiresAfter(HttpRequest request, int? timestamp) {
		// check if the timestamp is ok
		if (timestamp == null) {
			return Response.badRequest(request);
		}
		// ok, send the auctions
		return Response.ok(
			request,
			contentType: Response.jsonContent,
			body: DaoFactory.instance.auctionDao.getAfterDate(DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true)),
		);
	}

}