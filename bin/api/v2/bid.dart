import 'dart:convert';
import 'dart:io';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auction.dart';
import 'package:happy_hour_server/persistance/model/auth.dart';
import 'package:happy_hour_server/persistance/model/bid.dart';
import 'package:happy_hour_server/persistance/model/user.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/request_filter.dart';
import 'package:happy_hour_server/server/response.dart';

import '../../filters/user.dart';
import '../../filters/v2/logged.dart';

class ApiV2Bid extends RequestDispatcher {

	final RequestFilter logged = FilterLoggedV2();
	final RequestFilter _user = FilterUser();

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
			case 'auctionID': return _doGetByAuctionID(request, int.tryParse(value));
			case 'userID': return _doGetByUserID(request, int.tryParse(value));
			default: return super.doGet(request);
		}
	}

	Future _doGetByAuctionID(HttpRequest request, int? auctionID) {
		// null check
		if (auctionID == null) {
			return Response.badRequest(request);
		}
		// get the auction
		final Auction? auction = DaoFactory.instance.auctionDao.get(auctionID);
		// null check
		if (auction == null) {
			return Response.noContent(request);
		}
		// get bids
		return Response.ok(request, contentType: Response.jsonContent, body: DaoFactory.instance.bidDao.getFromAuction(auction));
	}

	Future _doGetByUserID(HttpRequest request, int? userID) {
		// null check
		if (userID == null) {
			return Response.badRequest(request);
		}
		// get the auction
		final User? user = DaoFactory.instance.userDao.get(userID);
		// null check
		if (user == null) {
			return Response.noContent(request);
		}
		// get bids
		return Response.ok(request, contentType: Response.jsonContent, body: DaoFactory.instance.bidDao.getFromUser(user));
	}

	@override
	Future doPost(HttpRequest request) async {
		// logged required
		if (!logged.doFilter(request)) {
			return logged.onError(request);
		}
		// user required
		if (!_user.doFilter(request)) {
			return _user.onError(request);
		}
		// get the userID
		int userID = (request.session['Auth'] as Auth).user!.id;
		// get the new bid
		Bid newBid;
		try {
			newBid = Bid.fromJson(json.decode(await utf8.decodeStream(request)));
		} catch (e) {
			return Response.badRequest(request);
		}
		// check if the amount is the max possible
		double amount = 0.99;
		DaoFactory.instance.bidDao.getFromAuction(newBid.auction)
			.forEach((bid) => bid.amount > amount ? amount = bid.amount : null);
		if (amount > newBid.amount) {
			return Response.badRequest(request);
		}
		// try to insert
		if (DaoFactory.instance.bidDao.insert(newBid)) {
			return Response.ok(request);
		} else {
			return Response.internalServerError(request);
		}
	}

}