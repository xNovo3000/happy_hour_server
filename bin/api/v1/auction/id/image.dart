import 'dart:io';
import 'dart:typed_data';

import 'package:happy_hour_server/persistance/model/auction.dart';
import 'package:happy_hour_server/server/logger.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/response.dart';

class ApiV1AuctionIDImage extends RequestDispatcher {

	Auction? auction;

	@override
	Future doGet(HttpRequest request) {
		if (auction == null) {
			return Response.badRequest(request);
		}
		Uint8List imageData;
		try {
			imageData = File('data/images/${auction!.imageName}.jpg').readAsBytesSync();
		} on FileSystemException catch (e) {
			Logger.e(e);
			return Response.internalServerError(request);
		}
		return Response.ok(request, contentType: Response.jpegContent, body: imageData);
	}

}