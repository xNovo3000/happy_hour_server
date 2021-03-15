import 'dart:convert';
import 'dart:io';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auction.dart';
import 'package:happy_hour_server/persistance/model/auth.dart';
import 'package:happy_hour_server/persistance/model/bid.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/response.dart';

import '../../../../filters/user.dart';

class ApiV1AuctionIDBids extends RequestDispatcher {

	Auction? auction;
	final FilterUser user = FilterUser();

	@override
	Future doGet(HttpRequest request) {
		// check if the auction exists
		if (auction == null) {
			return Response.noContent(request);
		}
		// send the content
		return Response.ok(request, contentType: Response.jsonContent, body: DaoFactory.instance.bidDao.getFromAuction(auction));
	}

	@override
	Future doPost(HttpRequest request) async {
		// check if the user exists
		if (!user.doFilter(request)) {
			return user.onError(request);
		}
		// ok, continue
		Bid newBid;
		try {
			Map<String, dynamic> map = json.decode(await utf8.decodeStream(request));
			// set the user inconditionally
			map['UserInitial'] = (request.session['Auth'] as Auth).user!.initial;
			newBid = Bid.fromJson(json.decode(await utf8.decodeStream(request)));
		} catch (e) {
			return Response.internalServerError(request);
		}
		// the auction must be not expired
		if (newBid.auction.expires.isBefore(DateTime.now().toUtc())) {
			return Response.forbidden(request);
		}
		// the amount must be higher than 1.00 and higher than the highest bid
		double compare = 1.00;
		List<Bid> bids = DaoFactory.instance.bidDao.getFromAuction(newBid.auction);
		bids.forEach((bid) => bid.amount > compare ? compare = bid.amount : null);
		// check
		if (newBid.amount > compare) {
			if (DaoFactory.instance.bidDao.insert(newBid)) {
				return Response.ok(request);
			} else {
				return Response.internalServerError(request);
			}
		} else {
			return Response.forbidden(request);
		}
	}

}