import 'dart:io';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auction.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/response.dart';

import 'id/bids.dart';
import 'id/image.dart';

class ApiV1AuctionID extends RequestDispatcher {

	final ApiV1AuctionIDBids _bids = ApiV1AuctionIDBids();
	final ApiV1AuctionIDImage _image = ApiV1AuctionIDImage();

	@override
	Future doGet(HttpRequest request) {
		// check if the id exists
		int id;
		try {
			id = int.parse(request.uri.pathSegments[3]);
		} catch (e) {
			return Response.badRequest(request);
		}
		// get the auction
		Auction? auction = DaoFactory.instance.auctionDao.get(id);
		// check if auction is wanted or other
		if (request.uri.pathSegments.length == 4) {
			if (auction != null) {
				return Response.ok(request, contentType: Response.jsonContent, body: auction);
			} else {
				return Response.noContent(request);
			}
		} else { // there is another
			switch (request.uri.pathSegments[4]) {
				case 'bids': _bids.auction = auction; return _bids.doGet(request);
				case 'image': _image.auction = auction; return _image.doGet(request);
				default: return Response.notImplemented(request);
			}
		}
	}

	@override
	Future doPost(HttpRequest request) {
		/// check if the id exists
		int id;
		try {
			id = int.parse(request.uri.pathSegments[3]);
		} catch (e) {
			return Response.badRequest(request);
		}
		// get the auction
		Auction? auction = DaoFactory.instance.auctionDao.get(id);
		// check if auction is wanted or other
		if (request.uri.pathSegments.length == 4) {
			if (auction != null) {
				return Response.ok(request, contentType: Response.jsonContent, body: auction);
			} else {
				return Response.noContent(request);
			}
		} else { // there is another
			switch (request.uri.pathSegments[4]) {
				case 'bids': _bids.auction = auction; return _bids.doGet(request);
				default: return Response.notImplemented(request);
			}
		}
	}

	@override
	Future doDelete(HttpRequest request) {
		// check if the id exists
		int id;
		try {
			id = int.parse(request.uri.pathSegments[3]);
		} catch (e) {
			return Response.badRequest(request);
		}
		// get the auction
		Auction? auction = DaoFactory.instance.auctionDao.get(id);
		// check if the auction exists
		if (auction == null) {
			return Response.noContent(request);
		}
		// try to delete
		if (DaoFactory.instance.auctionDao.delete(auction)) {
			return Response.ok(request);
		} else {
			return Response.internalServerError(request);
		}
	}

}