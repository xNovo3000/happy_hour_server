import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:happy_hour_server/persistance/connection/factory.dart';
import 'package:happy_hour_server/persistance/model/auction.dart';
import 'package:happy_hour_server/server/logger.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/response.dart';

import '../../filters/admin.dart';
import 'auction/id.dart';

class ApiV1Auction extends RequestDispatcher {

	final ApiV1AuctionID _id = ApiV1AuctionID();
	final FilterAdmin _admin = FilterAdmin();

	@override
	Future doGet(HttpRequest request) => _id.doGet(request);

	@override
	Future doPost(HttpRequest request) async {
		// filter for admin
		if (!_admin.doFilter(request)) {
			return _admin.onError(request);
		}
		// ok, continue
		Auction newAuction;
		Uint8List imageData;
		try {
			Map<String, dynamic> map = json.decode(await utf8.decodeStream(request));
			newAuction = Auction.fromJson(map);
			imageData = base64.decode(map['ImageData']);
		} catch (e) {
			return Response.badRequest(request);
		}
		// assign a name to the image and set to newAuction
		newAuction.imageName = '${DateTime.now().toUtc().millisecondsSinceEpoch}';
		// save the auction
		bool result = DaoFactory.instance.auctionDao.insert(newAuction);
		if (result == false) {
			return Response.internalServerError(request);
		}
		// save the file
		try {
			File('data/images/${newAuction.imageName}.jpg')
				..createSync(recursive: true)
				..writeAsBytesSync(imageData);
			return Response.ok(request);
		} on FileSystemException catch (e) {
			Logger.e(e);
			DaoFactory.instance.auctionDao.delete(newAuction);
			return Response.internalServerError(request);
		}
	}

	@override
	Future doDelete(HttpRequest request) => _id.doDelete(request);

}